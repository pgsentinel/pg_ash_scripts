`pg_ash_scripts` – sharing sql scripts to retrieve information from pg_active_session_history
=============================================================

Introduction
------------

This repository contains examples of sql scripts to query the pg_active_session_history view.
PostgreSQL provides recursive query and window functions: let's make use of them to retrieve valuable 
information from the pg_active_session_history view.

In the following outputs AAS stands for Average Active Sessions per second.

Examples
------------
Please don't try to link those examples (as they may have been executed on distinct data sets).

Get the Average number of Active Sessions:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_aas.sql
 AAS
------
 2.93
(1 row)
```

Get the average CPU usage:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_aas_cpu.sql
 AAS  | wait_event_type
------+-----------------
 3.00 | CPU
(1 row)
```

Get the top10 applications:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_top10_application.sql
 %  | AAS  |   application_name
----+------+----------------------
 50 | 1.96 |
 48 | 1.87 | psql
  3 | 0.10 | DBeaver 5.1.0 - Main
(3 rows)
```

Get the top10 client addresses per database:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_top10_datname_client_addr.sql
 %  | AAS  | datname  |   client_addr
----+------+----------+-----------------
 51 | 1.99 | pgio     |
 47 | 1.81 | pgio     | 10.0.3.15/32
  3 | 0.10 | postgres | 172.16.170.1/32
(3 rows)
```

Get the Average number of Active Sessions per database:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_dbname_aas.sql
  %  | AAS  | datname
-----+------+---------
 100 | 2.93 | pgio
(1 row)
```

Get the wait event type repartition per database:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_dbname_wait_event_type.sql
 %  | AAS  | datname | wait_event_type
----+------+---------+-----------------
 85 | 3.68 | pgio    | CPU
 12 | 0.53 | pgio    | IO
  1 | 0.05 | pgio    | LWLock
  1 | 0.05 | pgio    | Lock
(4 rows)
```

Get the wait event repartition per database:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_dbname_wait_event.sql
 %  | AAS  | datname | wait_event_type |    wait_event
----+------+---------+-----------------+-------------------
 86 | 3.67 | pgio    | CPU             | CPU
 10 | 0.42 | pgio    | IO              | DataFileRead
  2 | 0.07 | pgio    | IO              | DataFilePrefetch
  1 | 0.03 | pgio    | LWLock          | buffer_mapping
  1 | 0.02 | pgio    | IO              | DataFileWrite
  1 | 0.05 | pgio    | Lock            | transactionid
  0 | 0.00 | pgio    | LWLock          | WALBufMappingLock
  0 | 0.02 | pgio    | LWLock          | WALWriteLock
(8 rows)
```

Get the top 10 queryid on CPU:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_top10_query_cpu.sql
 %  | AAS  |   backend_type    |  queryid   |                                 query
----+------+-------------------+------------+-----------------------------------------------------------------------
 34 | 0.65 | autovacuum worker |          0 |
 23 | 0.44 | client backend    | 1145165762 | SELECT sum(scratch) FROM pgio3 WHERE mykey BETWEEN $1 AND $2
 21 | 0.40 | client backend    |  973110978 | SELECT sum(scratch) FROM pgio1 WHERE mykey BETWEEN $1 AND $2
 18 | 0.35 | client backend    | 4032430184 | SELECT sum(scratch) FROM pgio2 WHERE mykey BETWEEN $1 AND $2
  2 | 0.03 | client backend    |  210467014 | UPDATE pgio2 SET scratch = scratch + $1 WHERE mykey BETWEEN $2 AND $3
  2 | 0.04 | client backend    | 1736832364 | UPDATE pgio3 SET scratch = scratch + $1 WHERE mykey BETWEEN $2 AND $3
  1 | 0.03 | client backend    | 3870627152 | UPDATE pgio1 SET scratch = scratch + $1 WHERE mykey BETWEEN $2 AND $3
(7 rows)
```

Get the top 10 queryid waiting on IO:
```
postgres@pgu:~/pg_ash_scripts$ psql -f pg_ash_top10_queryid_IO.sql
 %  | AAS  |   backend_type    |  queryid   | wait_event_type
----+------+-------------------+------------+-----------------
 33 | 0.03 | client backend    |  973110978 | IO
 32 | 0.03 | client backend    | 1145165762 | IO
 32 | 0.03 | client backend    | 4032430184 | IO
  1 | 0.00 | autovacuum worker |          0 | IO
  1 | 0.00 | client backend    |  210467014 | IO
  1 | 0.00 | client backend    | 3870627152 | IO
(6 rows)
```

Get the wait chain of blocking session (if any):
```
postgres@pgu:~$ psql -f pg_ash_wait_chain.sql
 % of total wait | seconds |                                  wait_chain
-----------------+---------+------------------------------------------------------------------------------
 57%             |     582 | pid:1890 (Lock : transactionid) ->pid:1888
 40%             |     403 | pid:1913 (Lock : transactionid) ->pid:1890 (Lock : transactionid) ->pid:1888
 3%              |      33 | pid:1913 (Lock : transactionid) ->pid:1890
(3 rows)
```

Short video
-------------
[![Alt text](https://github.com/pgsentinel/pg_ash_scripts/images/video_pg_ash_scripts.PNG)](https://www.youtube.com/watch?v=WVKzKjlK75U)
