SELECT d.forename, d.surname, COUNT(DISTINCT r.raceId) AS total_races
FROM results r
JOIN drivers d ON r.driverId = d.driverId
GROUP BY r.driverId, d.forename, d.surname
ORDER BY total_races DESC
LIMIT 1;
