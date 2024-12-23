--126
select max(sequence#) from V$ARCHIVED_LOG

select thread#,max(sequence#) from  V$ARCHIVED_LOG where applied='YES'
group by  thread#


select thread#,max(sequence#) from  V$ARCHIVED_LOG 
group by  thread#


--127

select max(sequence#) from V$ARCHIVED_LOG where applied='YES' 

select SEQUENCE#,PROCESS,status from V$MANAGED_STANDBY where  sequence#<>0 and status not in ('CLOSING','IDLE')

alter database recover managed standby database using current logfile disconnect;
