-- Find Total Time Spent by Each Employee
-- https://leetcode.com/problems/find-total-time-spent-by-each-employee/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT t.event_day AS day, t.emp_id, SUM(t.total) AS total_time
FROM (
    SELECT e.emp_id, e.event_day, e.out_time - e.in_time AS total
    FROM Employees AS e
    ) AS t
GROUP BY t.event_day, t.emp_id;
