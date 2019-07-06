select ash_time,queryid,delta_rows/seconds "rows_per_seconds",delta_calls/seconds "calls_per_second",delta_rows/delta_calls "rows_per_calls"
from(
SELECT ash_time,queryid,
EXTRACT(EPOCH FROM ash_time::timestamp) - lag (EXTRACT(EPOCH FROM ash_time::timestamp))
OVER (
        PARTITION BY pgssh.queryid
        ORDER BY ash_time
        ASC) as "seconds",
rows-lag(rows)
        OVER (
        PARTITION BY pgssh.queryid
        ORDER BY ash_time
        ASC) as "delta_rows",
calls-lag(calls)
        OVER (
        PARTITION BY pgssh.queryid
        ORDER BY ash_time
        ASC) as "delta_calls"
    FROM pg_stat_statements_history pgssh) as delta
where delta_calls > 0 and seconds > 0
order by ash_time desc;
