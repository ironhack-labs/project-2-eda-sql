CREATE DATABASE who_health_data;
USE who_health_data;

CREATE TABLE Indicators (
    indicator_id VARCHAR(50) PRIMARY KEY,
    indicator_name TEXT NOT NULL,
    description TEXT,
    source TEXT
);

CREATE TABLE Data (
    data_id SERIAL PRIMARY KEY,
    indicator_id VARCHAR(50),
    year INT,
    value FLOAT,
    dimension_code VARCHAR(50),
    FOREIGN KEY (indicator_id) REFERENCES Indicators(indicator_id)
);

CREATE TABLE Dimensions (
    dimension_code VARCHAR(50) PRIMARY KEY,
    dimension_name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE Metadata (
    meta_id SERIAL PRIMARY KEY,
    indicator_id VARCHAR(50),
    metadata_key TEXT,
    metadata_value TEXT,
    FOREIGN KEY (indicator_id) REFERENCES Indicators(indicator_id)
);
