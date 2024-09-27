-- 1. Which sectors had the highest number of job postings on monthly average?

SELECT display_name, AVG(indeed_job_postings_index) AS avg_job_postings
FROM job_postings_by_sector_de_aggregated
GROUP BY display_name
ORDER BY avg_job_postings DESC
LIMIT 5;


-- 2. How has the job market evolved month-by-month in each sector?

SELECT DATE_FORMAT(date, '%Y-%m') AS month, display_name, SUM(indeed_job_postings_index) AS total_postings
FROM job_postings_by_sector_de_aggregated
GROUP BY month, display_name
ORDER BY month ASC;

-- 3. Which sector showed the most growth in job postings over time?
WITH monthly_changes AS (
    SELECT display_name, 
           date, 
           indeed_job_postings_index,
           LAG(indeed_job_postings_index) OVER (PARTITION BY display_name ORDER BY date) AS previous_month
    FROM job_postings_by_sector_de_aggregated
),
sector_growth AS (
    SELECT display_name, 
           AVG((indeed_job_postings_index - previous_month) / previous_month * 100) AS avg_monthly_growth
    FROM monthly_changes
    WHERE previous_month IS NOT NULL
    GROUP BY display_name
)
SELECT display_name, avg_monthly_growth
FROM sector_growth
ORDER BY avg_monthly_growth DESC
LIMIT 5;

-- 4. What is the distribution of job postings across different sectors?

SELECT display_name, SUM(indeed_job_postings_index) AS total_postings
FROM job_postings_by_sector_de_aggregated
GROUP BY display_name
ORDER BY total_postings DESC;


-- 5. How does the job posting index vary for different sectors?

SELECT display_name, MIN(indeed_job_postings_index) AS min_posting_index,
       MAX(indeed_job_postings_index) AS max_posting_index,
       AVG(indeed_job_postings_index) AS avg_posting_index
FROM job_postings_by_sector_de_aggregated
GROUP BY display_name;

-- 6. What are the top sectors that contributed to the highest job posting index in 2024? 

SELECT display_name, SUM(indeed_job_postings_index) AS total_postings
FROM job_postings_by_sector_de_aggregated
WHERE YEAR(date) = 2024
GROUP BY display_name
ORDER BY total_postings DESC
LIMIT 5;


-- 7. How do job postings vary between the first and second half of 2023 for different sectors?

SELECT display_name,
       SUM(CASE WHEN MONTH(date) BETWEEN 1 AND 6 THEN indeed_job_postings_index ELSE 0 END) AS first_half_2023,
       SUM(CASE WHEN MONTH(date) BETWEEN 7 AND 12 THEN indeed_job_postings_index ELSE 0 END) AS second_half_2023
FROM job_postings_by_sector_de_aggregated
WHERE YEAR(date) = 2023
GROUP BY display_name;

-- 8. Which sector showed the highest job posting index during the pandemic months (March 2020 - December 2020)? / this not right
SELECT date, display_name, SUM(indeed_job_postings_index) AS total_postings
FROM job_postings_by_sector_de_aggregated
WHERE date BETWEEN '2020-03-01' AND '2020-12-31'
GROUP BY date, display_name
ORDER BY total_postings DESC;


-- 9. Are there any seasonal trends in job postings for certain sectors (i.e., some months having more job postings than others)?
SELECT display_name, MONTH(date) AS month, AVG(indeed_job_postings_index) AS avg_postings
FROM job_postings_by_sector_de_aggregated
GROUP BY display_name, month
ORDER BY avg_postings DESC;

-- 10. What is the correlation between the sector and the job postings index?

SELECT display_name, indeed_job_postings_index
FROM job_postings_by_sector_de_aggregated
ORDER BY indeed_job_postings_index DESC;
  

