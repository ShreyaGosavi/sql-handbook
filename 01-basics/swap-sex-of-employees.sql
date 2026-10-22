-- Swap Sex of Employees
-- https://leetcode.com/problems/swap-sex-of-employees/
-- Dialect: mysql | Solved: 2026-10-22

# Write your MySQL query statement below
UPDATE Salary
SET sex = CASE
WHEN sex = 'm' THEN 'f'
ELSE 'm'
END ;
