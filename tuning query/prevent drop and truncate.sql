CREATE TABLE DBADMIN.T_AUDIT_DROPTRUNCATEDDL
(
  C_DATE          DATE,
  C_OSUSER        VARCHAR2(50 BYTE),
  C_CURRENT_USER  VARCHAR2(50 BYTE),
  C_HOST          VARCHAR2(200 BYTE),
  C_TERMINAL      VARCHAR2(200 BYTE),
  C_OWNER         VARCHAR2(50 BYTE),
  C_TYPE          VARCHAR2(100 BYTE),
  C_NAME          VARCHAR2(100 BYTE),
  C_SYSEVENT      VARCHAR2(200 BYTE)
)
TABLESPACE USERS
;


CREATE OR REPLACE PROCEDURE DBADMIN.sp_auditDropTruncate(AOwner varchar2, AType varchar2, AName varchar2, ASysEvent varchar2) AS
BEGIN
  insert into dbadmin.t_audit_DropTruncateddl(c_date, c_osuser, c_current_user, c_host, c_terminal, c_owner, c_type, c_name, c_sysevent)
  values(
    sysdate,
    sys_context('USERENV','OS_USER') ,
    user,
    sys_context('USERENV','HOST') ,
    sys_context('USERENV','TERMINAL') ,
    AOwner,
    AType,
    AName,
    ASysEvent
  );
--  commit;
END sp_auditDropTruncate;


CREATE OR REPLACE TRIGGER DBADMIN.trg_Prevent_dropTruncate before DROP or TRUNCATE ON DATABASE
BEGIN
  dbadmin.sp_auditDropTruncate(ora_dict_obj_owner, ora_dict_obj_type, ora_dict_obj_name, ora_sysevent);

  if user not in ('ANONYMOUS','CTXSYS','DBSNMP',
                  'EXFSYS','FLOWS_030000','FLOWS_FILES',
                  'MDSYS','MGMT_VIEW','OLAPSYS',
                  'ORDPLUGINS','ORDSYS','OUTLN',
                  'OWBSYS','SI_INFORMTN_SCHEMA','SYS',
                  'SYSMAN','SYSTEM','WKPROXY',
                  'WKSYS','WK_TEST','WMSYS',
                  'XDB','APEX_PUBLIC_USER','DIP',
                  'MDDATA','ORACLE_OCM','OVEISI','TSMSYS','XS$NULL','BASHIRI', 'MOSTAFA', 'AMOUZ') then
        raise_application_error (-20001,'You can not drop or truncate objects.');
  end if;
END trg_Prevent_dropTruncate;
/