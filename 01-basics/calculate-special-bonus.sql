-- Calculate Special Bonus
-- https://leetcode.com/problems/calculate-special-bonus/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT e.employee_id, 
CASE WHEN e.employee_id % 2 != 0 AND e.name NOT LIKE 'M%' THEN e.salary
ELSE 0
END AS bonus
FROM Employees AS e
ORDER BY e.employee_id ASC;
