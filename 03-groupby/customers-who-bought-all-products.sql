-- Customers Who Bought All Products
-- https://leetcode.com/problems/customers-who-bought-all-products/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT c.customer_id
FROM Customer AS c
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (SELECT COUNT(*) FROM Product);
