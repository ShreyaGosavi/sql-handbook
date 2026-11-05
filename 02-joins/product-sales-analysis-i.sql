-- Product Sales Analysis I
-- https://leetcode.com/problems/product-sales-analysis-i/
-- Dialect: mysql | Solved: 2026-10-22

# Write your MySQL query statement below
SELECT p.product_name, s.year, s.price
FROM Sales AS s
LEFT JOIN Product AS p
ON s.product_id = p.product_id;
