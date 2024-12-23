/**********************************DBA_SQL_PLAN_BASELINES  FEILDS *********************

SIGNATURE NUMBER NOT NULL Unique SQL identifier generated from normalized SQL text
SQL_HANDLE VARCHAR2(30) NOT NULL Unique SQL identifier in string form as a search key
SQL_TEXT CLOB NOT NULL Un-normalized SQL text
PLAN_NAME VARCHAR2(30) NOT NULL Unique plan identifier in string form as a search key
CREATOR VARCHAR2(30) User who created the plan baseline
ORIGIN VARCHAR2(14) How the plan baseline was created:
¦ MANUAL-LOAD
¦ AUTO-CAPTURE
¦ MANUAL-SQLTUNE
¦ AUTO-SQLTUNE
PARSING_SCHEMA_NAME VARCHAR2(30) Name of the parsing schema
DESCRIPTION VARCHAR2(500) Text description provided for the plan baseline
VERSION VARCHAR2(64) Database version at the time of plan baseline creation
CREATED TIMESTAMP(6) NOT NULL Timestamp when the plan baseline was created
LAST_MODIFIED TIMESTAMP(6) Timestamp when the plan baseline was last modified
LAST_EXECUTED TIMESTAMP(6) Timestamp when the plan baseline was last executed
LAST_VERIFIED TIMESTAMP(6) Timestamp when the plan baseline was last verified
ENABLED VARCHAR2(3) Indicates whether the plan baseline is enabled (YES) or disabled (NO)
ACCEPTED VARCHAR2(3) Indicates whether the plan baseline is accepted (YES) ornot (NO)
FIXED VARCHAR2(3) Indicates whether the plan baseline is fixed (YES) or not(NO)
REPRODUCED1 VARCHAR2(3) Indicates whether the optimizer was able to reproduce the plan (YES) or not (NO). The value of this column is
set to YES when a plan is initially added to the planbaseline.
AUTOPURGE VARCHAR2(3) Indicates whether the plan baseline is auto-purged (YES)or not (NO)
OPTIMIZER_COST NUMBER Optimizer cost at the time the plan baseline was created
MODULE2 VARCHAR2(48) Application module name
ACTION2 VARCHAR2(32) Application action
EXECUTIONS NUMBER Number of executions at the time the plan baseline was created
ELAPSED_TIME NUMBER Total elapsed time at the time the plan baseline was created
CPU_TIME NUMBER Total CPU time at the time the plan baseline was created
BUFFER_GETS NUMBER Total buffer gets at the time the plan baseline was created
DISK_READS NUMBER Total disk reads at the time the plan baseline was created
DIRECT_WRITES NUMBER Total direct writes at the time the plan baseline wascreated
ROWS_PROCESSED NUMBER Total rows processed at the time the plan baseline was created
FETCHES NUMBER Total number of fetches at the time the plan baseline was created
END_OF_FETCH_COUNT NUMBER Total number of full fetches at the time the plan baseline was created

*/

---------------Automatic Plan Capture
/*I would advise doing considerable testing before using automatic plan capture in a production environment.*/
 ALTER SYSTEM SET OPTIMIZER_CAPTURE_SQL_PLAN_BASELINES=TRUE;

-----------------Manual Plan Loading
/*Manual plan loading can be used in conjunction with, or as an alternative to automatic plan capture.
The load operations are performed using the DBMS_SPM package, which allows SQL plan baselines to be loaded from SQL tuning sets or from specific 
SQL statements in the cursor cache. Manually loaded statements are flagged as accepted by default. . If a SQL plan baseline is present for a SQL statement, the plan is added to 
the baseline, otherwise a new baseline is created.*/


/*The LOAD_PLANS_FROM_CURSOR_CACHE functions allow SQL statements to be loaded from the cursor cache. There are four overloads, allowing statements to be 
identified by a number of criteria, including: SQL_ID, SQL_TEXT, PARSING_SCHEMA_NAME, MODULE and ACTION. The following example identifies 
the SQL statement using the SQL_ID.*/

/***********************************************manually loaded plans are automatically marked as accepted*****/
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(
    sql_id => '1fkh93md0802n');
END;


-------------------------Evolving SQL Plan Baselines
/*When plans are loaded automatically, the baselines are evolved using the EVOLVE_SQL_PLAN_BASELINE function, which returns a CLOB reporting its results.*/

