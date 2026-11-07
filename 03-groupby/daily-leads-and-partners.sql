-- Daily Leads and Partners
-- https://leetcode.com/problems/daily-leads-and-partners/
-- Dialect: mysql | Solved: 2026-11-07

# Write your MySQL query statement below
SELECT date_id, make_name, COUNT(DISTINCT lead_id) AS unique_leads, COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY date_id, make_name;
