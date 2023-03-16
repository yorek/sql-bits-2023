create or alter view dbo.TimesheetAggregatedByProjectYear
as
select
    project,
    year(reported_on) as project_year,
    sum(hours_worked) as project_hours_per_year,    
    avg(hours_worked) as project_avg_hours_per_year    
from
    dbo.timesheet
group by
    project, year(reported_on)
go

-- Check execution plan
select * from dbo.TimesheetAggregatedByProjectYear
where project = 'Bravo' 

-- Check execution plan
select * from dbo.TimesheetAggregatedByProjectYear
where project_year = 2021 


