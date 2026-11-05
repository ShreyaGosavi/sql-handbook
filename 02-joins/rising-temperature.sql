-- Rising Temperature
-- https://leetcode.com/problems/rising-temperature/
-- Dialect: mysql | Solved: 2026-10-22

# Write your MySQL query statement below
SELECT w1.id
FROM Weather AS w1
CROSS JOIN Weather AS w2
WHERE DATEDIFF(w1.recordDate, w2.recordDate) = 1
AND w1.temperature > w2.temperature;
