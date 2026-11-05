-- Sales Person
-- https://leetcode.com/problems/sales-person/
-- Dialect: mysql | Solved: 2026-10-24

# Write your MySQL query statement below
SELECT s.name
FROM SalesPerson AS s
WHERE s.sales_id NOT IN (
    SELECT o.sales_id 
    FROM Orders AS o
    JOIN Company AS c
    ON o.com_id = c.com_id
    WHERE c.name = 'RED'
);
