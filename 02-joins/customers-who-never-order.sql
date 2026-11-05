-- Customers Who Never Order
-- https://leetcode.com/problems/customers-who-never-order/
-- Dialect: mysql | Solved: 2026-11-05

# Write your MySQL query statement below
SELECT c.name AS Customers
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.id = o.customerId
WHERE o.customerId IS NULL;
