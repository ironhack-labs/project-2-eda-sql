SELECT d.forename, d.surname, COUNT(*) AS total_wins
FROM results r
JOIN drivers d ON r.driverId = d.driverId
WHERE r.position = 1
GROUP BY d.driverId, d.forename, d.surname
ORDER BY total_wins DESC
LIMIT 10;
