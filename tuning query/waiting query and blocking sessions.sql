====================================For which SQL currently is waiting on:

SELECT sid, sql_text
  FROM v$session s, v$sql q
 WHERE sid IN
             (SELECT sid
                FROM v$session
               WHERE     state IN ('WAITING')
                     AND wait_class != 'Idle'
                     AND event = 'enq: TX - row lock contention'
                     AND (q.sql_id = s.sql_id OR q.sql_id = s.prev_sql_id));



=====================================The blocking session is:

  SELECT inst_id,blocking_session,
         sid,
         serial#,
         wait_class,
         seconds_in_wait,
		 username,
		 client_info
    FROM gv$session
   WHERE blocking_session IS NOT NULL
ORDER BY blocking_session;