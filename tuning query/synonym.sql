SELECT  ' CREATE SYNONYM FCB_REPORT.' ||TABLE_NAME ||'  FOR FCB.' ||  TABLE_NAME ||' ;'  
FROM DBA_TABLES  WHERE TABLE_NAME NOT IN ( SELECT SYNONYM_NAME FROM  DBA_SYNONYMS  WHERE OWNER='....' ) AND  REGEXP_LIKE (TABLE_NAME, '[TM]_') AND OWNER= 'FCB'






---- synonym for temp tables in fcbtemp is not existed in FCB_REPORT

select 'create or replace synonym '||:SYNONYM_OWNER||'.'||table_name||' for '||table_name||'@FCBTEMP;' from dba_tables@fcbtemp where temporary='Y' and owner='FCBTEMP' 
and table_name like 'TMP_%' and table_name not in (
select synonym_name from dba_synonyms where owner=:SYNONYM_OWNER and db_link='....' and synonym_name like 'TMP_%'
);



-----synonym exists in FCBT_REPORT but not linked to FCBTEMP


select  *  from dba_synonyms where owner=:SYNONYM_OWNER and  synonym_name like 'TMP_%' and db_link is null
and synonym_name  in(select table_name from dba_tables@fcbtemp where temporary='Y' and owner='....' and table_name like 'TMP_%' );