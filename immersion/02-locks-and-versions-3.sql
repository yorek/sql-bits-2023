select wait_type, blocking_session_id from sys.dm_os_waiting_tasks where session_id = 68

select * from sys.dm_tran_locks where request_session_id = 68 

select * from sys.dm_tran_locks where request_session_id = 53
and resource_description = '1:416:0'

