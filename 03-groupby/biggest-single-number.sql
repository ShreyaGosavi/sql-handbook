-- Biggest Single Number
-- https://leetcode.com/problems/biggest-single-number/
-- Dialect: mysql | Solved: 2026-11-06

# Write your MySQL query statement below
SELECT MAX(num) AS num
FROM MyNumbers
WHERE num IN (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
);
