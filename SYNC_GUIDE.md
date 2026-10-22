# sql-handbook: Sync Guide

How to save your latest LeetCode SQL solutions into this repo using `save_sql.py`.

Repo folder: `~/Desktop/sql-handbook`

---

## One-time setup (already done)

- `save_sql.py` is in the repo root.
- `.gitignore` contains these lines, so private files never get pushed:
  ```
  .leetcode_env
  submissions.json
  ```
- `pip install requests` has been run.
- `.leetcode_env` is not needed in browser-export mode. You can delete it.

---

## Every time you want to sync

### Step 1: Export from LeetCode (browser)

1. Open any page on leetcode.com. You must be logged in.
2. Open DevTools: `Cmd + Option + I` on Mac, then go to the **Console** tab.
3. If Chrome blocks pasting, type `allow pasting` by hand and press Enter.
4. Paste this and press Enter:

```js
(async()=>{let all=[],off=0;while(off<100){const r=await fetch(`/api/submissions/?offset=${off}&limit=20`,{credentials:'include'});if(!r.ok){console.log('failed',r.status);return}const d=await r.json();all.push(...d.submissions_dump);if(!d.has_next)break;off+=20;await new Promise(t=>setTimeout(t,500))}const a=document.createElement('a');a.href=URL.createObjectURL(new Blob([JSON.stringify(all)],{type:'application/json'}));a.download='submissions.json';a.click();console.log('downloaded',all.length,'submissions')})()
```

5. Wait for `downloaded N submissions`. The file lands in your Downloads folder.

Tip: to avoid pasting every time, save the code as a snippet: DevTools, then **Sources**, then **Snippets**, then **New snippet**. Paste it there and run it with `Cmd + Enter`.

### Step 2: Move the file into the repo (terminal)

```
cd ~/Desktop/sql-handbook
mv ~/Downloads/submissions.json .
```

If Chrome named it `submissions (1).json`, use that name:
```
mv ~/Downloads/"submissions (1).json" submissions.json
```

Optional check (the file should be many KB and start with `[{`):
```
wc -c submissions.json
head -c 80 submissions.json
```

### Step 3: Run the script

```
python save_sql.py 10
```

Use `10` or `20`, depending on how many problems you solved.

For each problem you will be asked:

| Input | Action |
|-------|--------|
| a number | save into that existing segment |
| `n` | create a new segment (you type the name) |
| `s` | skip this problem |
| Enter | reuse the segment you picked last |

At the end the script commits, pushes to GitHub, and deletes `submissions.json`.

Problems already saved in the repo are skipped automatically.

---

## Troubleshooting

### Browser console

| Problem | Cause | Fix |
|---------|-------|-----|
| Console says `failed 401` | Logged out, or session expired | Log in to leetcode.com in that tab, reload the page, run the snippet again |
| Console says `failed 403` | Cloudflare check is blocking | Reload leetcode.com, complete any "verify you are human" check, wait until the page loads normally, run the snippet again. Make sure you are on a leetcode.com tab, not another site |
| Chrome refuses to paste | Chrome's paste protection | Type `allow pasting` by hand, press Enter, then paste again |
| `copy is not defined` | Old snippet that used `copy()` | Use the download snippet above, which doesn't need `copy()` |
| Nothing downloads | Browser blocked the download | Allow downloads for leetcode.com in Chrome, or check the Downloads folder for a blocked-file notice |
| Snippet prints no error but file is tiny | Fetch returned an empty list | Check you are logged in and have submitted at least one SQL problem |

### Terminal / script

| Problem | Cause | Fix |
|---------|-------|-----|
| `JSONDecodeError: Expecting value` | `submissions.json` isn't real JSON (for example, it holds `undefined`) | Run `wc -c submissions.json`. If it is about 50 bytes or less, redo Step 1 and Step 2 |
| `No such file or directory` when moving | File isn't in Downloads under that name | Run `ls ~/Downloads \| grep submissions` to see the real name |
| `No accepted SQL submissions found` | No matching submissions in the export | Only Accepted solves in MySQL, MS SQL, Oracle or PostgreSQL count. Export more history, or solve and submit first |
| Everything says "already saved" | Those problems are in the repo already | Nothing to do. Solve new problems first |
| `Push failed` | Git or authentication issue | Run `git status` and `git push` by hand and read the message. Check your GitHub login or token |
| `Nothing to commit` | No new files were written | Normal if everything was skipped |
| `python: command not found` | Python isn't on the path | Use `python3 save_sql.py 10` |
| `ModuleNotFoundError: requests` | Dependency missing | Run `pip install requests` |
| `submissions.json` shows in `git status` | `.gitignore` entry missing | Run `echo "submissions.json" >> .gitignore` |

### 401 / 403 when running the script without `submissions.json`

If no `submissions.json` exists, the script tries to call LeetCode directly using `.leetcode_env`. This usually fails with a 403 from Cloudflare, and a 401 means a bad or expired cookie. The fix is to **use the browser export (Steps 1 to 3)** instead. It is the reliable method.

If you still want direct mode, `.leetcode_env` can contain these keys, each on its own line as `KEY=value` with no quotes:
`LEETCODE_SESSION`, `CSRFTOKEN`, `CF_CLEARANCE`, `USER_AGENT`.
Get them from DevTools, then **Application**, then **Cookies**, then leetcode.com. Get your User-Agent by typing `navigator.userAgent` in the console.

---

## Safety rules

- Never commit `.leetcode_env`. It holds your login cookie.
- Never paste cookie values into chat, screenshots or GitHub.
- If a cookie ever leaks, log out of LeetCode to invalidate it.
- Before the first push on a new machine, run `git status` and confirm that `.leetcode_env` and `submissions.json` are not listed.
