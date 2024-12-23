CREATE OR REPLACE TRIGGER dbadmin.PREVENT_LOGON after logon on database
declare
  ser varchar2(100);
  dbrole varchar2(200);
-- verr varchar2(4000);
begin
  select database_role into dbrole from v$database;
  if ( user ='FCB_REPORT'   and dbrole='PRIMARY'  )  then
       raise_application_error (-20001,'You can not login to PRIMARY DB.');
  end if;
end;
/