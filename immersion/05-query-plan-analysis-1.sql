drop table if exists dbo.timesheet_test
select 
    [id] = identity(int,1,1),
    cast([first_name] as varchar(100)) as [first_name],
    cast([last_name] as varchar(100)) as [last_name],
    [birthday],[project],[reported_on],[reported_year],[hours_worked]
into 
    dbo.timesheet_test from dbo.timesheet
go

insert into dbo.timesheet_test
    ([first_name],[last_name],[birthday],[project],[reported_on],[reported_year],[hours_worked])
select 
    [first_name],[last_name],[birthday],[project],[reported_on],[reported_year],[hours_worked]
from 
    dbo.timesheet_test
go 10

alter table dbo.timesheet_test
add constraint pk primary key (id)
go
