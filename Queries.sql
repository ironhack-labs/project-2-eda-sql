/* Query 1.	What is the average employee satisfaction score (0-5) by department? */
SELECT Department, AVG(Employee_Satisfaction_Score)
FROM satisfaction
INNER JOIN employee
ON satisfaction.Employee_ID = employee.Employee_ID
GROUP BY Department;


/* Query 2.	Which departments have the highest number of employee resignations? */
SELECT Department, Resigned, COUNT(Resigned)
FROM employee
INNER JOIN satisfaction
ON employee.Employee_Id = satisfaction.Employee_Id
GROUP BY Department, Resigned
HAVING Resigned = "True"
ORDER BY COUNT(Resigned) DESC;


/* Query 3.	What is the average number of projects handled by employees in each department? */
SELECT Department, AVG(Projects_Handled)
FROM seniority
INNER JOIN employee
ON seniority.Employee_Id = employee.Employee_Id
GROUP BY Department
ORDER BY AVG(Projects_Handled) DESC;


/* Query 4.	How does remote work frequency affect employee performance scores (1-5)? */
SELECT Remote_Work_Frequency, AVG(Performance_Score)
FROM satisfaction
INNER JOIN seniority
ON satisfaction.Employee_Id = seniority.Employee_Id
GROUP BY Remote_Work_Frequency
ORDER BY Remote_Work_Frequency DESC;


/* Query 5.	How do training hours impact employee satisfaction and performance? */
SELECT Training_Hours, AVG(Employee_Satisfaction_Score), AVG(Performance_Score)
FROM satisfaction
INNER JOIN seniority
ON satisfaction.Employee_Id = seniority.Employee_ID
GROUP BY Training_Hours
ORDER BY AVG(Performance_Score) DESC;


/* Query 6. Does working a lot of overtime (>5 hours) make it more likely that an employee will get a promotion? */
SELECT 
    COUNT(Employee_ID) AS Employees_With_Significant_Overtime,
    SUM(Promotions) AS Promotions_For_Significant_Overtime,
    (SUM(Promotions) / COUNT(Employee_Id)) * 100 AS Promotion_Rate
FROM 
    seniority
WHERE 
    Overtime_Hours > 5;
    

/* Query 7. What is the age distribution of employees across different job titles? */
SELECT COUNT(Employee_Id), Job_Title, AVG(Age), MAX(Age) AS "Oldest Employee", MIN(Age) AS "Youngest Employee"
FROM employee
GROUP BY Job_Title
ORDER BY AVG(Age) DESC;


/* Query 8. Which job titles have the highest salaries and number of promotions */
SELECT Job_Title, AVG(Monthly_Salary), SUM(Promotions)
FROM employee
INNER JOIN seniority
ON employee.Employee_Id = seniority.Employee_Id
GROUP BY Job_Title
ORDER BY AVG(Monthly_Salary) DESC;

