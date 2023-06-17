--Lookiing at the Table CovidDeaths$ in PortfolioProject
select * from PortfolioProject.dbo.CovidDeaths$

select continent from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent

--continent
--Africa
--Europe
--Oceania
--North America
--Asia
--South America

select continent,location,date,new_cases,new_deaths from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'



--Group by continent,location,date
--Sum of new_case and sum of new_deaths per location

select continent,location,population,sum(new_cases) as Casesperloc,sum(new_deaths) Deathperloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent,location,population
order by 1,2


--Sum of new_case and sum of new_deaths for Africa

select continent,location,population,sum(new_cases) as Casesperloc,sum(new_deaths) Deathperloc from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
Group by continent,location,population
order by 1,2

--Using CTE
--looking at Africa Covid Cases
with CasesAfrica as 
(
select continent,location,population,sum(new_cases) as Casesperloc,sum(new_deaths) Deathperloc from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
Group by continent,location,population
)

select continent,sum(population) as PopulationAfr,sum(Casesperloc) CovidCasesAfr,sum(Deathperloc) as DeathAfri From CasesAfrica
Group by continent

--Using CTE
--looking at the percentage of the sum(new_deaths) to sum(new_cases) 

with CovidTable as
(
select continent,location,population,sum(new_cases) as SumNewCasesloc,sum(new_deaths) as SumNewDeathloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent,location,population
--order by 1,2
)
select * ,round((SumNewDeathloc/SumNewCasesloc)*100,4) as DeathCaseRatioLoc from CovidTable
order by 1,2


--Looking at the sum of new_cases and the  sum of new deaths as a percentage of the populatiion usin CTE

with CovidTable as
(
select continent,location,population,sum(new_cases) as SumNewCasesloc,sum(new_deaths) SumNewDeathloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent,location,population
--order by 1,2
)
select * ,round((SumNewCasesloc/population)*100,4) CasesperPop,round((SumNewDeathloc/population)*100,4) DeathperPop from CovidTable
order by 1,2


--Drilling Down to a location like Africa


with CovidTable as
(
select continent,location,population,sum(new_cases) as SumNewCasesloc,sum(new_deaths) SumNewDeathloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'and 
continent like '%africa%'
--location like '%nigeria%'
Group by continent,location,population
--order by 1,2
)
select * ,round((SumNewCasesloc/population)*100,4) CasesperPopAfr,round((SumNewDeathloc/population)*100,4) DeathperPopAfr from CovidTable
--order by 1,2

--Drilling Down to a location like Nigeria

with CovidTable as
(
select continent,location,population,sum(new_cases) as SumNewCasesloc,sum(new_deaths) SumNewDeathloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'and 
location like '%nigeria%'
Group by continent,location,population
--order by 1,2
)
select * ,round((SumNewCasesloc/population)*100,4) CasesperPopNig,round((SumNewDeathloc/population)*100,4) DeathperPopNig from CovidTable
--order by 1,2

continent	location	population	SumNewCasesloc	SumNewDeathloc	CasesperPop	DeathperPop
Africa		Nigeria		218541216	266675			3155			0.122		0.0014


--Using Temp Tables
Drop table if exists CovidResult 
create table CovidResult 
(
continent nvarchar(255),
location nvarchar(255),
population numeric,
new_cases numeric,
new_deaths numeric
)
insert into CovidResult 

select continent,location,population,sum(new_cases) as SumNewCasesloc,sum(new_deaths) as SumNewDeathloc from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent,location,population
--order by 1,2

select *,(new_cases/population*100) as CovidInfection ,(new_deaths/population*100) as CovidDeaths from CovidResult
order by 1,2



create view CovidResults as 
select continent from PortfolioProject.dbo.CovidDeaths$
where continent not like '%null%'
Group by continent


--drop view CovidResults
--Analysis Based on world Alone
select * from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location  like '%world%'
--group by location


--Analysis Based on world Alone (Global Figures)
select location,sum(new_cases) as GlobalCases,
sum(new_deaths) as GlobalDeaths
from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location  like '%world%'
group by location

