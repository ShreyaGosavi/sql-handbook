-- Primary Department for Each Employee
-- https://leetcode.com/problems/primary-department-for-each-employee/
-- Dialect: mysql | Solved: 2026-11-05

# Write your MySQL query statement below
SELECT e.employee_id, e.department_id
FROM Employee AS e
WHERE e.primary_flag = 'Y'

UNION

SELECT e.employee_id, e.department_id
FROM Employee AS e
GROUP BY e.employee_id
HAVING COUNT(*) = 1;
