-- Find Customer Referee
-- https://leetcode.com/problems/find-customer-referee/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT c.name
FROM Customer AS c
WHERE c.referee_id != 2
OR c.referee_id IS NULL;