--Analysis Based on Continents Alone
select location from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
and location not like '%European Union%'
group by location

--location
--Europe
--Oceania
--North America
--South America
--Africa
--Asia
--European Union

--Calaculating the Sum of new_cases and the sum of new_deaths grouped by continents

select location ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
and location not like '%European Union%'
group by location
order by 1

--location	SumCasesContinents	SumDeathContinents
--Africa	13085807	258922
--Asia	296997904	1631628
--Europe	249194673	2059668
--European Union	183977047	1230288
--North America	124060644	1602080
--Oceania	14033973	26534
--South America	68541063	1355057

--Creating a view of the Sum of new_cases and the sum of new_deaths grouped by continents

create view SumCasesnDeaths as
select location ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
group by location




--Using CTE to Calaculate the sum(new_cases) divided by sum(new_deaths) in percent grouped by continents

with PerCasesDeath as
(
select location ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
and location not like '%European Union%'
group by location
)
select location, (SumDeathContinents/SumCasesContinents) *100 as DeathCasesRatioCont from PerCasesDeath
order by 1

--location			DeathPerCasesCont
--Africa			1.97864755303208
--Asia				0.549373574030341
--European Union	0.668718201570004
--Europe			0.826529706756613
--Oceania			0.189069766629877
--North America		1.29136843751996
--South America		1.97700026916711

--Creating a view using the result above PerCasesDeath

create view with PerCasesDeath as
(
select location ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
group by location
)
select location, round((SumDeathContinents/SumCasesContinents) *100,4) as DeathPerCasesCont from PerCasesDeath as


--Using CTE to Calaculate the percentage of the popupation infected grouped by continents from 
--the continent with the highest population to the list

with CovidPop as
(
select location,population ,sum(new_cases) as SumCasesContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
and location not like '%European Union%'
group by location,population
)
select location,population, round((SumCasesContinents/population) *100,4) as InfectectedPopCont from CovidPop
order by 3 desc




--creating a view with the result above

create view CovidPop as
with CovidPop as
(
select location,population ,sum(new_cases) as SumCasesContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location  not like '%income%'
and location not like '%world%'
group by location,population
)
select location,population, round((SumCasesContinents/population) *100,4) as InfectectedPop from CovidPop
--order by 3 desc


select  * from PortfolioProject.dbo.CovidDeaths$
where location like '%europe%'
--************************************ check this
--Looking at the icu_patients and  hosp_patients
select continent, location,population ,sum(cast(icu_patients as int)) as SumIcuContinents,sum(cast(hosp_patients as int)) as SumHosContinents from PortfolioProject.dbo.CovidDeaths$
where continent is not null
and location  not like '%income%'
and location not like '%world%'
group by continent, location,population
order by 1

--Using to remove the null values
With IcuHos as
(
select continent, location,population ,sum(cast(icu_patients as int)) as SumIcuLocation,sum(cast(hosp_patients as int)) as SumHosLocation from PortfolioProject.dbo.CovidDeaths$
where continent is not null
and location  not like '%income%'
and location not like '%world%'
group by continent, location,population
)

select * from IcuHos 
where SumIcuLocation is not null or  SumHosLocation is not null
order by 4,5 desc

--Where continent is null
With IcuHos as
(
select continent, location,population ,sum(cast(icu_patients as int)) as SumIcuLocation,sum(cast(hosp_patients as int)) as SumHosLocation from PortfolioProject.dbo.CovidDeaths$
--where continent is null
--and location  not like '%income%'
--and location not like '%world%'
--group by continent, location,population
)

select * from IcuHos 
where SumIcuLocation is not null or  SumHosLocation is not null
order by 4,5 desc


--Looking at the top 10 location with the highest number of icu_patient

With IcuHos as
(
select continent, location,population ,sum(cast(icu_patients as int)) as SumIcuLocation,sum(cast(hosp_patients as int)) as SumHosLocation from PortfolioProject.dbo.CovidDeaths$
where continent is not null
and location  not like '%income%'
and location not like '%world%'
group by continent, location,population
)

