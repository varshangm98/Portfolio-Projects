
Select *
from PortfolioProject..['COVID DEATHS']
Where Continent is not null
order by 3,4;


--Select *
--from PortfolioProject..['COVID VACCINATIONS']
--order by 3,4
----Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..['COVID DEATHS'] order by 1,2;

----Looking at total cases vs total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage 
from PortfolioProject..['COVID DEATHS']  order by 1,2;

----Looking at total cases vs Population

Select location, date, total_cases, population, (total_cases/population)*100 as deathpercentage 
from PortfolioProject..['COVID DEATHS']  order by 1,2;

----Looking at countries with hightestinfectionrate compared to population

Select Location, Population, Max(total_cases) as HightestInfectionCount, Max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..['COVID DEATHS'] Group by Location,Population 
order by PercentagePopulationInfected desc;

--Showing Countries with Highest Death Count per Population

--Let's Break things down by continent

Select Location, Max(Total_deaths) as TotalDeathCount
from PortfolioProject..['COVID DEATHS'] 
Where Continent is not null
Group by Location
order by TotalDeathCount desc;


--Showing Contintents with Highest Death Count per Population


Select continent, Max(Total_deaths) as TotalDeathCount
from PortfolioProject..['COVID DEATHS'] 
Where Continent is not null
Group by continent
order by TotalDeathCount desc;



----GLOBAL NUMBERS

Select date, Sum(new_cases) as total_cases,Sum(cast(new_deaths as int)) as total_deaths,
Sum(cast(new_deaths as int))/ Sum(new_cases)*100 as deathpercentage
from PortfolioProject..['COVID DEATHS'] 
Where Continent is not null
Group by date
order by 1,2 



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..['COVID DEATHS'] 
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--Looking at totalPopulation vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..['COVID DEATHS'] dea
Join PortfolioProject..['COVID VACCINATIONS'] vac
On dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE

with PopvsVac(Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as(Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..['COVID DEATHS'] dea
Join PortfolioProject..['COVID VACCINATIONS'] vac
On dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100 from PopvsVac


--USE TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location  NVARCHAR(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..['COVID DEATHS'] dea
Join PortfolioProject..['COVID VACCINATIONS'] vac
On dea.location = vac.location 
and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *,(RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated

--Creating view to store data for later visualizations


Create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations))OVER(Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..['COVID DEATHS'] dea
Join PortfolioProject..['COVID VACCINATIONS'] vac
On dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * from PercentPopulationVaccinated










