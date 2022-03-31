-- Covidvaccinations Table Creation

CREATE TABLE covidvaccinations(
id INT,
iso_code VARCHAR(30),
continent VARCHAR(30),
location VARCHAR(50),
date DATE,
total_tests INT,
new_tests INT,
total_tests_per_thousand FLOAT,
new_tests_per_thousand FLOAT,
new_tests_smoothed INT,
new_tests_smoothed_per_thousand FLOAT,
positive_rate FLOAT,
tests_per_case FLOAT,
tests_units VARCHAR(30),
total_vaccinations BIGINT,
people_vaccinated BIGINT,
people_fully_vaccinated BIGINT,
total_boosters BIGINT,
new_vaccinations INT,
new_vaccinations_smoothed INT,
total_vaccinations_per_hundred FLOAT,
people_vaccinated_per_hundred FLOAT,
people_fully_vaccinated_per_hundred FLOAT,
total_boosters_per_hundred FLOAT,
new_vaccinations_smoothed_per_million INT,
new_people_vaccinated_smoothed INT,
new_people_vaccinated_smoothed_per_hundred FLOAT,
stringency_index FLOAT,
population_density FLOAT,
median_age FLOAT,
aged_65_older FLOAT,
aged_70_older FLOAT,
gdp_per_capita FLOAT,
extreme_poverty FLOAT,
cardiovasc_death_rate FLOAT,
diabetes_prevalence FLOAT,
female_smokers FLOAT,
male_smokers FLOAT,
handwashing_facilities FLOAT,
hospital_beds_per_thousand FLOAT,
life_expectancy FLOAT,
human_development_index FLOAT,
excess_mortality_cumulative_absolute FLOAT,
excess_mortality_cumulative FLOAT,
excess_mortality FLOAT,
excess_mortality_cumulative_per_million FLOAT);

-- Loading Data From Comma-Delineated File (csv) Into covidvaccinations Table

LOAD DATA
	LOCAL INFILE "C:/Users/Stitcher's_PC/Documents/Code/Projects/SQL/MySQL/CovidVaccinations.csv"
    IGNORE
    INTO TABLE covidvaccinations
    COLUMNS TERMINATED BY ','
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
