-- Combine Two Tables
-- https://leetcode.com/problems/combine-two-tables/
-- Dialect: mysql | Solved: 2026-10-22

# Write your MySQL query statement below
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person AS p
LEFT JOIN Address AS a
ON p.personId = a.personId;
