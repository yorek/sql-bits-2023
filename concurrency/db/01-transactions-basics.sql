/*
    No rows with id >= 10000
*/
select * from dbo.timesheet where id >= 10000
go

/*
    Autocommit transaction for single statements
    Note: id is the primary key
*/
insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10001, N'Davide', N'Mauri', N'2023-03-12', N'Bits', N'2023-03-12', 8),
    (10002, N'Davide', N'Mauri', N'2023-03-13', N'Bits', N'2023-03-14', 8),
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 8),
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 42)
go

select * from dbo.timesheet where id >= 10000
go

/*
    What happens with multiple statements?
*/
insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10001, N'Davide', N'Mauri', N'2023-03-12', N'Bits', N'2023-03-12', 8);
  
insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10002, N'Davide', N'Mauri', N'2023-03-13', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 42);
go

select * from dbo.timesheet where id >= 10000
go

delete from dbo.timesheet where id >= 10000
go

/*
    Using explicit transactions
*/
begin tran

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10001, N'Davide', N'Mauri', N'2023-03-12', N'Bits', N'2023-03-12', 8);
  
insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10002, N'Davide', N'Mauri', N'2023-03-13', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 42);
go

select @@trancount
go

select * from dbo.timesheet where id >= 10000
go

commit -- rollback
go

select * from dbo.timesheet where id >= 10000
go

delete from dbo.timesheet where id >= 10000
go

/*
    Using explicit transactions, with auto-rollback
*/
set xact_abort on;
begin tran

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10001, N'Davide', N'Mauri', N'2023-03-12', N'Bits', N'2023-03-12', 8);
  
insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10002, N'Davide', N'Mauri', N'2023-03-13', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 8);

insert into dbo.timesheet
	([id], [first_name], [last_name], [birthday], [project], [reported_on], [hours_worked])
values
    (10003, N'Davide', N'Mauri', N'2023-03-14', N'Bits', N'2023-03-14', 42);
go

select @@trancount
go

select * from dbo.timesheet where id >= 10000
go