-- Find Users With Valid E-Mails
-- https://leetcode.com/problems/find-users-with-valid-e-mails/
-- Dialect: mysql | Solved: 2026-10-21

SELECT user_id, name, mail
FROM Users
WHERE REGEXP_LIKE(
    mail,
    '^[a-zA-Z][a-zA-Z0-9._-]*@leetcode\\.com$',
    'c'
);
