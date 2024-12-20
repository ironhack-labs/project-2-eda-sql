SELECT d.forename, d.surname, COUNT(*) AS pole_positions
FROM qualifying q
JOIN drivers d ON q.driverId = d.driverId
WHERE q.position = 1
GROUP BY q.driverId, d.forename, d.surname
ORDER BY pole_positions DESC
LIMIT 10;
