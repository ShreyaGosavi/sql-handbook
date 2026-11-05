-- The Number of Employees Which Report to Each Employee
-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/
-- Dialect: mysql | Solved: 2026-11-05

# Write your MySQL query statement below
SELECT e2.employee_id, e2.name, COUNT(*) AS reports_count, ROUND(AVG(e1.age), 0) AS average_age
FROM Employees AS e1
JOIN Employees AS e2
ON e1.reports_to = e2.employee_id
GROUP BY e2.employee_id
ORDER BY e2.employee_id;
