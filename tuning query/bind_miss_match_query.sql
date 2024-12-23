--- bind miss match -- lenght

select sql_id,position,max_length,count(1) from V$SQL_BIND_CAPTURE  a where exists (select 1 from V$SQL_BIND_CAPTURE  b  where a.sql_id=sql_id and a.position=position and a.MAX_LENGTH<>MAX_LENGTH)  group by sql_id,position,max_length order by  1,2,4 desc 


--- bind miss match -- type

select sql_id,position,DATATYPE_STRING,count(1) from V$SQL_BIND_CAPTURE  a where exists (select 1 from V$SQL_BIND_CAPTURE  b  where a.sql_id=sql_id and a.position=position and a.DATATYPE_STRING<>DATATYPE_STRING)  group by sql_id,position,DATATYPE_STRING order by  1,2,4 desc 








select * from DBA_SQL_PLAN_BASELINES where last_executed is not null order by last_executed desc


select * from DBA_SQL_PLAN_BASELINES   order by created desc


t_accounttypeitem
select first_load_time,last_load_time,CHILD_NUMBER from v$sql where  sql_id='877rau8j91n79' and CHILD_NUMBER in (917,918) order by first_load_time desc

select * from V$DB_OBJECT_CACHE where name like '%INSERT INTO T_ACCOUNTTYPEITEM (%'
select * from v$sql_shared_cursor where  sql_id='877rau8j91n79'