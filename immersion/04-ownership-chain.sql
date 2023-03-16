create user DeployUser without login;
create user AppUser without login;
go

select * from sys.database_principals
go

alter role db_owner add member DeployUser
go

execute as user = 'DeployUser'
go

create schema web;
go

create procedure web.GetTimesheet
as
select top (10) * from dbo.timesheet order by reported_on desc
go

exec web.GetTimesheet
go

grant execute on schema::web to AppUser
go

revert;
go

execute as user = 'AppUser'
go

select * from dbo.timesheet
go

exec web.GetTimesheet
go

revert;
go

select s.name as schema_name, p.name as owner_name from sys.schemas s 
inner join sys.database_principals p on s.principal_id = p.principal_id
where s.[name] in ('dbo', 'web')
go

drop procedure web.GetTimesheet;
drop schema web;
drop user DeployUser;
drop user AppUser;

/*
correct the script by replacing

create schema web authorization dbo;

with 

authorization dbo;

and re-execute
*/