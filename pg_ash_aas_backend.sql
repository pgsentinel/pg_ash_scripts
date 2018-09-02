with ash as (
	 select *,ceil(extract(epoch from max(ash_time)over()-min(ash_time)over()))::numeric samples
	 from pg_active_session_history where ash_time>=current_timestamp - interval '30 minutes'
) select  round(100 * count(*)/sum(count(*)) over(),0) as "%", round(count(*)/samples,2) as "AAS",
   backend_type 
 from ash
 group by samples,
   backend_type
 order by 1 desc 
;
