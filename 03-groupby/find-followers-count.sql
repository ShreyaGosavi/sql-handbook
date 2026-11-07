-- Find Followers Count
-- https://leetcode.com/problems/find-followers-count/
-- Dialect: mysql | Solved: 2026-11-06

# Write your MySQL query statement below
SELECT user_id, COUNT(DISTINCT follower_id) AS followers_count
FROM Followers
GROUP BY user_id;