select top(10) continent,location,SumIcuLocation from IcuHos 
where SumIcuLocation is not null 
--or  SumHosLocation is not null
order by 3 desc

--continent			location		SumIcuContinents
--North America		United States	10050293
--Europe			France			2269590
--Europe			Germany			2104718
--South America		Argentina		1898676
--Europe			Spain			1102908
--Europe			Italy			1096496
--South America		Chile			991316
--Europe			United Kingdom	703297
--Africa			South Africa	701590
--Europe			England			678773

--Looking at the top 10 location with the highest number of hosp_patients

With IcuHos as
(
select continent, location,population ,sum(cast(icu_patients as int)) as SumIcuContinents,sum(cast(hosp_patients as int)) as SumHosContinents from PortfolioProject.dbo.CovidDeaths$
where continent is not null
and location  not like '%income%'
and location not like '%world%'
group by continent, location,population
)

select top(10) continent,location,SumHosContinents from IcuHos 
where SumIcuContinents is not null 
--or  SumHosContinents is not null
order by 3 desc


--continent			location		SumHosContinents
--North America		United States	45951582
--Europe			France			19367212
--Europe			Italy			12457266
--Europe			United Kingdom	10956515
--Europe			England			9114266
--Europe			Spain			6367167
--Africa			South Africa	5107144
--North America		Canada			3781886
--Europe			Romania			3417258
--Asia				Malaysia		3154229

--Looking at the group more subceptable to Covid Infection and deaths with CTE

select location,population ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location   like '%income%'
and location not like '%world%'
group by location,population

location				population	SumCasesContinents	SumDeathContinents
Upper middle income		2525921300		243722398			2657843
Lower middle income		3432097300		97477876			1342417
Low income				737604900		2299703				47925
High income				1250514600		421208278			2881755


with IncomeCases as
(
select location,population ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location   like '%income%'
and location not like '%world%'
group by location,population
)
select location,population, round((SumCasesContinents/population) *100,4) as InfectectedPop,
round((SumDeathContinents/population) *100,4) as DeathPop from IncomeCases 
order by 3 desc

with IncomeCases as
(
select location,population ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location   like '%income%'
and location not like '%world%'
group by location,population
)
select location,population, round((SumCasesContinents/population) *100,4) as InfectectedPop
 from IncomeCases 
order by 3 desc

--Infection rate highest in the income
--location				population	InfectectedPop
--High income			1250514600	33.6828
--Upper middle income	2525921300	9.6489
--Lower middle income	3432097300	2.8402
--Low income			737604900	0.3118


with IncomeCases as
(
select location,population ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent is null
and location   like '%income%'
and location not like '%world%'
group by location,population
)
select location,population, round((SumDeathContinents/population) *100,4) as DeathPop from IncomeCases 
order by 3 desc

--Death rate highest in the income
--location				population	DeathPop
--High income			1250514600	0.2304
--Upper middle income	2525921300	0.1052
--Lower middle income	3432097300	0.0391
--Low income			737604900	0.0065


--Looking in the continent of Africa

select location,population ,sum(new_cases) as SumCasesContinents,sum(new_deaths) as SumDeathContinents from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
--and location   like '%Africa%'
--and location not like '%world%'
group by location,population


--10 Top African Countries with the highest number of infected people

select top(10) location,population ,sum(new_cases) as SumCasesContinents
from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
--and location   like '%Africa%'
--and location not like '%world%'
group by location,population
order by 3 desc


location		population	SumCasesContinents
South Africa	59893884	4072533
Morocco			37457976	1273832
Tunisia			12356116	1152877
Egypt			110990096	516023
Libya			6812344	507252
Ethiopia		123379928	500853
Reunion			974062	494595
Zambia			20017670	343911
Kenya			54027484	343073
Botswana		2630300	329856

--10 Bottom African Countries with the highest number of infected people

select top(10) location,population ,sum(new_cases) as SumCasesContinents
from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
--and location   like '%Africa%'
--and location not like '%world%'
group by location,population
order by 3 

