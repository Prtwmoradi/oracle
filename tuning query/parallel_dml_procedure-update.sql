CREATE TABLE BVAHIDNIA.job_interim_table_update_log
(
  DATE_RANGE   TIMESTAMP(6),
  PART_NAME    VARCHAR2(30 BYTE),
  CURRENTTIME  TIMESTAMP(6),
  TIMER        NUMBER
)
TABLESPACE CMS_TBL
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


GRANT INSERT, SELECT ON BVAHIDNIA.job_interim_table_update_log TO CMS;


CREATE TABLE BVAHIDNIA.job_interim_table_update
(
  ID                      NUMBER(19),
  C_CARDACCOUNTINFOSTR VARCHAR2 (500 Char),
  IS_UPDATE                  NUMBER,
  JOB_NUM                 NUMBER
)
NOCOMPRESS 
TABLESPACE CMS_TBL
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (JOB_NUM)
(  
  PARTITION PART_1 VALUES (1)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_2 VALUES (2)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_3 VALUES (3)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_4 VALUES (4)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_5 VALUES (5)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_6 VALUES (6)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_7 VALUES (7)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_8 VALUES (8)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               ),  
  PARTITION PART_9 VALUES (9)
    LOGGING
    NOCOMPRESS 
    TABLESPACE CMS_TBL
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               )
)
NOCACHE
ENABLE ROW MOVEMENT;


CREATE INDEX BVAHIDNIA.idx_jobinterimtableupdate ON BVAHIDNIA.job_interim_table_update
(JOB_NUM, IS_UPDATE)
  TABLESPACE CMS_INX
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL  PARALLEL ( DEGREE 18 INSTANCES 1 );

CREATE INDEX BVAHIDNIA.idx_jobinterimtableupdate_column ON BVAHIDNIA.job_interim_table_update
(ID)
  TABLESPACE CMS_INX
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL PARALLEL ( DEGREE 20 INSTANCES 1 );


CREATE GLOBAL TEMPORARY TABLE BVAHIDNIA.TMP_ID_ARCH
(
  ID                      NUMBER(19),
  C_CARDACCOUNTINFOSTR VARCHAR2 (500 Char)
)
ON COMMIT DELETE ROWS
NOCACHE;


ALTER TABLE BVAHIDNIA.TMP_ID_ARCH ADD (
  CONSTRAINT PK_TMP
  PRIMARY KEY
  (id)
  USING INDEX BVAHIDNIA.TMP_ID_ARCH_ISS
  ENABLE VALIDATE);


CREATE INDEX BVAHIDNIA.TMP_ID_ARCH_ISS ON BVAHIDNIA.TMP_ID_ARCH
(C_CARDACCOUNTINFOSTR);

CREATE OR REPLACE PROCEDURE BVAHIDNIA.SP_update_DBIFX_PARALLEL(V_JOB NUMBER)
AS
--insert into bvahidnia.job_interim_table_update select aa.id , CONCAT((SELECT LISTAGG(mm.END2_ID,'#') WITHIN GROUP (ORDER BY NULL) as C_CARDACCOUNTINFOSTR FROM cms.T_DBIFX partition (DBIFX_P1390_01_01) dbIfx , MM_DBIFX_CARDACCOUNTINFO mm WHERE mm.END1_ID = dbIfx.ID GROUP BY mm.END1_ID),'#')
      
ROW_COUNT NUMBER := 1;
TIMES NUMBER;
BEGIN
EXECUTE IMMEDIATE 'ALTER  SESSION ENABLE PARALLEL QUERY';
EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL QUERY PARALLEL 15';
EXECUTE IMMEDIATE 'ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=1024';
WHILE ( ROW_COUNT  != 0 )
   LOOP
      TIMES:= DBMS_UTILITY.GET_TIME; 
      INSERT INTO  bvahidnia.TMP_ID_ARCH (SELECT ID,C_CARDACCOUNTINFOSTR FROM bvahidnia.job_interim_table_update  WHERE IS_UPDATE=0  AND job_num=v_job AND ROWNUM <10000 );
      UPDATE cms.T_DBIFX dbIfx SET C_CARDACCOUNTINFOSTR = CONCAT((SELECT LISTAGG(mm.END2_ID,'#') WITHIN GROUP (ORDER BY NULL) FROM MM_DBIFX_CARDACCOUNTINFO mm WHERE mm.END1_ID = dbIfx.ID GROUP BY mm.END1_ID),'#');
       UPDATE (select aa.C_CARDACCOUNTINFOSTR as aaCARDACCOUNTINFOSTR,
                      bb.C_CARDACCOUNTINFOSTR as bbCARDACCOUNTINFOSTR
               from  cms.T_DBIFX  aa , bvahidnia.TMP_ID_ARCH bb  where aa.id=bb.id )
      set      
      aaCARDACCOUNTINFOSTR	= abARDACCOUNTINFOSTR
      ;
      
      UPDATE bvahidnia.job_interim_table_update aa SET IS_UPDATE=1 WHERE exists (select id from  bvahidnia.TMP_ID_ARCH bb where  aa.id=bb.id )  and  IS_UPDATE=0 and job_num=v_job ;
      TIMES:=( DBMS_UTILITY.GET_TIME-TIMES)/100;
      INSERT INTO  BVAHIDNIA.job_interim_table_update_log VALUES (null,'T_DBIFX_'||V_JOB ,SYSTIMESTAMP,TIMES);
      COMMIT;
      SELECT COUNT(1 )into ROW_COUNT  FROM bvahidnia.job_interim_table_update   WHERE IS_UPDATE=0  AND job_num=v_job AND ROWNUM <100    ;
    END LOOP ;   
END SP_update_DBIFX_PARALLEL;
/


--create job per partition

begin
BVAHIDNIA.SP_update_DBIFX_PARALLEL(4);
end;


--UPDATE T_DBIFX dbIfx SET C_CARDACCOUNTINFOSTR = CONCAT((SELECT LISTAGG(mm.END2_ID,'#') WITHIN GROUP (ORDER BY NULL) FROM MM_DBIFX_CARDACCOUNTINFO mm WHERE mm.END1_ID = dbIfx.ID GROUP BY mm.END1_ID),'#');