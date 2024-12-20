SELECT c.name AS constructor_name, COUNT(*) AS total_championships
FROM constructor_standings cs
JOIN constructors c ON cs.constructorId = c.constructorId
WHERE cs.position = 1
GROUP BY cs.constructorId, c.name
ORDER BY total_championships DESC
LIMIT 10;
