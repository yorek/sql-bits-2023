-- Sessions
select * from sys.dm_exec_sessions where is_user_process = 1
and program_name = 'Demo'
go

-- Requests
select 
    r.* 
from 
    sys.dm_exec_sessions s 
inner join 
    sys.dm_exec_requests r on s.session_id = r.session_id 
where 
    s.is_user_process = 1
and 
    program_name = 'Demo'
go

-- Wait Stats
select 
    w.* 
from 
    sys.dm_exec_sessions s 
inner join 
    sys.dm_exec_session_wait_stats w on s.session_id = w.session_id 
where 
    s.is_user_process = 1
and 
    program_name = 'Demo'
order by
    wait_time_ms desc
go

-- Locks
select 
    t.request_session_id,
    t.resource_type,
    t.resource_subtype,
    t.resource_database_id,
    t.resource_description,
    t.resource_associated_entity_id,
    t.request_mode,
    t.request_status
from 
    sys.dm_exec_sessions s 
inner join 
    sys.dm_tran_locks t on s.session_id = t.request_session_id 
where 
    s.is_user_process = 1
and 
    program_name = 'Demo'
go

-- Pages
select * from sys.dm_db_partition_stats where object_id = object_id('dbo.timesheet_big')