Use coronavirus;

SELECT *
FROM coronavirus.coviddeaths
ORDER BY 4,5;

/*SELECT * 
FROM coronavirus.covidvaccines
ORDER BY 4,5*/

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coronavirus.coviddeaths
ORDER BY 1,2;

/*Here's a variable that can be changed to the name of any country to find the death_rate orderd by date
Make sure to include the variable in the query execution*/

SET @Country = 'United States';

-- Let's look at Total Deaths vs Total Cases

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 AS death_rate
FROM coronavirus.coviddeaths
WHERE location = @Country
ORDER BY 1,2;

-- Total Cases vs Population

SELECT location, date, total_cases, population,
(total_cases/population)*100 AS infection_rate
FROM coronavirus.coviddeaths
WHERE location = @Country
ORDER BY 1,2;

-- Countries with Highest Infection Rate

SELECT location, population, MAX(total_cases) AS highest_infected_count,
MAX((total_cases/population))*100 AS infection_rate
FROM coronavirus.coviddeaths
WHERE continent IS NOT NULL
AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY 4 DESC;

-- Countries with Highest Death Count per Population

SELECT location, population, MAX(total_deaths) AS highest_death_count,
MAX((total_deaths/population))*100 AS death_rate
FROM coronavirus.coviddeaths
WHERE continent IS NOT NULL
AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY 4 DESC;

-- Above Query changed to be based on Continent

SELECT location, population, MAX(total_deaths) AS highest_death_count,
MAX((total_deaths/population))*100 AS death_rate
FROM coronavirus.coviddeaths
WHERE continent IS NULL
AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY 4 DESC;

-- Global Death Statistics

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_rate
FROM coronavirus.coviddeaths
WHERE continent IS NOT NULL;

-- Combining Death and Vaccination Statistics

SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_vaccination_count
/* (rolling_vaccination_count/population)*100 
In order to perform this action, I'll create a CTE below this query*/
FROM coronavirus.coviddeaths death
JOIN coronavirus.covidvaccinations vaccin
	ON death.location = vaccin.location
    AND death.date = vaccin.date
WHERE death.continent IS NOT NULL
ORDER BY 2,3;

-- CTE Creation To Find Rolling_Vaccination_Count Per Population

With Population_Vs_Vaccination (continent, location, date, population, new_vaccinations, rolling_vaccination_count)
AS
(
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_vaccination_count
-- (rolling_vaccination_count/population)*100
FROM coronavirus.coviddeaths death
JOIN coronavirus.covidvaccinations vaccin
	ON death.location = vaccin.location
    AND death.date = vaccin.date
WHERE death.continent IS NOT NULL
-- ORDER BY 2,3;
)

SELECT *, (rolling_vaccination_count/population)*100 AS vaccination_percentage
FROM Population_Vs_Vaccination;

-- Doing The Same Query Utilizing a Temp Table

CREATE TEMPORARY TABLE PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_vaccination_count
-- (rolling_vaccination_count/population)*100
FROM coronavirus.coviddeaths death
JOIN coronavirus.covidvaccinations vaccin
	ON death.location = vaccin.location
    AND death.date = vaccin.date
WHERE death.continent IS NOT NULL
-- ORDER BY 2,3
;

SELECT *, (rolling_vaccination_count/population)*100 AS vaccination_percentage
FROM PercentPopulationVaccinated;

-- Creating A View To Store This Data

CREATE VIEW PercentPopulationVaccinated AS
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
SUM(vaccin.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_vaccination_count
-- (rolling_vaccination_count/population)*100
FROM coronavirus.coviddeaths death
JOIN coronavirus.covidvaccinations vaccin
	ON death.location = vaccin.location
    AND death.date = vaccin.date
WHERE death.continent IS NOT NULL
-- ORDER BY 2,3
;