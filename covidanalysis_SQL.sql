select * from CovidVaccination$ ;

select * from CovidDeaths$ ;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in our country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like 'India'
and continent is not null 
order by DeathPercentage DESC


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
--Where location like 'India'
where 
continent is not null 
order by DeathPercentage DESC

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths$

Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

select location,max(total_deaths)  as TotalDeathCount
from CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From CovidDeaths$
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Maximum positive rate in which country ? 
Select location, max(positive_rate) AS POSRATE,max(human_development_index) as HDI
from covidvaccination$
group by location
order by POSRATE


 -- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3