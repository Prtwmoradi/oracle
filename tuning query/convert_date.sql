--gregorian to persian
select to_char(sysdate,'yyyy/mm/dd','nls_calendar=persian') from dual;


--persian to gregorian

select to_timestamp('1398/01/01','yyyy/mm/dd','nls_calendar=persian') from dual