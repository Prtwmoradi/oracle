select max(sequence#) from dba_logstdby_log where applied='CURRENT' GROUP BY thread# order by thread#;
select * from v$logstdby_state;
select * from v$logstdby_process;
select * from v$logstdby_progress;