-- 1- create table 
CREATE TABLE FCBTT.T_DEPOSITLOG_IT
(
  ID                 NUMBER(19),
  C_VERSION          NUMBER(10),
  C_ACTIVE           NUMBER(1),
  C_DEBTORAMOUNT     NUMBER(38,4),
  C_MACHINEIP        VARCHAR2(255 CHAR),
  C_MANUALID         VARCHAR2(255 CHAR),
  C_USERLASTNAME     VARCHAR2(255 CHAR),
  C_TIME             VARCHAR2(255 CHAR),
  C_CREDITORAMOUNT   NUMBER(38,4),
  C_CURRENCYCODE     VARCHAR2(255 CHAR))
  ;
  
  
-- 1- start redifinition  
 
BEGIN
  DBMS_REDEFINITION.start_redef_table(
    uname      => 'FCBT',        
    orig_table => 'T_STRINGVALUE',
    int_table  => 'T_STRINGVALUE_IT',
	col_mapping  => 
	'                                
	ID                             ID                        
	C_VERSION                      C_VERSION                 
	C_ACTIVE                       C_ACTIVE                  
	C_PREVAMOUNT                   C_PREVAMOUNT              
	C_ISSUANCEID                   C_ISSUANCEID              
	C_MANUALID                     C_MANUALID                
	C_TOTALDEBTORAMOUNT            C_TOTALDEBTORAMOUNT       
	C_CREDITORCIRCULATIONCOUNT     C_CREDITORCIRCULATIONCOUNT
	C_COMMENT                      C_COMMENT                 
	C_TOTALCREDITORAMOUNT          C_TOTALCREDITORAMOUNT     
	C_AMOUNT                       C_AMOUNT                  
	C_BLOCKINGITEM                 C_BLOCKINGITEM            
	C_LATEITEM                     C_LATEITEM                
	C_DEBTOR                       C_DEBTOR                  
	C_ROW                          C_ROW                     
	C_DEBTORCIRCULATIONCOUNT       C_DEBTORCIRCULATIONCOUNT  
	C_NEXTAMOUNT                   C_NEXTAMOUNT              
	C_ACCOUNTTYPEITEMID            C_ACCOUNTTYPEITEMID       
	C_ENABLE                       C_ENABLE                  
	C_DOCUMENT                     C_DOCUMENT                
	C_DOCUMENTITEMFIELD_           C_DOCUMENTITEMFIELD_      
	C_OPPOSITEDOCUMENTITEM         C_OPPOSITEDOCUMENTITEM    
	C_ACCOUNT                      C_ACCOUNT                 
	C_CURRENCY                     C_CURRENCY                
	I_DOCUMENT                     I_DOCUMENT                
	C_EQDOCUMENTITEM               C_EQDOCUMENTITEM          
	C_RELATEDBRANCH                C_RELATEDBRANCH           
	C_BRANCH                       C_BRANCH'   
	);
END;



-- 3- create indexes and primary key and sync after every index creation

BEGIN
  dbms_redefinition.start_redef_table(
    uname      => 'FCBT',      
    orig_table => 'T_STRINGVALUE',
    int_table  => 'T_STRINGVALUE_IT');
END;





BEGIN
  dbms_redefinition.sync_interim_table(
    uname      => 'FCBT',      
    orig_table => 'T_STRINGVALUE',
    int_table  => 'T_STRINGVALUE_IT');
END;



 EXEC dbms_stats.gather_table_stats(ownname => 'FCBT',tabname => 'T_DEPOSITLOG',cascade => true,degree => 30,method_opt => 'FOR ALL COLUMNS SIZE 1');

 

-- 4- finish redifinition
 
   
BEGIN
  dbms_redefinition.finish_redef_table(
    uname      => 'FCBT',      
    orig_table => 'T_STRINGVALUE',
    int_table  => 'T_STRINGVALUE_IT');
END;


