-- Actors and Directors Who Cooperated At Least Three Times
-- https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/
-- Dialect: mysql | Solved: 2026-08-13

# Write your MySQL query statement below
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;
