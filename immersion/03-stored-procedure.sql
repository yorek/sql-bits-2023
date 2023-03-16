create or alter procedure dbo.GetPivotedData
@years as varchar(100),
@projects as nvarchar(1000) 
as

select cast([value] as int) as [year] into #y from string_split(@years, ',');
select trim([value]) as [project] into #p from string_split(@projects, ',');

declare @sanitized_years nvarchar(100) = (select string_agg(cast([year] as nvarchar(4)), ',') from #y)
declare @quoted_years nvarchar(100) = (select string_agg(quotename(cast([year] as nvarchar(4))), ',') from #y)

declare @sql nvarchar(max) = N'
select
    *    
from
    (select project, project_hours_per_year, project_year from dbo.TimesheetAggregatedByProjectYear where project_year in (' + @sanitized_years + ')) as t
pivot
    ( 
        sum(project_hours_per_year) for project_year in (' + @quoted_years + ')
    ) as p
where
    project in (select [project] from #p)
order by
    project';

exec sp_executesql @sql
go

exec dbo.GetPivotedData '2020, 2021', 'Alpha, Charlie, Delta'

-- select * from sys.dm_exec_procedure_stats ps 
-- cross apply sys.dm_exec_query_plan(ps.plan_handle)
-- where database_id = db_id()








