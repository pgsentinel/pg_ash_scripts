with ash as (
	 select *,ceil(extract(epoch from max(ash_time)over()-min(ash_time)over()))::numeric samples
	 from pg_active_session_history where ash_time>=current_timestamp - interval '60 minutes'
) select  round(100 * count(*)/sum(count(*)) over(),0) as "%", round(count(*)/samples,2) as "AAS",
   backend_type,wait_event_type 
 from ash
 group by samples,
   backend_type,wait_event_type
 order by 1 desc fetch first 10 rows only
;