SET LONG 10000
SELECT DBMS_SPM.evolve_sql_plan_baseline(sql_handle => 'SYS_SQL_7b76323ad90440b9')
FROM   dual;

--------------------------SQL Management Base
/*    space_budget_percent (default 10) : Maximum size as a percentage of SYSAUX space. Allowable values 1-50.
    plan_retention_weeks (default 53) : Number of weeks unused plans are retained before being purged. Allowable values 5-523 weeks.*/

SELECT parameter_name, parameter_value
FROM   dba_sql_management_config;

PARAMETER_NAME                 PARAMETER_VALUE
------------------------------ ---------------
SPACE_BUDGET_PERCENT                        10
PLAN_RETENTION_WEEKS                        53


The following example shows both values being reset.

    BEGIN
      DBMS_SPM.configure('space_budget_percent', 11);
      DBMS_SPM.configure('plan_retention_weeks', 54);
    END;
    /
    
--------------------Transferring SQL Plan Baselines
--1 CREATE TABLE 
BEGIN
  DBMS_SPM.CREATE_STGTAB_BASELINE(
    table_name      => 'spm_stageing_tab',
    table_owner     => 'fcb',
    tablespace_name => 'fcb_tbl');
END;

--2 TRANSFERRING DATA
SET SERVEROUTPUT ON
DECLARE
  l_plans_packed  PLS_INTEGER;
BEGIN
  l_plans_packed := DBMS_SPM.pack_stgtab_baseline(
    table_name      => 'spm_stageing_tab',
    table_owner     => 'FCB');

  DBMS_OUTPUT.put_line('Plans Packed: ' || l_plans_packed);
END;

----3
/*The staging table is then transferred to the destination database using data pump or the original export/import utilities.
 Once in the destination database, the SQL plan baselines are imported into the dictionary using the UNPACK_STGTAB_BASELINE function.
  Once again, there are several parameters allowing you to limit amount and type of data you import*/
  --creator IS FEILD ON spm_stageing_tab TABLE THAT BY IS CAN RESTORE DATA JUST CREATOR
SET SERVEROUTPUT ON
DECLARE
  l_plans_unpacked  PLS_INTEGER;
BEGIN
  l_plans_unpacked := DBMS_SPM.unpack_stgtab_baseline(
    table_name      => 'spm_stageing_tab',
    table_owner     => 'FCB',
    creator         => 'FCB');

  DBMS_OUTPUT.put_line('Plans Unpacked: ' || l_plans_unpacked);
END;


-------------------Dropping Plans and Baselines 
-- The DROP_SQL_PLAN_BASELINE function can drop a specific plan from a baseline, or all plans if the plan name is not specified.
    SET SERVEROUTPUT ON
    DECLARE
      l_plans_dropped  PLS_INTEGER;
    BEGIN
      l_plans_dropped := DBMS_SPM.drop_sql_plan_baseline (
        sql_handle => NULL,
        plan_name  => 'SYS_SQL_7b76323ad90440b9');
        
      DBMS_OUTPUT.put_line(l_plans_dropped);
    END;
    /

---------------------Altering Plan Baselines    

/*
    enabled (YES/NO) : If YES, the plan is available for the optimizer if it is also marked as accepted.
    fixed (YES/NO) : If YES, the SQL plan baseline will not evolve over time. Fixed plans are used in preference to non-fixed plans.
    autopurge (YES/NO) : If YES, the SQL plan baseline is purged automatically if it is not used for a period of time.
    plan_name : Used to amend the SQL plan name, up to a maximum of 30 character.
    description : Used to amend the SQL plan description, up to a maximum of 30 character.
*/

SET SERVEROUTPUT ON
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => 'SYS_SQL_7b76323ad90440b9',
    plan_name       => 'SYS_SQL_PLAN_d90440b9ed3324c0',
    attribute_name  => 'fixed',
    attribute_value => 'YES');

  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;

-----------------Displaying SQL Plan Baselines
/*
In addition to querying the DBA_SQL_PLAN_BASELINES view, information about SQL plan baselines is available via the DBMS_XPLAN package. 
The DISPLAY_SQL_PLAN_BASELINE table function displays formatted information about a specific plan, or all plans in the SQL plan baseline in 
one of three formats (BASIC, TYPICAL or ALL). The following example displays the default format (TYPICAL) report for a specific plan.
*/


SET LONG 10000

SELECT *
FROM   TABLE(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>'SYS_SQL_PLAN_d90440b9ed3324c0'));