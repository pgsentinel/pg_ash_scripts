with ash as (
	 select *,datid dbid, ceil(extract(epoch from max(ash_time)over()-min(ash_time)over()))::numeric samples
	 from pg_active_session_history where ash_time>=current_timestamp - interval '10 minutes'
) select  round(100 * count(*)/sum(count(*)) over(),0) as "%", round(count(*)/samples,2) as "AAS",
   dbid,queryid,pg_stat_statements.query,wait_event_type 
 from ash left outer join pg_stat_statements using(dbid,queryid)
 group by samples,
  dbid,queryid,pg_stat_statements.query,wait_event_type
 order by 1 desc fetch first 10 rows only
;
