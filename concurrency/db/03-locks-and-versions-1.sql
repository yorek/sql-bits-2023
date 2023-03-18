drop table if exists dbo.timesheet_test
select * into dbo.timesheet_test from dbo.timesheet
go

begin tran
    select @@trancount

    -- Make some changes
    insert into dbo.timesheet_test
        (id, first_name, last_name, birthday, project, reported_on, hours_worked)
    values 
        (99999, 'John', 'Doe', '1989-04-19', 'Secret!', cast(sysdatetime() as date), 8)

    delete from dbo.timesheet_test  
    where project = 'Alpha'

    update dbo.timesheet_test  
    set hours_worked = hours_worked + hours_worked * 0.30
    where project = 'Bravo' 

    -- This connection can see all the changes done to the data by itself
    select * from dbo.timesheet_test  
    where project IN ('Alpha', 'Bravo', 'Secret!')
    order by project, id

    select project, count(*) from dbo.timesheet_test  
    where project IN ('Alpha', 'Bravo', 'Secret!')
    group by project
    
	select @@trancount

    /* STOP HERE AND EXECUTE IN ANOTHER SESSION THE "...-2.sql" SCRIPT BEFORE PROCEEDING! */

commit tran
--or rollback tran

