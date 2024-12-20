SELECT d.forename, d.surname, r.year, (YEAR(r.date) - YEAR(d.dob)) AS age_at_win
FROM results re
JOIN drivers d ON re.driverId = d.driverId
JOIN races r ON re.raceId = r.raceId
WHERE re.position = 1
ORDER BY age_at_win ASC
LIMIT 5;
