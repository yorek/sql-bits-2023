create or alter function dbo.GetRunningTotal(@project as nvarchar(50), @date as date)
returns int
as
begin
    declare @result int;
    select @result = sum(hours_worked) from dbo.timesheet where project = @project and reported_on <= @date
    return @result
end
go

select * from dbo.timesheet_test where project = 'Alpha' order by reported_on
go

select dbo.GetRunningTotal('Alpha', '2019-09-30')
go


alter database current set compatibility_level = 140 with rollback immediate

select compatibility_level from sys.databases where database_id = db_id()

set statistics time on

select 
    *,
    running_total =  dbo.GetRunningTotal(project, reported_on)
from 
    dbo.timesheet t
order by
    project, reported_on
go

alter database current set compatibility_level = 160 with rollback immediate

select compatibility_level from sys.databases where database_id = db_id()

set statistics time on

select 
    *,
    running_total =  dbo.GetRunningTotal(project, reported_on)
from 
    dbo.timesheet t
order by
    project, reported_on
go

-- Set based is better :)

select
    *,
    running_total = sum(hours_worked) over (partition by project order by reported_on)
from
    dbo.timesheet
order by
    project, reported_on
go