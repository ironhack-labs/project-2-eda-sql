/*1. Average age of fatalities*/
SELECT AVG(age)
FROM fatalities;

/*2 Average age by citizenship*/
SELECT citizenship, AVG(age) AS average_age
FROM fatalities
GROUP BY citizenship;

/*3 Count of those under 18 by citizenship*/
SELECT citizenship, COUNT(*) AS under_18
FROM fatalities
WHERE age < 18
GROUP BY citizenship;

/*4 Sum of fatalities by citizenship*/
SELECT citizenship, COUNT(*) AS count
FROM fatalities
GROUP BY citizenship;

/*5 Sum of fatalities by citizenship and role in conflict (those listed as simply Israeli are civilians)*/
SELECT citizenship, 
       SUM(CASE WHEN took_part_in_the_hostilities = 'Yes' THEN 1 ELSE 0 END) AS combatants,
       SUM(CASE WHEN took_part_in_the_hostilities = 'No' THEN 1 ELSE 0 END) AS non_combatants,
       SUM(CASE WHEN took_part_in_the_hostilities IS NULL OR took_part_in_the_hostilities = 'Unknown' OR took_part_in_the_hostilities = 'unassigned' THEN 1 ELSE 0 END) AS unknown,
       SUM(CASE WHEN took_part_in_the_hostilities = 'Israelis' THEN 1 ELSE 0 END) AS Israelis,
       SUM(CASE WHEN took_part_in_the_hostilities = 'Object of targeted killing' THEN 1 ELSE 0 END) AS targeted_killing
FROM fatalities
GROUP BY citizenship;

/*6 Missiles launched each year*/
SELECT YEAR(date_of_event) AS year, SUM(CASE WHEN ammunition = 'missile' THEN 1 ELSE 0 END) AS missile_count
FROM fatalities
GROUP BY YEAR(date_of_event);

/*Demolitions and Fatalities each year*/
SELECT
    year,
    SUM(total_fatalities) AS total_fatalities,
    SUM(total_demolitions) AS total_demolitions
FROM (
    SELECT
        YEAR(f.date_of_event) AS year,
        COUNT(*) AS total_fatalities,
        0 AS total_demolitions
    FROM
        fatalities f
    GROUP BY YEAR(f.date_of_event)
    
    UNION ALL
    
    SELECT
        YEAR(d.date_of_demolition) AS year,
        0 AS total_fatalities,
        COUNT(*) AS total_demolitions
    FROM
        demolitions d
    GROUP BY YEAR(d.date_of_demolition)
) combined
GROUP BY year
ORDER BY year;

/*demolition by area per year*/
SELECT
    YEAR(date_of_demolition) AS year,
    area,
    COUNT(*) AS total_demolitions
FROM
    demolitions
GROUP BY
    YEAR(date_of_demolition), area;

/*Fatalities and Demolitions per year in both the Gaza Strip and the West Bank*/	
SELECT
    YEAR(f.date_of_event) AS year,
    f.event_location_region AS region,
    COUNT(DISTINCT f.index) AS total_fatalities,
    COUNT(DISTINCT d.index) AS total_demolitions
FROM
    fatalities_join f
LEFT JOIN demolitions_join d ON 
        YEAR(f.date_of_event) = YEAR(d.date_of_demolition)
        AND f.event_location_region = d.area
GROUP BY
    YEAR(f.date_of_event), f.event_location_region;