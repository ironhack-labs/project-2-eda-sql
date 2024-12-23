LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Global Health Statistics.csv'
INTO TABLE HealthStatistics
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Country, Year, DiseaseName, DiseaseCategory, PrevalenceRate, IncidenceRate, MortalityRate,
    AgeGroup, Gender, PopulationAffected, HealthcareAccess, DoctorsPer1000, HospitalBedsPer1000,
    TreatmentType, AverageTreatmentCost, AvailabilityOfVaccinesTreatment, RecoveryRate, DALYs,
    ImprovementIn5Years, PerCapitaIncome, EducationIndex, UrbanizationRate
);


