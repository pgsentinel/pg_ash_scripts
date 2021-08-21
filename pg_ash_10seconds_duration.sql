-- queries having duration > 10 seconds (with sampling interval 1 second)
select 
	min(ash_time) as query_started,
	max(ash_time) as query_finished,
	query 
from pg_active_session_history 
group by query_start,pid,query
having count(*) > 10;
