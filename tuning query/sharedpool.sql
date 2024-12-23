select * 
       from v$db_object_cache 
       where kept <> 'YES'
order by executions desc 

select * 
       from v$db_object_cache 
       where kept <> 'YES'
       and type like '%SEQUENCE%'
       and owner in ('FCB', 'ACHUSER')
order by executions desc 


select * from v$db_object_cache where UPPER(name) like '%DBMS_APPLICATION_INFO%' order by executions desc

select * from v$sqltext where UPPER(sql_text) like '%DBMS_APPLICATION_INFO%'
select * from v$sqltext where UPPER(sql_text) like '%SELECT HIBERNATE_SEQUENCE.NEXTVAL FROM DUAL%'

select * from v$sqltext where UPPER(sql_text) like '%PKG_FCB_CONTEXT%'


1	00000007DBF493F0	192072557	16u2bsw5r5kvd	3	0	select pkg_fcb_context.get_value ('instance_name') from dual

SELECT PKG_FCB_CONTEXT.GET_VALUE (''INSTANCE_NAME'') FROM DUAL

     exec dbms_shared_pool.keep('C0000014C3E13FB0, 1161380502', 'C');
     exec dbms_shared_pool.keep('C0000014D3E15288, 232227819', 'C');


select ' exec dbms_shared_pool.keep('||''''||ADDRESS ||', '|| HASH_VALUE || ''''||', ''C'');'  from v$sqltext where UPPER(sql_text) like '%DBMS_APPLICATION_INFO%'
select ' exec dbms_shared_pool.keep('||''''||ADDRESS ||', '|| HASH_VALUE || ''''||', ''C'');' from v$sqltext where UPPER(sql_text) like '%SELECT HIBERNATE_SEQUENCE.NEXTVAL FROM DUAL%'
select  ' exec dbms_shared_pool.keep('||''''||ADDRESS ||', '|| HASH_VALUE || ''''||', ''C'');' from v$sqltext where UPPER(sql_text) like '%PKG_FCB_CONTEXT%'
select  ' exec dbms_shared_pool.keep('||''''||ADDRESS ||', '|| HASH_VALUE || ''''||', ''C'');' from v$sqltext where UPPER(sql_text) like '%PKG_FCB_CONTEXT%'
select  ' exec dbms_shared_pool.keep('||''''||ADDRESS ||', '|| HASH_VALUE || ''''||', ''C'');' from v$sqltext where UPPER(sql_text) like '%P_KILLORPHAN%'