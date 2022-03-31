-- Coviddeaths Table Creation

CREATE TABLE coviddeaths(
id INT,
iso_code VARCHAR(30),
continent VARCHAR(30),
location VARCHAR(50),
date DATE,
population BIGINT,
total_cases INT,
new_cases INT,
new_cases_smoothed FLOAT,
total_deaths INT,
new_deaths INT,
new_deaths_smoothed FLOAT,
total_cases_per_million FLOAT,
new_cases_per_million FLOAT,
new_cases_smoothed_per_million FLOAT,
total_deaths_per_million FLOAT,
new_deaths_per_million FLOAT,
new_deaths_smoothed_per_million FLOAT,
reproduction_rate FLOAT,
icu_patients INT,
icu_patients_per_million FLOAT,
hosp_patients INT,
hosp_patients_per_million FLOAT,
weekly_icu_admissions INT,
weekly_icu_admissions_per_million FLOAT,
weekly_hosp_admissions INT,
weekly_hosp_admissions_per_million FLOAT);

-- Loading Data From Comma-Delineated File (csv) Into covviddeaths Table

LOAD DATA
	LOCAL INFILE "C:/Users/Stitcher's_PC/Documents/Code/Projects/SQL/CovidDeaths.csv"
    IGNORE
    INTO TABLE coviddeaths
    COLUMNS TERMINATED BY ','
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
