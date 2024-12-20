SELECT year, COUNT(*) AS total_races
FROM races
GROUP BY year
ORDER BY year ASC;
