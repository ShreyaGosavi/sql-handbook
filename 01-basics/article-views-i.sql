-- Article Views I
-- https://leetcode.com/problems/article-views-i/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT DISTINCT v.author_id AS id
FROM Views AS v
WHERE v.author_id = v.viewer_id
ORDER BY v.author_id ASC;
