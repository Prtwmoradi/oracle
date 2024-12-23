main database 
----------------------
select THREAD#,max(sequence#) from v$archived_log group by THREAD#;



standby database 
----------------------
 select THREAD#,max(sequence#) from v$archived_log where applied in ('YES','IN-MEMORY') group by THREAD#;




logical standby database
----------------------
select thread#, max(sequence#) from dba_logstdby_log where applied='CURRENT' GROUP BY thread# order by thread#;
 