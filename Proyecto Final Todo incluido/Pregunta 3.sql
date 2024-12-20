SELECT ci.name AS circuit_name, COUNT(*) AS race_count
FROM races r
JOIN circuits ci ON r.circuitId = ci.circuitId
GROUP BY r.circuitId, ci.name
ORDER BY race_count DESC
LIMIT 5;
