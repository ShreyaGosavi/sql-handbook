-- Group Sold Products By The Date
-- https://leetcode.com/problems/group-sold-products-by-the-date/
-- Dialect: mysql | Solved: 2026-10-22

# Write your MySQL query statement below
SELECT sell_date, COUNT(DISTINCT product) AS num_sold,
GROUP_CONCAT(DISTINCT product ORDER BY product ASC SEPARATOR ',') AS products
FROM Activities 
GROUP BY sell_date
ORDER BY sell_date ASC;
