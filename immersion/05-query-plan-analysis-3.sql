insert into dbo.timesheet_test 
    (first_name, last_name, birthday, project, reported_on, hours_worked)
values
    ('John', 'Doe', '2000-10-23', 'SQL Bits', '2023-03-13', 8)
go

exec sp_helpindex 'dbo.timesheet_test'
go

create nonclustered index ix__reported_on on dbo.timesheet_test(reported_on)
go

set statistics io on
set statistics time on
go

select * from dbo.timesheet_test where convert(char(10), reported_on, 103) = '13/03/2023'
go

select * from dbo.timesheet_test where reported_on = '2023-03-13'
go


create nonclustered index ix__first_name on dbo.timesheet_test(first_name)
go

select * from dbo.timesheet_test where first_name = 'John'
go

declare @first_name as nvarchar(100) = 'John'
select * from dbo.timesheet_test where first_name = @first_name;
go
