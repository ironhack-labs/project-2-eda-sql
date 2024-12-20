SELECT c.name AS constructor_name, COUNT(*) AS total_wins
FROM results r
JOIN constructors c ON r.constructorId = c.constructorId
WHERE r.position = 1
GROUP BY r.constructorId, c.name
ORDER BY total_wins DESC
LIMIT 10;
