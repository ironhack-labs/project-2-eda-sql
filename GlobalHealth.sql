CREATE DATABASE GlobalHealth;

USE GlobalHealth;

CREATE TABLE HealthStatistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Country VARCHAR(255),
    Year INT,
    DiseaseName VARCHAR(255),
    DiseaseCategory VARCHAR(255),
    PrevalenceRate DECIMAL(5,2),
    IncidenceRate DECIMAL(5,2),
    MortalityRate DECIMAL(5,2),
    AgeGroup VARCHAR(50),
    Gender VARCHAR(50),
    PopulationAffected BIGINT,
    HealthcareAccess DECIMAL(5,2),
    DoctorsPer1000 DECIMAL(5,2),
    HospitalBedsPer1000 DECIMAL(5,2),
    TreatmentType VARCHAR(255),
    AverageTreatmentCost DECIMAL(10,2),
    AvailabilityOfVaccinesTreatment VARCHAR(50),
    RecoveryRate DECIMAL(5,2),
    DALYs DECIMAL(10,2),
    ImprovementIn5Years DECIMAL(5,2),
    PerCapitaIncome DECIMAL(10,2),
    EducationIndex DECIMAL(5,2),
    UrbanizationRate DECIMAL(5,2)
);
