-- Seeding using LOAD DATA INFILE
USE globalhealth;

SELECT * FROM globalhealth.healthstatistics LIMIT 10;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

INSERT INTO healthstatistics (
    Country, Year, DiseaseName, DiseaseCategory, PrevalenceRate, IncidenceRate, MortalityRate, AgeGroup, Gender, PopulationAffected, 
    HealthcareAccess, DoctorsPer1000, HospitalBedsPer1000, TreatmentType, AverageTreatmentCost, AvailabilityOfVaccinesTreatment, RecoveryRate, DALYs,
    ImprovementIn5Years, PerCapitaIncome, EducationIndex, UrbanizationRate
) VALUES (
    'Italy', 2013, 'Malaria', 'Respiratory', 0.95, 1.55, 8.42, '0-18', 'Male', 471007, 
    57.74, 3.34, 7.58, 'Medication', 21064, 'No', 91.82, 4493, 2.16, 16886, 0.79, 86.02
);

SELECT * FROM healthstatistics LIMIT 10;

SHOW VARIABLES LIKE 'secure_file_priv';

-- THIS WORKED!!!
-- I put the files in 'C:\\ProgramData\\MySQL\\MySQL Server 9.1\\Uploads' 
-- MySQL is configured to only allow loading files from a specific directory, as defined by 'secure_file_priv'
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.1\\Uploads\\chunks\\chunk_1.csv"
INTO TABLE healthstatistics
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
-- LINES TERMINATED BY '\\r\\n' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(
    Country, Year, DiseaseName, DiseaseCategory, PrevalenceRate, IncidenceRate, MortalityRate, AgeGroup, Gender, PopulationAffected, 
    HealthcareAccess, DoctorsPer1000, HospitalBedsPer1000, TreatmentType, AverageTreatmentCost, AvailabilityOfVaccinesTreatment, RecoveryRate, DALYs,
    ImprovementIn5Years, PerCapitaIncome, EducationIndex, UrbanizationRate
);

SELECT * FROM healthstatistics LIMIT 10;

SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'local_infile';

SELECT COUNT(*) AS total_rows FROM healthstatistics;





