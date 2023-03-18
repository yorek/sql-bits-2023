
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
    request_status = 'WAIT'
go

exec sp_whoisactive

