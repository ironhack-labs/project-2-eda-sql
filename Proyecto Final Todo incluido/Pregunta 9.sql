SELECT ci.name AS circuit_name, AVG(re.laps) AS avg_laps
FROM results re
JOIN races r ON re.raceId = r.raceId
JOIN circuits ci ON r.circuitId = ci.circuitId
GROUP BY ci.circuitId, ci.name
ORDER BY avg_laps DESC;
