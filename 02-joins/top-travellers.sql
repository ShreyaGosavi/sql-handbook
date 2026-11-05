-- Top Travellers
-- https://leetcode.com/problems/top-travellers/
-- Dialect: mysql | Solved: 2026-10-26

# Write your MySQL query statement below
SELECT u.name, IFNULL(SUM(r.distance), 0) AS travelled_distance
FROM Users AS u
LEFT JOIN Rides AS r
ON u.id = r.user_id
GROUP BY u.id
ORDER BY travelled_distance DESC, u.name ASC;
