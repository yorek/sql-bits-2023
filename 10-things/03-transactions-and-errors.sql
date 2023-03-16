-- Errors in ad-hoc queries / scripts

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

select * from dbo.timesheet_test where id = 6

-- excute this script all together
declare @n int = 0;
begin tran

	delete from dbo.timesheet_test where id = 6

	select 1 / @n; -- Generate an error

commit tran

select @@trancount
select * from dbo.timesheet_test where id = 6
go

-- Test now the same script using a Stored Procedure

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin
	declare @n int = 0;
	begin tran

		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

	commit tran
end
go

select * from dbo.timesheet_test where id = 6
go

exec dbo.stp_test_error
go

select @@trancount
go

select * from dbo.timesheet_test where id = 6
go

-- Update the stored procedure

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin
	set xact_abort on; -- automatically rollback and terminate
	declare @n int = 0;
	begin tran

		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

	commit tran
end
go

exec dbo.stp_test_error
go

select @@trancount
go

select * from dbo.timesheet_test where id = 6
go


-- Manual error management

drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

create or alter procedure dbo.stp_test_error
as
begin
	-- This is a *variable* and therefore does not take part in a trasaction
	declare @log table (id int not null identity primary key, [message] nvarchar(1000));

	declare @n int = 0;
	begin try
		begin tran
		delete from dbo.timesheet_test where id = 6;

		select 1 / @n;

		commit tran
	end try
	begin catch
		insert into @log ([message]) values ('Error found, rolling back.');
	
		rollback
	end catch
	select * from @log
end
go

exec dbo.stp_test_error
go

select @@trancount
select * from dbo.timesheet_test where id = 6
go

