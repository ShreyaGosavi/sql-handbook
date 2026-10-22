-- Invalid Tweets
-- https://leetcode.com/problems/invalid-tweets/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT t.tweet_id
FROM Tweets AS t
WHERE CHAR_LENGTH(t.content) > 15;
