--Check Active Sessions

SELECT sid, serial#, username, status, osuser, machine, program
FROM v$session
WHERE username IS NOT NULL;

--Check Current Running SQL Queries

SELECT s.sid, s.serial#, s.username, q.sql_text
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.username IS NOT NULL;

--Database Size

SELECT SUM(bytes)/1024/1024 AS size_in_mb
FROM dba_data_files;

--Tablespace Utilization

SELECT tablespace_name,
       ROUND((used_space*100)/total_space, 2) AS used_percent,
       ROUND(total_space, 2) AS total_space_mb,
       ROUND(used_space, 2) AS used_space_mb,
       ROUND(total_space - used_space, 2) AS free_space_mb
FROM (
  SELECT tablespace_name,
         SUM(bytes)/1024/1024 AS total_space,
         SUM(DECODE(maxbytes, 0, bytes, maxbytes))/1024/1024 AS max_space,
         SUM(bytes - NVL(free.bytes, 0))/1024/1024 AS used_space
  FROM dba_data_files df
       LEFT JOIN (
         SELECT file_id, SUM(bytes) AS bytes
         FROM dba_free_space
         GROUP BY file_id
       ) free ON df.file_id = free.file_id
  GROUP BY tablespace_name
);

--Check Database Parameters

SELECT name, value
FROM v$parameter
WHERE isdefault = 'FALSE';

--Check Datafiles

SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb, autoextensible
FROM dba_data_files;

--Find Blocking Sessions

SELECT blocking_session,
       sid,
       serial#,
       wait_class,
       seconds_in_wait
FROM v$session
WHERE blocking_session IS NOT NULL;

--Monitor Undo Tablespace Usage

SELECT tablespace_name, file_name, bytes/1024/1024 AS size_mb
FROM dba_data_files
WHERE tablespace_name = 'UNDOTBS1';

--Check Instance Status

SELECT instance_name, status, version, startup_time
FROM v$instance;

--Check System Performance (Top Wait Events)

SELECT event, total_waits, time_waited
FROM v$system_event
ORDER BY time_waited DESC;

--Check Invalid Objects

SELECT owner, object_type, object_name, status
FROM dba_objects
WHERE status = 'INVALID';

--Query Scheduled Jobs

SELECT job_name, job_action, state, last_start_date, next_run_date
FROM dba_scheduler_jobs;

-- Session Resource Usage

SELECT sid, username, machine, cpu_time, block_gets, consistent_gets
FROM v$sess_io
JOIN v$session USING (sid)
WHERE username IS NOT NULL;

-- Check Top 10 Largest Tables

SELECT owner, table_name, num_rows, blocks, avg_row_len
FROM dba_tables
ORDER BY blocks DESC
FETCH FIRST 10 ROWS ONLY;

--Query Alerts from Alert Log

SELECT originating_timestamp, message_text
FROM v$alert_log
WHERE message_text LIKE '%ORA-%';

--List All Tables

SELECT owner, table_name
FROM all_tables
ORDER BY owner, table_name;

--To see only your own tables:

SELECT table_name
FROM user_tables
ORDER BY table_name;

--To see all tables in the database (requires DBA privileges):

SELECT owner, table_name
FROM dba_tables
ORDER BY owner, table_name;

--List All Procedures

SELECT owner, object_name AS procedure_name
FROM all_objects
WHERE object_type = 'PROCEDURE'
ORDER BY owner, object_name;

--To list only your own procedures:

SELECT object_name AS procedure_name
FROM user_objects
WHERE object_type = 'PROCEDURE'
ORDER BY object_name;

--To list all procedures in the database (requires DBA privileges):

SELECT owner, object_name AS procedure_name
FROM dba_objects
WHERE object_type = 'PROCEDURE'
ORDER BY owner, object_name;

--List All Functions

SELECT owner, object_name AS function_name
FROM all_objects
WHERE object_type = 'FUNCTION'
ORDER BY owner, object_name;

--To list only your own functions:

SELECT object_name AS function_name
FROM user_objects
WHERE object_type = 'FUNCTION'
ORDER BY object_name;

--To list all functions in the database (requires DBA privileges):

SELECT owner, object_name AS function_name
FROM dba_objects
WHERE object_type = 'FUNCTION'
ORDER BY owner, object_name;

--List All Views

--To list all views you have access to:

SELECT owner, view_name
FROM all_views
ORDER BY owner, view_name;

--To list only your own views:

SELECT view_name
FROM user_views
ORDER BY view_name;

--To list all views in the database (requires DBA privileges):

SELECT owner, view_name
FROM dba_views
ORDER BY owner, view_name;

--List All Triggers

SELECT owner, trigger_name, table_name
FROM all_triggers
ORDER BY owner, trigger_name;

--To list only your own triggers:

SELECT trigger_name, table_name
FROM user_triggers
ORDER BY trigger_name;

--To list all triggers in the database (requires DBA privileges):

SELECT owner, trigger_name, table_name
FROM dba_triggers
ORDER BY owner, trigger_name;

--List All Packages

SELECT owner, object_name AS package_name
FROM all_objects
WHERE object_type = 'PACKAGE'
ORDER BY owner, object_name;

--To list only your own packages:

SELECT object_name AS package_name
FROM user_objects
WHERE object_type = 'PACKAGE'
ORDER BY object_name;

--To list all packages in the database (requires DBA privileges):

SELECT owner, object_name AS package_name
FROM dba_objects
WHERE object_type = 'PACKAGE'
ORDER BY owner, object_name;

--List All Synonyms

SELECT owner, synonym_name, table_name
FROM all_synonyms
ORDER BY owner, synonym_name;

--To list only your own synonyms:

SELECT synonym_name, table_name
FROM user_synonyms
ORDER BY synonym_name;

--To list all synonyms in the database (requires DBA privileges):

SELECT owner, synonym_name, table_name
FROM dba_synonyms
ORDER BY owner, synonym_name;

--List All Materialized Views

SELECT owner, mview_name
FROM all_mviews
ORDER BY owner, mview_name;

--To list only your own materialized views:

SELECT mview_name
FROM user_mviews
ORDER BY mview_name;

--List All Indexes

SELECT owner, index_name, table_name
FROM all_indexes
ORDER BY owner, index_name;

--To list only your own indexes:

SELECT index_name, table_name
FROM user_indexes
ORDER BY index_name;

--List All Object Types

SELECT owner, object_type, object_name
FROM all_objects
ORDER BY owner, object_type, object_name;