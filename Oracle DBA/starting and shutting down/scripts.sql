--SYS AS SYSDBA 
--CONNECTED TO AN IDLE INSTANCE: DATABASE IS DOWN
STARTUP; --OPEN THE INSTANCE


-- to check the instance
select status 
from v$instance;

--will shutdown the database
shutdown immediate;

-- the instance not amounted
startup nomount;
select status from v$instance;
-- mounted
alter database mount;
select status from v$instance;
--open the database
alter database open;
select status from v$instance;

---SHUTDOWN AND OPEN AGAIN;
STARTUP FORCE;

