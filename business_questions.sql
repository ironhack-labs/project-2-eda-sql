SELECT * FROM top_languages_db.top_languages_db;

USE top_languages_db;

SHOW tables;

SHOW COLUMNS FROM top_languages_db;

DESCRIBE top_languages_db;
 
 -- 1. What are the top 5 most spoken languages in the world by total speakers? 
SELECT Language, "Total Speakers"
FROM top_languages_db
ORDER BY "Total Speakers" DESC
LIMIT 5;

-- 2. What are the top 5 languages with the highest number of native speakers?
SELECT Language, "Native Speakers"
FROM top_languages_db
ORDER BY "Native Speakers" DESC
LIMIT 5;

-- 3. Which languages have the largest difference between native speakers and total speakers?
SELECT Language, ("Total Speakers" -  "Native Speakers") AS Difference
FROM top_languages_db
ORDER BY Difference DESC
LIMIT 5;

-- 4. What is the proportion of native speakers compared to total speakers for each language?
SELECT Language, ("Native Speakers" / "Total Speakers") * 100 AS Native_To_Total_Ratio
FROM top_languages_db
ORDER BY Native_To_Total_Ratio DESC;

-- 5. Which language origins (language families) have the highest total number of speakers?
SELECT Origin, SUM("Total Speakers") AS "Total Speakers"
FROM top_languages_db
GROUP BY Origin
ORDER BY "Total Speakers" DESC;

-- 6. How has the number of native and total speakers for the main languages evolved over time?
SELECT Language, Year, "Total Speakers", "Native Speakers"
FROM language_speakers_history
WHERE Language IN ('English', 'Mandarin Chinese', 'Hindi', 'Spanish', 'French')
ORDER BY Year ASC;

-- 7. Which languages are the most spoken in specific continents (e.g., Europe)?
SELECT Language, Continent, "Total Speakers"
FROM top_languages_db
WHERE Continent = 'Europe'
ORDER BY "Total Speakers" DESC;

-- 8. Which language has seen the greatest growth in total speakers in recent decades?
SELECT Language, (MAX("Total Speakers") - MIN("Total Speakers")) AS Growth
FROM language_speakers_history
GROUP BY Language
ORDER BY Growth DESC
LIMIT 5;

-- 9. Which languages have more speakers outside their country of origin?
SELECT Language, ("Total Speakers" - "Native Speakers") AS Foreign_Speakers
FROM top_languages_db
WHERE Foreign_Speakers > "Native Speakers"
ORDER BY Foreign_Speakers DESC;

-- 10. Which countries contribute the most to the total number of speakers of a specific language? 
SELECT Country, Language, SUM("Total Speakers") AS "Total Speakers"
FROM language_by_country
WHERE Language = 'English' -- Substitua pela língua desejada
GROUP BY Country
ORDER BY "Total Speakers" DESC;