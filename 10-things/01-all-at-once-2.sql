-- The starting dataset
/*
create table [dbo].[timesheet]
(
	[id] [int] not null,
	[first_name] [nvarchar](50) not null,
	[last_name] [nvarchar](50) not null,
	[birthday] [date] not null,
	[project] [nvarchar](50) not null,
	[reported_on] [date] not null,
	[reported_year]  as (datepart(year,[reported_on])) persisted,
	[hours_worked] [int] not null,
	constraint [pk__timesheet] primary key nonclustered 
	(
		[id] asc
	)
)
go
*/
select * from dbo.timesheet
go

-- A complex query with aggregations, subquery and windowing functions
with cte as
(
	select
		project,
		year(reported_on) as project_year,
		sum(hours_worked) as project_hours_per_year    
	from
		dbo.timesheet
	where
		reported_year = 2021
	group by
		project, year(reported_on)
)
select
    *,
    lag(project_hours_per_year) over (partition by project order by project_year) as project_prev_year
from
    cte
where	
    project = 'Bravo' 
go

select count(*) from dbo.timesheet where reported_year = 2021
select count(*) from dbo.timesheet where reported_year = 2021 and project = 'Bravo'


-- Should you *always* use a CTE/Subquery/View?
-- Keep in mind that
-- 1) data distribution may be really skewed
-- 2) query optimizer works with statistics, which have inherent errors 
--    that accumulate if there are many CTEs
-- try using a temp table (materializing the intermediate result) 
-- to check if it give better performances
-- For a detailed explanation, read this: https://devblogs.microsoft.com/azure-sql/ctes-views-or-temp-tables/