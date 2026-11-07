-- Queries Quality and Percentage
-- https://leetcode.com/problems/queries-quality-and-percentage/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT query_name,
    ROUND(SUM(rating / position) / COUNT(*), 2) AS quality,
    ROUND(SUM(rating < 3) * 100 / COUNT(*), 2) AS poor_query_percentage
FROM Queries 
GROUP BY query_name;
