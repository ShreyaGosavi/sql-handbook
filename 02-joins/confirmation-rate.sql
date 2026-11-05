-- Confirmation Rate
-- https://leetcode.com/problems/confirmation-rate/
-- Dialect: mysql | Solved: 2026-10-23

# Write your MySQL query statement below
SELECT s.user_id, ROUND(COUNT(CASE WHEN action = 'confirmed' THEN 1 END) / COUNT(*), 2) AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY s.user_id;