--location			population	SumCasesContinents
--Western Sahara		576005		NULL
--Saint Helena			5401		2166
--Sao Tome and Principe	227393		6562
--Chad					17723312	7698
--Sierra Leone			8605723		7762
--Liberia				5302690		8091
--Comoros				836783		9109
--Niger					26207982	9513
--Guinea-Bissau			2105580		9614
--Eritrea				3684041		10189


--African Countries with the highest percentage of infected people
with HighInfected as
(
select  location,population ,sum(new_cases) as SumCasesContinents
from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
group by location,population
)
Select top(10) location,population,round((SumCasesContinents/population)*100 ,3) as InfectedPopu From HighInfected
order by 3 desc

--location			population	InfectedPopu
--Reunion			974062	50.777
--Seychelles		107135	47.545
--Saint Helena		5401	40.104
--Mauritius			1299478	23.294
--Mayotte			326113	13.156
--Botswana			2630300	12.541
--Cape Verde		593162	10.724
--Tunisia			12356116	9.33
--Libya				6812344	7.446
--South Africa		59893884	6.8


--Looking at data from Nigeria where I am from

select location,population ,
sum(new_cases) as SumCasesContinents,
sum(new_deaths) as SumDeathContinents 
from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
and location   like '%Nigeria%'
--and location not like '%world%'
group by location,population

location	population	SumCasesContinents	SumDeathContinents
Nigeria		218541216		266675				3155

--Percent of Nigeria popolation that got infected using CTE


With NigeriaInfected as
(
select location,population ,
sum(new_cases) as SumCasesContinents,
sum(new_deaths) as SumDeathContinents 
from PortfolioProject.dbo.CovidDeaths$
where continent like '%Africa%'
and location   like '%Nigeria%'
--and location not like '%world%'
group by location,population
)
select location,round((SumCasesContinents/population)*100,4) as NigInfecPer From NigeriaInfected

location	NigInfecPer
Nigeria		0.122



--Joining 2 Tables Together

select * from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 


select Cod.continent,Cod.location,Cod.date,Cod.population,Cov.new_tests,Cov.new_vaccinations from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 
where Cod.continent is not null
order by 1

--Determine the number of the highest vacinnated population
with VacPopu as
(
select Cod.continent,Cod.location,Cod.population,sum(cast(Cov.new_vaccinations as bigint)) as TVac
from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 
where Cod.continent is not null
Group by Cod.continent,Cod.location,Cod.population
----order by 1,2
)
select max(TVac) as HighestPopVac  from VacPopu

--HighestPopVac
--3407595000


--Calculate the percentage of the population vaccinated

with VacRatio as
(
select Cod.continent,Cod.location,Cod.population,sum(cast(Cov.new_vaccinations as bigint)) as TVac
from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 
where Cod.continent is not null
Group by Cod.continent,Cod.location,Cod.population
--order by 1,2
)
select continent,location,population,TVac,(TVac/population)*100 as VacinPop from VacRatio
--where location like '%state%'
order by 5 desc

--Locations where there are no vaccination

with VacRatio as
(
select Cod.continent,Cod.location,Cod.population,sum(cast(Cov.new_vaccinations as bigint)) as TVac
from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 
where Cod.continent is not null
Group by Cod.continent,Cod.location,Cod.population
--order by 1,2
)
select continent,location,population,TVac,(TVac/population)*100 as VacinPop from VacRatio
where TVac is null
order by 1,2

