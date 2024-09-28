-- HEART ATTACK PREDICTION RISK --
-- Choose database --
USE heart_data;

-- check that there are no duplicated patients
SELECT 
	COUNT(DISTINCT patient_demographics.Patient_ID) AS 'Unique Patients', 
	COUNT(patient_demographics.Patient_ID) AS 'Total Patients'
FROM patient_demographics;

-- Question 1: --
/* Does age really matter? Compare the risk for suffering a heart attack is affect by age?
What is the age group with the highest risk?*/
SELECT
	Age_Group, AVG(Heart_Attack_Risk)*100 AS 'Risk(%)'
    FROM patient_demographics
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Age_Group
ORDER BY Age_Group asc;

-- What is the age group with the highest risk?*/
SELECT
	Age_Group, AVG(Heart_Attack_Risk)*100 AS 'Risk(%)'
    FROM patient_demographics
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Age_Group
ORDER BY AVG(Heart_Attack_Risk) desc
limit 1;

-- Question 2: 
/* How does gender affect heart attack risk? */
SELECT
	Sex, AVG(Heart_Attack_Risk)*100 AS 'Risk(%)'
    FROM patient_demographics
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Sex
ORDER BY AVG(Heart_Attack_Risk) desc; 

-- Question 3: 
/* What role does lifestyle (e.g., smoking, physical activity) play in heart attack risk?*/

SELECT 
	Age_Group,
    Diet, AVG(Smoking), AVG(Alcohol_Consumption),
    AVG(Heart_Attack_Risk)*100 AS Risk
	FROM patient_demographics
INNER JOIN life_style
ON patient_demographics.Patient_ID = life_style.Patient_ID
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
Group BY Age_Group, Diet
ORDER BY Age_Group, AVG(Heart_Attack_Risk) desc;

-- Question 4: 
/*How do different medical conditions affect the risk of having 
a heart attack for the different Age groups?*/
SELECT
	Age_Group,
    AVG(Cholesterol),
    AVG(Heart_Rate),
    AVG(Systolic),
    AVG(Diastolic),
    AVG(Diabetes),
    AVG(Family_History),
    AVG(Obesity),
    AVG(Previous_Heart_Problems),
    AVG(Medication_Use),
    AVG(BMI),
    AVG(Triglycerides),
    AVG(Heart_Attack_Risk)*100 AS Risk
	FROM patient_demographics
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Age_Group
ORDER BY Risk desc;

-- Question 5: 
/*What is the geographic distribution of heart attack risk?*/
SELECT
	Country,
    Continent,
    Hemisphere,
    AVG(Heart_Attack_Risk)*100 AS Risk
FROM patient_demographics
INNER JOIN medical_history
ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Country, Continent, Hemisphere
ORDER BY Risk desc;

# Question 6: 
/*How does sleep patterns affect the risks of heart attack?*/
SELECT 
	Sleep_Hours_Per_Day AS 'Hours of sleep',
    AVG(Heart_Attack_Risk)*100 AS Risk
FROM life_style
INNER JOIN medical_history
ON life_style.Patient_ID = medical_history.Patient_ID
GROUP BY Sleep_Hours_Per_Day
ORDER by risk asc;

# Question 7: 
/* How does high stress levels increase the risk of heart attack?*/

SELECT
	Stress_Level as 'Stress Level' , AVG(Heart_Attack_Risk)*100 AS Risk
FROM life_style
INNER JOIN medical_history
ON life_style.Patient_ID = medical_history.Patient_ID
GROUP BY Stress_Level
ORDER BY Risk desc;

-- Question 8: 
/*How does lifestyle (e.g., diet, exercise, smoking, alcohol consumption) affect heart attack risk 
when controlled for medical history*/

SELECT
	Age_Group,
    AVG(Smoking),
    AVG(Alcohol_Consumption),
    AVG(Exercise_Hours_Per_Week),
    AVG(Diet),
    AVG(Stress_Level),
    AVG(Sedentary_Hours_Per_Day),
    AVG(Physical_Activity_Days_Per_Week),
    AVG(Sleep_Hours_Per_Day),
    AVG(Heart_Attack_Risk) *100 AS Risk
FROM life_style
INNER JOIN (
-- Subquery to find the patients with healthy medical history
	SELECT
		medical_history.Patient_ID
		FROM medical_history
	INNER JOIN patient_demographics
	ON medical_history.Patient_ID = patient_demographics.Patient_ID
	WHERE Cholesterol < 200 AND
			Systolic < 140 AND
            Diastolic < 100 AND
			Diabetes = 0 AND
			Family_History = 0 AND
			Obesity = 0 AND
			Previous_Heart_Problems = 0 AND
			Medication_Use = 0 AND
			BMI < 30 AND
			Triglycerides < 200
	GROUP BY medical_history.Patient_ID) AS healthy_medical
ON life_style.Patient_ID = healthy_medical.Patient_ID
INNER JOIN (
SELECT
	medical_history.Patient_ID,
	Heart_Attack_Risk
    FROM medical_history) AS Risk
ON life_style.Patient_ID = Risk.Patient_ID
INNER JOIN patient_demographics
ON life_style.Patient_ID = patient_demographics.Patient_ID
GROUP BY Age_Group, life_style.Patient_ID
ORDER BY Risk desc;

-- # Question 9: 
/*How does the socioeconomic status of a patient affect the risks of suffering a heart attack?*/

SELECT 
	Age_Group, AVG(Income) AS Income, AVG(Heart_Attack_Risk)*100 AS Risk
    FROM patient_demographics 
    INNER JOIN medical_history
    ON patient_demographics.Patient_ID = medical_history.Patient_ID
GROUP BY Age_Group
ORDER BY Risk desc;

-- Question 10: 
/*How do combinations of medical history factors (e.g., hypertension, diabetes, cholesterol levels) interact with 
healthy lifestyle choices to influence heart attack risk across different demographic segments?*/

SELECT
	Age_Group, 
    AVG(Cholesterol), 
    AVG(Diabetes), 
	AVG(Family_History), 
    AVG(Obesity), 
    AVG(Previous_Heart_Problems), 
    AVG(BMI), 
    AVG(Triglycerides), 
    AVG(Heart_Attack_Risk) *100 AS Risk
FROM medical_history
INNER JOIN (
-- Subquery to find the patients with healthy lifestyle choices
	SELECT
		life_style.Patient_ID,
        Age_Group
		FROM life_style
	INNER JOIN patient_demographics
	ON life_style.Patient_ID = patient_demographics.Patient_ID
	WHERE Smoking = 0 AND
			Alcohol_Consumption = 0 AND
			Exercise_Hours_Per_Week > 0 AND
			Diet = 'Healthy' AND
			Sedentary_Hours_Per_Day < 1 AND
            Physical_Activity_Days_Per_Week > 0 AND
			Sleep_Hours_Per_Day > 6 
	GROUP BY life_style.Patient_ID) AS healthy_life
ON medical_history.Patient_ID = healthy_life.Patient_ID
GROUP BY Age_Group
ORDER BY Risk desc;