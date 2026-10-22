-- Recyclable and Low Fat Products
-- https://leetcode.com/problems/recyclable-and-low-fat-products/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT p.product_id
FROM Products AS p
WHERE p.low_fats = 'Y'
AND p.recyclable = 'Y';
