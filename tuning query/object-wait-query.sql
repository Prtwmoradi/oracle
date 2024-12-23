-------------- concurrency ----------

 select wait_class,event,-- t2.parameter
 , t3.sql_text, t4.object_name, sum(t1.time_waited) stw
       from DBA_HIST_ACTIVE_SESS_HISTORY      T1
          --  ,v$rowcache           T2
            ,v$sqlarea     T3
            ,dba_objects          T4
       where sample_time between '21-OCT-17 10.50.00.000 AM' and '21-OCT-17 11.00.00.000 AM'
             and wait_class = 'Concurrency'
          --   and event = 'row cache lock'
           --  and parameter ='dc_segments'
           --  and t1.p1 =  t2.cache#
             and t1.sql_id = t3.sql_id (+)
             and T1.current_obj# = T4.object_id (+)
group by wait_class,event,
--t2.parameter
, t3.sql_text, t4.object_name
order by stw desc;




 select wait_class,event, t2.parameter, t3.sql_text, t4.object_name, sum(t1.time_waited) stw
       from DBA_HIST_ACTIVE_SESS_HISTORY      T1
            ,v$rowcache           T2
            ,v$sqlarea     T3
            ,dba_objects          T4
       where sample_time between '21-OCT-17 10.50.00.000 AM' and '21-OCT-17 11.00.00.000 AM'
             and wait_class = 'Concurrency'
             and event = 'row cache lock'
             and parameter ='dc_segments'
             and t1.p1 =  t2.cache#
             and t1.sql_id = t3.sql_id (+)
             and T1.current_obj# = T4.object_id (+)
group by wait_class,event,t2.parameter, t3.sql_text, t4.object_name
order by stw desc;



-------------- top activity ----------

 SELECT F.SQL_ID,F.EVENT,s.sql_text,SUM(F.TIME_WAITED)
    FROM    DBA_HIST_ACTIVE_SESS_HISTORY f
         INNER JOIN
            V$SQLAREA s
         ON s.sql_id = f.sql_id
   WHERE SAMPLE_TIME BETWEEN '12-NOV-17 09.25.00.000 AM' and '12-NOV-17 09.35.00.000 AM'
GROUP BY F.SQL_ID, F.EVENT, s.sql_text
ORDER BY 4  DESC
