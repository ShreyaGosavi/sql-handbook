-- Project Employees I
-- https://leetcode.com/problems/project-employees-i/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT p.project_id, ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project AS p
LEFT JOIN Employee AS e
ON p.employee_id = e.employee_id
GROUP BY p.project_id;
