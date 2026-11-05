-- Duplicate Emails
-- https://leetcode.com/problems/duplicate-emails/
-- Dialect: mysql | Solved: 2026-11-05

# Write your MySQL query statement below
SELECT email AS Email
FROM Person AS p
GROUP BY email
HAVING COUNT(*) > 1;
