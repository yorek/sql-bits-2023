set statistics io on
set statistics time on
go

with cte as
(
	select
		project,
		year(reported_on) as project_year,        
		sum(hours_worked) as project_hours_per_year    
	from
		dbo.timesheet_test
    where
        reported_on between '2021-01-01' and '2021-12-31'
	group by
		project, year(reported_on)
)
select
    *,
    lag(project_hours_per_year) over (partition by project order by project_year) as project_prev_year
from
    cte
where
    project = 'Alpha'
go

exec sp_helpindex 'dbo.timesheet_test'
go

alter table dbo.timesheet_test drop constraint pk;
alter table dbo.timesheet_test add constraint pk primary key nonclustered(id);
create clustered index ixc on dbo.timesheet_test(project, reported_on);
go

with cte as
(
	select
		project,
		year(reported_on) as project_year,        
		sum(hours_worked) as project_hours_per_year    
	from
		dbo.timesheet_test
    where
        reported_on between '2021-01-01' and '2021-12-31'
	group by
		project, year(reported_on)
)
select
    *,
    lag(project_hours_per_year) over (partition by project order by project_year) as project_prev_year
from
    cte
where
    project = 'Alpha'
go


