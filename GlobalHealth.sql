CREATE DATABASE GlobalHealth;

USE GlobalHealth;

CREATE TABLE HealthStatistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Country VARCHAR(100), 
    Year SMALLINT, 
    DiseaseName VARCHAR(100),
    DiseaseCategory VARCHAR(50), 
    PrevalenceRate DECIMAL(5,2), -- Assuming values are in percentages
    IncidenceRate DECIMAL(5,2),
    MortalityRate DECIMAL(5,2),
    AgeGroup ENUM('0-18', '19-35', '36-60', '61+'), -- Predefined age groups
    Gender ENUM('Male', 'Female', 'Both'), -- Use ENUM for predefined values
    PopulationAffected BIGINT,
    HealthcareAccess DECIMAL(5,2),
    DoctorsPer1000 DECIMAL(5,2),
    HospitalBedsPer1000 DECIMAL(5,2),
    TreatmentType VARCHAR(100), 
    AverageTreatmentCost DECIMAL(10,2),
    AvailabilityOfVaccinesTreatment ENUM('Yes', 'No'), -- Use ENUM for Yes/No
    RecoveryRate DECIMAL(5,2),
    DALYs DECIMAL(10,2),
    ImprovementIn5Years DECIMAL(5,2),
    PerCapitaIncome DECIMAL(10,2),
    EducationIndex DECIMAL(5,2),
    UrbanizationRate DECIMAL(5,2),
    INDEX idx_country (Country),
    INDEX idx_year (Year),
    INDEX idx_diseasename (DiseaseName)
);