--continent	location	population	TVac	VacinPop
--Africa	Angola	35588996	NULL	NULL
--Africa	Benin	13352864	NULL	NULL
--Africa	Burkina Faso	22673764	NULL	NULL
--Africa	Chad	17723312	NULL	NULL
--Africa	Comoros	836783	NULL	NULL
--Africa	Eritrea	3684041	NULL	NULL
--Africa	Lesotho	2305826	NULL	NULL
--Africa	Mali	22593598	NULL	NULL
--Africa	Mayotte	326113	NULL	NULL
--Africa	Niger	26207982	NULL	NULL
--Africa	Reunion	974062	NULL	NULL
--Africa	Saint Helena	5401	NULL	NULL
--Africa	Sao Tome and Principe	227393	NULL	NULL
--Africa	Tanzania	65497752	NULL	NULL
--Africa	Togo	8848700	NULL	NULL
--Africa	Western Sahara	576005	NULL	NULL
--Asia	Armenia	2780472	NULL	NULL
--Asia	North Korea	26069416	NULL	NULL
--Asia	Turkmenistan	6430777	NULL	NULL
--Asia	Yemen	33696612	NULL	NULL
--Europe	Austria	8939617	NULL	NULL
--Europe	Belarus	9534956	NULL	NULL
--Europe	Denmark	5882259	NULL	NULL
--Europe	Jersey	110796	NULL	NULL
--Europe	Monaco	36491	NULL	NULL
--Europe	Netherlands	17564020	NULL	NULL
--Europe	Portugal	10270857	NULL	NULL
--Europe	Slovakia	5643455	NULL	NULL
--Europe	Sweden	10549349	NULL	NULL
--Europe	Vatican	808	NULL	NULL
--North America	Bermuda	64207	NULL	NULL
--North America	Bonaire Sint Eustatius and Saba	27052	NULL	NULL
--North America	British Virgin Islands	31332	NULL	NULL
--North America	Costa Rica	5180836	NULL	NULL
--North America	Guadeloupe	395762	NULL	NULL
--North America	Martinique	367512	NULL	NULL
--North America	Montserrat	4413	NULL	NULL
--North America	Puerto Rico	3252412	NULL	NULL
--North America	Saint Barthelemy	10994	NULL	NULL
--North America	Saint Martin (French part)	31816	NULL	NULL
--North America	Saint Pierre and Miquelon	5885	NULL	NULL
--North America	Sint Maarten (Dutch part)	44192	NULL	NULL
--North America	Turks and Caicos Islands	45726	NULL	NULL
--North America	United States Virgin Islands	99479	NULL	NULL
--Oceania	American Samoa	44295	NULL	NULL
--Oceania	Cook Islands	17032	NULL	NULL
--Oceania	Guam	171783	NULL	NULL
--Oceania	Kiribati	131237	NULL	NULL
--Oceania	Marshall Islands	41593	NULL	NULL
--Oceania	Micronesia (country)	114178	NULL	NULL
--Oceania	New Caledonia	289959	NULL	NULL
--Oceania	Niue	1952	NULL	NULL
--Oceania	Northern Mariana Islands	49574	NULL	NULL
--Oceania	Palau	18084	NULL	NULL
--Oceania	Papua New Guinea	10142625	NULL	NULL
--Oceania	Pitcairn	47	NULL	NULL
--Oceania	Samoa	222390	NULL	NULL
--Oceania	Solomon Islands	724272	NULL	NULL
--Oceania	Tokelau	1893	NULL	NULL
--Oceania	Tonga	106867	NULL	NULL
--Oceania	Tuvalu	11335	NULL	NULL
--Oceania	Vanuatu	326744	NULL	NULL
--Oceania	Wallis and Futuna	11596	NULL	NULL
--South America	Falkland Islands	3801	NULL	NULL
--South America	French Guiana	304568	NULL	NULL
--South America	Venezuela	28301700	NULL	NULL

--sum the new_test and new_vaccination over partition


select Cod.continent,Cod.location,Cod.date,Cod.population,Cov.new_tests,
sum(cast(Cov.new_tests as int)) over (partition by Cod.location order by Cod.location,Cod.date) as RolloverNewTests,
Cov.new_vaccinations,
sum(cast(Cov.new_vaccinations as int)) over (partition by Cod.location order by Cod.location,Cod.date) as RolloverNewVacination
from PortfolioProject.dbo.CovidDeaths$ CoD
inner join 
PortfolioProject.dbo.CovidVaccinations$ CoV
on
CoD.location = CoV.location 
and
CoD.date = CoV.date 
where Cod.continent is not null
and CoD.location  like '%Nigeria%'
order by 1,2,3

