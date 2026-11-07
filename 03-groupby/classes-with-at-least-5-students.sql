-- Classes With at Least 5 Students
-- https://leetcode.com/problems/classes-with-at-least-5-students/
-- Dialect: mysql | Solved: 2026-11-06

# Write your MySQL query statement below
SELECT class 
FROM Courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5;
