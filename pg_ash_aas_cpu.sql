with ash as (
	 select *,ceil(extract(epoch from max(ash_time)over()-min(ash_time)over()))::numeric samples
	 from pg_active_session_history where ash_time>=current_timestamp - interval '10 minutes'
) select round(count(*)/samples,2) as "AAS",wait_event_type
 from ash
 where wait_event_type='CPU'
 group by samples,
   wait_event_type
 order by 1 desc
;
