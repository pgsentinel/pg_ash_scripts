WITH RECURSIVE search_wait_chain(ash_time,pid, blockerpid, wait_event_type,wait_event,level, path)
AS (
	  SELECT ash_time,pid, blockerpid, wait_event_type,wait_event, 1 AS level, 
	  'pid:'||pid||' ('||wait_event_type||' : '||wait_event||') ->'||'pid:'||blockerpid AS path
	  from pg_active_session_history WHERE blockers > 0 
	union ALL
	  SELECT p.ash_time,p.pid, p.blockerpid, p.wait_event_type,p.wait_event, swc.level + 1 AS level,
	  'pid:'||p.pid||' ('||p.wait_event_type||' : '||p.wait_event||') ->'||swc.path AS path 
	  FROM pg_active_session_history p, search_wait_chain swc 
	  WHERE p.blockerpid = swc.pid and p.ash_time = swc.ash_time and p.blockers > 0
)
select round(100 * count(*) / cnt)||'%' as "% of total wait",count(*) as seconds,path as wait_chain  from (
	SELECT  pid,wait_event,path,sum(count) over() as cnt from (
		select ash_time,level,pid,wait_event,path,count(*) as count, max(level) over(partition by ash_time,pid) as max_level
		FROM search_wait_chain where level > 0 group by ash_time,level,pid,wait_event,path
	) as all_wait_chain
	where level=max_level
) as wait_chain
group by path,cnt
order by count(*) desc;
