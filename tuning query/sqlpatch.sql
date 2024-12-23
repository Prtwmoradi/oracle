11g :

declare 
patch_name varchar2(4000 char);
begin
patch_name := DBMS_SQLDIAG.create_sql_patch(
sql_id='------',
hint_text => 'IGNORE_OPTIM_EMBEDDED_HINTS');
dbms_output.put_line('patch_name='||patch_name);
end;





after 12.0.1 :

declare 
patch_name varchar2(4000 char);
begin
patch_name := DBMS_SQLDIAG.create_sql_patch(
sql_id='',
hint_text => 'IGNORE_OPTIM_EMBEDDED_HINTS');
dbms_output.put_line('patch_name='||patch_name);
end;


