-- Fix Names in a Table
-- https://leetcode.com/problems/fix-names-in-a-table/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below

SELECT
    user_id,
    CONCAT(
        UPPER(LEFT(name, 1)),
        LOWER(SUBSTRING(name, 2))
    ) AS name
FROM Users
ORDER BY user_id;