-- 5- create forein key and referenced keys

--FK
BEGIN
FOR  CUR IN (
SELECT            'ALTER TABLE ' || CC.OWNER || '.'|| CC.TABLE_NAME|| '_IT DROP '|| CHR(10)|| ' CONSTRAINT  ' || C.CONSTRAINT_NAME ||';' ||CHR(10)||CHR(10) 
                 ||'ALTER TABLE ' || CC.OWNER || '.'|| CC.TABLE_NAME|| ' ADD( '|| CHR(10)|| ' CONSTRAINT  ' || C.CONSTRAINT_NAME || '  FOREIGN KEY ( ' || CC.COLUMN_NAME || ') '||  CHR(10) 
                       || ' REFERENCES ' || CCC.OWNER || '.'|| CCC.TABLE_NAME || ' (' || CCC.COLUMN_NAME || ') '||CHR(10)  
                        || DECODE (C.DELETE_RULE, 'CASCADE', ' ON DELETE CASCADE ', ' ')
                 || '  '|| DECODE (C.STATUS, 'ENABLED', 'ENABLE', 'DISABLE') || ' NOVALIDATE )' ||';' ||CHR(10)||CHR(10)    AS SQLSTR2    FROM DBA_CONSTRAINTS C        INNER JOIN DBA_CONS_COLUMNS CC
          ON C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME AND C.OWNER = CC.OWNER
       INNER JOIN DBA_CONS_COLUMNS CCC 
          ON     C.R_CONSTRAINT_NAME = CCC.CONSTRAINT_NAME
             AND CCC.OWNER = C.OWNER              AND CC.POSITION = CCC.POSITION
 WHERE C.TABLE_NAME = 'T_LOANFILE' AND C.OWNER = 'FCB' AND C.CONSTRAINT_TYPE = 'R' ) LOOP
   DBMS_OUTPUT.PUT_LINE (CUR.SQLSTR2);   END LOOP;  END;



--REF
BEGIN  FOR CUR IN (
            select     'ALTER TABLE ' || CC.OWNER || '.'|| CC.TABLE_NAME|| ' DROP '|| CHR(10)|| ' CONSTRAINT  ' || C.CONSTRAINT_NAME ||';' ||CHR(10)||CHR(10) 
                 ||'ALTER TABLE ' || CC.OWNER || '.'|| CC.TABLE_NAME|| ' ADD( '|| CHR(10)|| ' CONSTRAINT  ' || C.CONSTRAINT_NAME || '  FOREIGN KEY ( ' || CC.COLUMN_NAME || ') '||  CHR(10) 
                       || ' REFERENCES ' || CCC.OWNER || '.'|| CCC.TABLE_NAME || ' (' || CCC.COLUMN_NAME || ') '||CHR(10)  
                        || DECODE (C.DELETE_RULE, 'CASCADE', ' ON DELETE CASCADE ', ' ')
                 || '  '|| DECODE (C.STATUS, 'ENABLED', 'ENABLE', 'DISABLE') || ' NOVALIDATE )' ||';' ||CHR(10)||CHR(10)
                 
                    AS SQLSTR2    FROM DBA_CONSTRAINTS C 
 INNER JOIN DBA_CONS_COLUMNS CC ON C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME  AND C.OWNER=CC.OWNER
 INNER JOIN DBA_CONS_COLUMNS CCC ON C.R_CONSTRAINT_NAME = CCC.CONSTRAINT_NAME AND CCC.OWNER=C.OWNER       AND CC.POSITION = CCC.POSITION
 WHERE Ccc.TABLE_NAME = 'T_TEST'  AND ccc.OWNER='FCB' AND C.CONSTRAINT_TYPE = 'R' ) LOOP
  DBMS_OUTPUT.PUT_LINE (CUR.SQLSTR2);   END LOOP;  END;


 
 -- 6- gather statistic
 
 --- gather stat
 
 
 