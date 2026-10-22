#!/usr/bin/env python3
"""
save_sql.py - pull your latest Accepted LeetCode SQL submissions, ask which
segment each belongs in, save as .sql files in the sql-handbook repo, push.

Usage (run from anywhere):
    python save_sql.py            # last 10 SQL solves
    python save_sql.py 20         # last 20 SQL solves

Setup:
  1. Put this file in the root of your sql-handbook repo (or set SQL_REPO).
  2. Create a file named .leetcode_env in the repo root with:
         LEETCODE_SESSION=<cookie value>
         CSRFTOKEN=<cookie value>
         CF_CLEARANCE=<cookie value>      (needed if you get a 403)
         USER_AGENT=<navigator.userAgent from your browser console>
     (browser -> leetcode.com -> DevTools -> Application -> Cookies)
  3. Add to .gitignore:  .leetcode_env
  4. pip install requests
"""
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

import requests

REPO = Path(os.environ.get("SQL_REPO", Path(__file__).resolve().parent))
SQL_LANGS = {"mysql", "mssql", "oraclesql", "postgresql", "pythondata"}  # pythondata skipped below
SQL_LANGS.discard("pythondata")
SKIP_DIRS = {".git", ".github", "templates", "__pycache__"}


# ---------- config ----------
def load_cookies():
    """Returns (cookies, user_agent). Reads env vars, then .leetcode_env."""
    cfg = {k: os.environ.get(k) for k in
           ("LEETCODE_SESSION", "CSRFTOKEN", "CF_CLEARANCE", "USER_AGENT")}
    env_file = REPO / ".leetcode_env"
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            if "=" in line and not line.strip().startswith("#"):
                k, v = line.split("=", 1)
                if k.strip() in cfg:
                    cfg[k.strip()] = v.strip()
    if not cfg["LEETCODE_SESSION"]:
        sys.exit("Missing LEETCODE_SESSION. See setup notes at top of the script.")
    cookies = {"LEETCODE_SESSION": cfg["LEETCODE_SESSION"]}
    if cfg["CSRFTOKEN"]:
        cookies["csrftoken"] = cfg["CSRFTOKEN"]
    if cfg["CF_CLEARANCE"]:
        cookies["cf_clearance"] = cfg["CF_CLEARANCE"]
    ua = cfg["USER_AGENT"] or (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36")
    return cookies, ua


# ---------- leetcode ----------
def filter_sql(subs, n):
    """Newest-first Accepted SQL submissions, one per problem."""
    found, seen = [], set()
    for s in sorted(subs, key=lambda x: int(x["timestamp"]), reverse=True):
        if s["status_display"] != "Accepted" or s["lang"] not in SQL_LANGS:
            continue
        if s["title_slug"] in seen:
            continue
        seen.add(s["title_slug"])
        found.append(s)
        if len(found) == n:
            break
    return found


def load_from_file(path, n):
    import json
    data = json.loads(path.read_text(encoding="utf-8"))
    if isinstance(data, dict):
        data = data.get("submissions_dump", [])
    return filter_sql(data, n)


def fetch_sql_solves(n, cookies, ua):
    """Latest Accepted SQL submissions, one per problem (newest first)."""
    found, seen = [], set()
    offset = 0
    headers = {"Referer": "https://leetcode.com/submissions/", "User-Agent": ua,
               "Accept": "application/json"}
    if "csrftoken" in cookies:
        headers["x-csrftoken"] = cookies["csrftoken"]
    while len(found) < n and offset < 500:
        r = requests.get(
            "https://leetcode.com/api/submissions/",
            params={"offset": offset, "limit": 20},
            cookies=cookies,
            headers=headers,
            timeout=20,
        )
        if r.status_code != 200:
            sys.exit(f"LeetCode returned {r.status_code}. 401 = bad/expired session cookie; "
                     "403 = Cloudflare block (add CF_CLEARANCE and USER_AGENT to .leetcode_env).")
        data = r.json()
        for s in data.get("submissions_dump", []):
            if s["status_display"] != "Accepted" or s["lang"] not in SQL_LANGS:
                continue
            if s["title_slug"] in seen:
                continue
            seen.add(s["title_slug"])
            found.append(s)
            if len(found) == n:
                break
        if not data.get("has_next"):
            break
        offset += 20
    return found


# ---------- repo ----------
def segments():
    return sorted(
        p.name for p in REPO.iterdir()
        if p.is_dir() and p.name not in SKIP_DIRS and not p.name.startswith(".")
    )


def already_saved(slug):
    for p in REPO.rglob("*.sql"):
        if p.stem == slug or p.stem.endswith(f"-{slug}"):
            return p
    return None


def slugify(text):
    return re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")


def choose_segment(last):
    segs = segments()
    print("\n  Segments:")
    for i, s in enumerate(segs, 1):
        print(f"   {i}. {s}")
    hint = f", Enter = same as last ({last})" if last else ""
    print(f"   n. new segment   s. skip this one{hint}")
    while True:
        c = input("  Choose: ").strip().lower()
        if c == "" and last:
            return last
        if c == "s":
            return None
        if c == "n":
            name = slugify(input("  New segment name: "))
            if name:
                (REPO / name).mkdir(exist_ok=True)
                return name
        elif c.isdigit() and 1 <= int(c) <= len(segs):
            return segs[int(c) - 1]
        print("  Invalid choice.")


def write_solution(seg, sub):
    slug = sub["title_slug"]
    path = REPO / seg / f"{slug}.sql"
    when = datetime.fromtimestamp(int(sub["timestamp"])).strftime("%Y-%m-%d")
    header = (
        f"-- {sub['title']}\n"
        f"-- https://leetcode.com/problems/{slug}/\n"
        f"-- Dialect: {sub['lang']} | Solved: {when}\n\n"
    )
    path.write_text(header + sub["code"].strip() + "\n", encoding="utf-8")
    return path


def git(*args):
    return subprocess.run(["git", "-C", str(REPO), *args], capture_output=True, text=True)


def push(saved):
    git("add", "-A")
    msg = f"Add {len(saved)} SQL solution(s): " + ", ".join(t for t, _ in saved[:5])
    if len(saved) > 5:
        msg += "..."
    c = git("commit", "-m", msg)
    if c.returncode != 0:
        print("Nothing to commit:", c.stdout.strip() or c.stderr.strip())
        return
    p = git("push")
    print(p.stdout or p.stderr)
    print("Pushed." if p.returncode == 0 else "Push failed - check the message above.")


# ---------- main ----------
def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    dump = REPO / "submissions.json"
    if dump.exists():
        print(f"Reading {dump.name} (browser export)...")
        subs = load_from_file(dump, n)
    else:
        cookies, ua = load_cookies()
        print(f"Fetching your last {n} accepted SQL solves...")
        subs = fetch_sql_solves(n, cookies, ua)
    if not subs:
        sys.exit("No accepted SQL submissions found.")

    saved, last = [], None
    for i, sub in enumerate(subs, 1):
        print(f"\n[{i}/{len(subs)}] {sub['title']}  ({sub['lang']})")
        existing = already_saved(sub["title_slug"])
        if existing:
            print(f"  already saved at {existing.relative_to(REPO)} - skipping")
            continue
        print("  " + sub["code"].strip().replace("\n", "\n  ")[:400])
        seg = choose_segment(last)
        if seg is None:
            continue
        last = seg
        path = write_solution(seg, sub)
        saved.append((sub["title"], path))
        print(f"  saved -> {path.relative_to(REPO)}")

    if dump.exists():
        dump.unlink()
        print("\nDeleted submissions.json (re-export next time).")
    if saved:
        push(saved)
    else:
        print("\nNothing new saved.")


if __name__ == "__main__":
    main()
