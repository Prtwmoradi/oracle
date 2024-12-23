--add disk
alter diskgroup oradata add 
disk '/dev/oracleasm/disks/SWSTD201OD1' name SWSTD201OD1 
disk '/dev/oracleasm/disks/SWSTD201OD2' name SWSTD201OD2 
disk '/dev/oracleasm/disks/SWSTD201OD3' name SWSTD201OD3 
rebalance power 6;

--drop disk
alter diskgroup oradata drop  
disk ORADATA_0002  disk ORADATA_0000  disk ORADATA_0003  
rebalance power 6;

--add disk with failgroup
alter diskgroup oradata add 
failgroup ORADATA_01 disk '/dev/oracleasm/disks/SWSTD201OD1' name SWSTD201OD1 
failgroup ORADATA_02 disk '/dev/oracleasm/disks/SWSTD201OD2' name SWSTD201OD2 
failgroup ORADATA_03 disk '/dev/oracleasm/disks/SWSTD201OD3' name SWSTD201OD3 
rebalance power 6;
 
--query disks
set pages 1000;
set lines 190;
col failgroup format a20;
col name format a20;
col path format a40;
col state format a10;
col header_status format a20;
select FAILGROUP,name,PATH,state,header_status from v$asm_disk order by 1,2;

--query operations
SELECT OPERATION,STATE,SOFAR,EST_WORK,EST_MINUTES,POWER FROM V$ASM_OPERATION;

--create diskgroup
create diskgroup ORADATA normal redundancy 
failgroup controller206 disk '/dev/oracleasm/disks/SW206OD3' name SW206OD3
;