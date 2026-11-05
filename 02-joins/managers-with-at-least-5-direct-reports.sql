-- Managers with at Least 5 Direct Reports
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/
-- Dialect: mysql | Solved: 2026-10-23

# Write your MySQL query statement below
SELECT e1.name
FROM Employee AS e1
JOIN Employee AS e2
ON e1.id = e2.managerId
GROUP BY e1.id
HAVING COUNT(*) >= 5;
