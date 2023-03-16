/* SQL SERVER */

select * from dbo.timesheet_test
where project IN ('Alpha', 'Bravo', 'Secret!')


/* AZURE SQL
-- Uncomment the following lines to force Azure SQL to use locks to preserve consistency and isolate transactions. 
select * from dbo.timesheet_test with (readcommittedlock)
where project IN ('Alpha', 'Bravo', 'Secret!')
*/

-- Default in Azure
-- alter database <db_name> set read_committed_snapshot on

-- SQL Server
alter database current set read_committed_snapshot on with rollback immediate
-- Re-execute the session in the "-2" file.

-- Not blocked
select * from dbo.timesheet_test 
where project IN ('Alpha', 'Bravo', 'Secret!')

select project, count(*) from dbo.timesheet_test  
where project IN ('Alpha', 'Bravo', 'Secret!')
group by project




