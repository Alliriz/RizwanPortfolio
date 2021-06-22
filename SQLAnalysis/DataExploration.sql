-- Loading the data
Select 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
From
	Project..Deaths
Order By
	1,2;



-- Total Cases vs Total Deaths
-- Investigate the Likelihood of death if affected by Covid by country
Select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS Percentage_of_Deaths
From
	Project..Deaths
Where
	location = 'Canada'
Order By
	1,2;


-- Total Population vs Total Cases
-- Investigate the percent of population that has covid by country
Select 
	location, 
	date, 
	population,
	total_cases, 
	(total_cases/population)*100 AS Percentage_of_Population
From
	Project..Deaths
Where
	location = 'Canada'
Order By
	1,2;


-- Find which country has the highest infection rate compared to its population
Select 
	location,
	population,
	MAX(total_cases) AS Highest_Infected,
	MAX((total_cases/population))*100 AS Percentage_Population_Infected
From
	Project..Deaths
Group By
	location, population
Order By
	Percentage_Population_Infected DESC


-- Countries with highest death count per population
Select 
	location,
	population,
	MAX(cast(total_deaths as int)) AS TotalDeaths
From
	Project..Deaths
Where
	continent IS NOT NULL
Group By
	location, population
Order By
	TotalDeaths DESC


-- Continents with highest death counts
Select 
	continent,
	MAX(cast(total_deaths as int)) AS TotalDeaths
From
	Project..Deaths
Where
	continent IS NOT NULL
Group By
	continent
Order By
	TotalDeaths DESC


-- Global counts and rates
Select  
	date, 
	SUM(total_cases) AS total_cases,
	SUM(cast(total_deaths as int)) AS total_deaths,
	(SUM(cast(total_deaths as int))/SUM(total_cases))*100 AS Death_Percentage
	--total_deaths, 
	--(total_deaths/total_cases)*100 AS Percentage_of_Deaths
From
	Project..Deaths
Where
	continent IS NOT NULL
Group By
	date
Order By
	1,2;



-- Total Population vs Vaccinations
Select
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_Rolling_Vaccinations
From
	project..Deaths dea
Join 
	project..Vaccinations vac
	ON
		dea.location = vac.location
		and dea.date = vac.date
Where
	dea.continent IS NOT NULL
Order By
	2,3;

-- Using CTE
With deavsVac (continent, location, date, population, New_Vaccinations, Total_Rolling_Vaccinations)
AS
(
Select
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_Rolling_Vaccinations
From
	project..Deaths dea
Join 
	project..Vaccinations vac
	ON
		dea.location = vac.location
		and dea.date = vac.date
Where
	dea.continent IS NOT NULL
)
Select
	*,
	(Total_Rolling_Vaccinations/population) * 100 AS Percent_Population_Vaccinated
From deavsVac


-- Another way of doing this is creating a temp table
DROP TABLE IF EXISTS #PercentVaccinated
Create Table #PercentVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_Vaccinations numeric,
Total_Rolling_Vaccinations numeric
)
INSERT INTO #PercentVaccinated
Select
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_Rolling_Vaccinations
From
	project..Deaths dea
Join 
	project..Vaccinations vac
	ON
		dea.location = vac.location
		and dea.date = vac.date
Where
	dea.continent IS NOT NULL

Select
	*,
	(Total_Rolling_Vaccinations/population) * 100 AS Percent_Population_Vaccinated
From #PercentVaccinated



-- Storing data via create view

CREATE VIEW PercentPopVacc as
Select
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_Rolling_Vaccinations
From
	project..Deaths dea
Join 
	project..Vaccinations vac
	ON
		dea.location = vac.location
		and dea.date = vac.date
Where
	dea.continent IS NOT NULL
