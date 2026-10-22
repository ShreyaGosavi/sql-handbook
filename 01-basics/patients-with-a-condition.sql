-- Patients With a Condition
-- https://leetcode.com/problems/patients-with-a-condition/
-- Dialect: mysql | Solved: 2026-10-21

# Write your MySQL query statement below
SELECT p.patient_id, p.patient_name, p.conditions
FROM Patients AS p
WHERE p.conditions LIKE 'DIAB1%'
OR p.conditions LIKE '% DIAB1%';
