SELECT d.forename, d.surname, c.name AS constructor_name, sr.fastestLapTime
FROM sprint_results sr
JOIN drivers d ON sr.driverId = d.driverId
JOIN constructors c ON sr.constructorId = c.constructorId
WHERE sr.fastestLapTime IS NOT NULL
ORDER BY sr.fastestLapTime ASC
LIMIT 10;
