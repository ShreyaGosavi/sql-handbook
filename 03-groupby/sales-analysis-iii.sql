-- Sales Analysis III
-- https://leetcode.com/problems/sales-analysis-iii/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT p.product_id, p.product_name
FROM Sales AS s
LEFT JOIN Product AS p
ON s.product_id = p.product_id
GROUP BY s.product_id
HAVING MIN(s.sale_date) >= '2019-01-01'
AND MAX(s.sale_date) <= '2019-03-31';
