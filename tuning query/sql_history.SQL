--SCRUTINY_T_ACCOUNT  920522

/*     
select fcb.string_agg(column_name)  from DBA_IND_COLUMNS where index_name=   'ACCOUNT_SERIAL'
select *  from DBA_IND_COLUMNS where index_name='ACCOUNT_SERIAL'
select INDEX_TYPE,UNIQUENESS,CLUSTERING_FACTOR,DISTINCT_KEYS from DBA_INdEXES where index_name='ACCOUNT_SERIAL'

select T1.sql_text,T1.command_type,T2.operation,T2.options,T2.object_name,T2.TIME,T2.timestamp
from dba_hist_sqltext T1 INNER JOIN  dba_hist_sql_plan T2 
ON  T1.sql_id=T2.sql_id
WHERE T2.object_name =UPPER('ACCOUNT_SERIAL')
ORDER  BY TIMESTAMP

select  to_char (substr( T1.sql_text  ,1,8000) ) ||'  ;'
from dba_hist_sqltext T1 INNER JOIN  dba_hist_sql_plan T2 
ON  T1.sql_id=T2.sql_id
WHERE T2.object_name =UPPER('ACCOUNT_SERIAL')
ORDER  BY TIMESTAMP


declare i number :=0;
begin
for cur in (select T1.SQL_TEXT,T1.SQL_ID  from dba_hist_sqltext T1 INNER JOIN  dba_hist_sql_plan T2 
ON  T1.sql_id=T2.sql_id
WHERE T2.object_name =UPPER('PK_TDOCUMENTITEM_GHPI') )
  loop
     i:=i+1;
     DBMS_OUTPUT.PUT_LINE ( '----  ' ||to_char(i) || '   SQL_ID='||cur.SQL_ID);
     DBMS_OUTPUT.PUT_LINE ( cur.SQL_TEXT || ' ;' );
    end loop;
end;



declare i number :=0;
begin
for cur in ( select T1.SQL_FULLTEXT,T1.SQL_ID from  v$sql T1 INNER JOIN  V$SQL_PLAN T2 
ON  T1.sql_id=T2.sql_id
WHERE T2.object_name =UPPER('DCTM_DOC_LPIX') )
  loop
     i:=i+1;
     DBMS_OUTPUT.PUT_LINE ( '----  ' ||to_char(i) || '   SQL_ID='||cur.SQL_ID);
     DBMS_OUTPUT.PUT_LINE ( cur.SQL_FULLTEXT || ' ;' );
    end loop;
end;

*/

select  INDEX_NAME from dba_indexes where table_name ='T_ACCOUNT'

1 --> TACCOUNT_AMOUNTID_IDX  ---> CREATE HASH BY (AMOUNT,ID) INVISBLE ; ADD T_ACCOUNT.C_BRANCH IN FOLLOWING QUERY  FOR USE BETTERE INDEX;
2--> ACCOUNT_FORTASIR_IDX  -->  CREATE THIS INDEX LOCAL 
3--> ACCOUNT_CIX4  -->CREATE TIHS INDEX INVISBLE 
4--> ACCOUNT_MANID  ---> DO NOT CREATE THIS INDEX ,ALL OF COLUMN'S DATA  IS NULL 
5--> ACCOUNT_CIX6  ---> CREATE NEW INDEX INSTEAD TIHS INDEX BUT CRAETE THIS INVISIBLE FOR CANNINESS 
6--> NFK_ACCO_BRAN21--->DO NOT CREATE THIS INDEX (DISTNICT C_BRANCHFIELD_ IS NULL AND FK IS DISABLE)
7--> ACCOUNT_CIX1---->DO NOT CREATE THIS INDEX ( THE FOLLOWING QUERY USE PK)
8--> ACCOUNT_CIX7 ---->create this global hash by id
9--> ACCOUNT_STATUS ---> do not create this  ( not used)
10--> T_ACCOUNT_CIX1 ---> do not create this  ( not used)
11--> T_ACCOUNT_INDEX1---> create this local for queries of index ACCOUNT_CIX6
12--> ACOOUNT_CIX2  ----> do not create this  ( not used)          
13--> SYS_C0012414 -----> create as primary key
14--> SYS_C0012415  ---> create this uniqe hash by c_accountnumber
15-->ACCOUNT_ACCOUNTGROUP  ---> CREATE THIS HASH BY  C_ACCOUNTGROUP
16-->ACCOUNT_ACCOUNTTITLE---> CRAETE THIS BY HAHS C_ACCOUNTTITLE (C_ACCOUNTTITLE,C_ACCOUNTTYPE)
17-->ACCOUNT_ACCOUNTTYPE --->ACCOUNT_ACCOUNTTYPE CRAETE THIS HASH BY (C_ACCOUNTTYPE)
18-->ACCOUNT_AMOUNT -->CREATE NEW COMPOSITE INDEX (C_AMOUNT,C_ACCOUNTTYPE,CID,STATUS,CURRENCY) HASH BY C_AMOUNT
19-->ACCOUNT_BRANCH ---DO NOT CREATE THIS INDEX( NOT USED  and fk is disable)
20-->ACCOUNT_CIX2 ----> DO NOT CREATE THIS INDEX (THE FOLLOWING QUERY USE OF INDEX(C_ACCOUNTNUMBER) )
21-->ACCOUNT_CIX3--->DO NOT CREATE THIS INDEX( NOT USED )
22-->ACCOUNT_CIX5--->ACCOUNT_CIX5   DO NOT CREATE THIS INDEX (THE FOLLOWING QUERY USE OF PK )
23-->ACCOUNT_CURRENCY -->DO NOT CREATE THIS INDEX( NOT USED and fk is diable)
24-->ACCOUNT_CURRENCYACCOUNT--->DO NOT CREATE THIS INDEX( NOT USED)
25-->ACCOUNT_OPPOSITEACCOUNT-->DO NOT CREATE THIS INDEX( NOT USED)
26-->ACCOUNT_SERIAL-->CREATE THIS INDEX BY HASH(C_SERIAL)  (C_SERIAL,C_ACCOUNTTYPE)



1 --> TACCOUNT_AMOUNTID_IDX
(C_AMOUNT,ID) NORMAL,  NONUNIQUE ,   CLUSTERING_FACTOR=5566335 ,NUM_ROWS=6890256
   ---> CREATE HASH BY (AMOUNT,ID) INVISBLE ; ADD T_ACCOUNT.C_BRANCH IN FOLLOWING QUERY  FOR USE BETTERE INDEX;

FAST FULL SCAN=
select * from
(
select dep.c_number,'اصلي' tt, dep.c_title, dep.c_expiredate, cur.c_name, acc.c_amount,to_char(sysdate,'yyyy/mm/dd-hh24:mi:ss','nls_calendar=persian') from 
t_deposit dep
inner join t_accountinfo aci on aci.c_depositofmainacc = dep.id  
inner join t_currency cur on cur.id = aci.c_currency
inner join t_account acc on acc.id = aci.c_accountid
where 
dep.c_branch = :1 
and dep.c_active = 1
union all
select dep.c_number,'مسدودي' tt, dep.c_title, dep.c_expiredate, cur.c_name, acc.c_amount,to_char(sysdate,'yyyy/mm/dd-hh24:mi:ss','nls_calendar=persian') from 
t_deposit dep
inner join t_accountinfo aci on aci.c_depositofintblockacc = dep.id  
inner join t_currency cur on cur.id = aci.c_currency
inner join t_account acc on acc.id = aci.c_accountid
where 
dep.c_branch = :2 
and dep.c_active = 1
) order by c_number, tt ;

FAST FULL SCAN=
select * from
(
select dep.c_number,'اصلي' tt, dep.c_title, dep.c_expiredate, cur.c_name, acc.c_amount,to_char(sysdate,'yyyy/mm/dd-hh24:mi:ss','nls_calendar=persian') from 
t_deposit dep
inner join t_accountinfo aci on aci.c_depositofmainacc = dep.id  
inner join t_currency cur on cur.id = aci.c_currency
inner join t_account acc on acc.id = aci.c_accountid
where 
dep.c_branch = :1 
and dep.c_active = 1
union all
select dep.c_number,'مسدودي' tt, dep.c_title, dep.c_expiredate, cur.c_name, acc.c_amount,to_char(sysdate,'yyyy/mm/dd-hh24:mi:ss','nls_calendar=persian') from 
t_deposit dep
inner join t_accountinfo aci on aci.c_depositofintblockacc = dep.id  
inner join t_currency cur on cur.id = aci.c_currency
inner join t_account acc on acc.id = aci.c_accountid
where 
dep.c_branch = :2 
and dep.c_active = 1
) order by c_number, tt


2--> ACCOUNT_FORTASIR_IDX
(C_BRANCH,ID,C_ACCOUNTNUMBER,C_CURRENCY,C_AMOUNT,C_BASECURRENCYAMOUNT) NORMAL,NONUNIQUE,DISTINCT_KEYS=7302201,CLUSTERING_FACTOR=5426626
-->  CREATE THIS INDEX LOCAL 


RANGE SCAN=
SELECT c_accountnumber, 1
FROM t_Account
WHERE c_branch = :1 
AND c_currency = :2 
and (c_amount <> 0 or c_basecurrencyamount <> 0) ;

FAST FULL SCAN=
select dep.c_branch,aci.c_currency  ,SUM(
  CASE
    WHEN   bdept.c_validityperiod IS NULL AND bdept.c_hasinterest= 1     THEN acc.C_BASECURRENCYAMOUNT    END) kotahmodat  ,SUM(CASE
    WHEN  dept.c_isexternal <>1 and bdept.c_validityperiod IS NULL AND bdept.c_hasinterest= 0 AND dept.c_hassupporter= 0     THEN acc.C_BASECURRENCYAMOUNT    END)gharzolhasane  ,SUM(CASE
    WHEN  dept.c_isexternal =1  and  bdept.c_validityperiod IS NULL AND bdept.c_hasinterest= 0 AND dept.c_hassupporter= 0     THEN acc.C_BASECURRENCYAMOUNT    END)nazdeBank ,SUM(CASE
    WHEN  bdept.c_validityperiod IS NULL AND bdept.c_hasinterest= 0 AND dept.c_hassupporter= 1
    THEN acc.C_BASECURRENCYAMOUNT    END)jari ,SUM(CASE
    WHEN  bdept.c_validityperiod < 12 AND bdept.c_hasinterest= 1
    THEN acc.C_BASECURRENCYAMOUNT    END)kotahvije ,SUM(CASE
    WHEN  bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
    THEN acc.C_BASECURRENCYAMOUNT    END)yeksale ,SUM(CASE
    WHEN  bdept.c_validityperiod = 24 AND bdept.c_hasinterest= 1
    THEN acc.C_BASECURRENCYAMOUNT    END)dosale ,SUM(CASE
    WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
    THEN acc.C_BASECURRENCYAMOUNT    END)sesale ,SUM(CASE
    WHEN  bdept.c_validityperiod =48 AND bdept.c_hasinterest= 1
    THEN acc.C_BASECURRENCYAMOUNT    END)charsale ,SUM(CASE
    WHEN  bdept.c_validityperiod =60 AND bdept.c_hasinterest = 1
    THEN acc.C_BASECURRENCYAMOUNT    END) panjsale  from t_deposit dep 
  INNER JOIN t_deposittype dept ON dept.id = dep.c_deposittype 
  INNER JOIN t_basedeposittype bdept ON bdept.id = dept.id
  INNER JOIN t_accountinfo aci ON (dep.id = aci.c_depositofblockedacc OR dep.id  = aci.c_depositofintblockacc OR dep.id  = aci.c_depositofmainacc)
  INNER JOIN t_account acc ON aci.c_accountid = acc.id
  INNER JOIN  mm_branchgroup_branch BRANCHGROUPBRANCH  on BRANCHGROUPBRANCH.end2_id = dep.c_branch
  WHERE dep.c_active=1
  AND dept.c_isspecial IN(0,NULL)   AND BRANCHGROUPBRANCH.end1_id = :1 
 and aci.c_currency<>1087  group by dep.c_branch,aci.c_currency 


3--> ACCOUNT_CIX4  --> CREATE TIHS INDEX INVISBLE 
(C_BRANCH,ID) , NORMAL , UNIQUE ,CLUSTERING_FACTOR=5392714,DISTINCT_KEYS=7154220
---> NO SQL FOUND


4--> ACCOUNT_MANID ---> DO NOT CREATE THIS INDEX ,ALL OF COLUMN'S DATA  IS NULL
(C_MANUALID),NORMAL,   UNIQUE , CLUSTERING_FACTOR=0, DISTINCT_KEYS=0
---> NO SQL FOUND

5--> ACCOUNT_CIX6  ---->CREATE NEW INDEX INSTEAD TIHS INDEX BUT CRAETE THIS INVISIBLE FOR CANNINESS 
(C_CURRENCY,C_ACCOUNTTYPE,ID,C_BRANCH,C_VERSION,C_ACTIVE,C_DEBTORAMOUNT,C_MANUALID,C_ACCOUNTNUMBER,C_CREDITORAMOUNT,C_CREDITORCIRCULATIONCOUNT,
C_CURRENCYACCOUNT,C_BASECURRENCYDEBTORAMOUNT,C_MINAMOUNT,C_ACCOUNTTITLE,C_AMOUNT,C_DEBTORCIRCULATIONCOUNT,C_BASECURRENCYAMOUNT,
C_SECURRENCYCREDITORAMOUNT,C_MAXAMOUNT,C_OPENINGDATE,C_ENABLE,C_SERIAL,C_OPPOSITEACCOUNT,C_ACCOUNTGROUP,C_STATUS)    

26cols,  NORMAL , NONUNIQUE ,CLUSTERING_FACTOR=7019572,DISTINCT_KEYS=7353179


RANGE SCAN :

SELECT this_.id AS id63_1_,
       this_.c_version AS c2_63_1_,
       this_.c_active AS c3_63_1_,
       this_.c_debtorAmount AS c4_63_1_,
       this_.c_manualId AS c5_63_1_,
       this_.c_accountNumber AS c6_63_1_,
       this_.c_creditorAmount AS c7_63_1_,
       this_.c_creditorCirculationCount AS c8_63_1_,
       this_.c_currencyAccount AS c9_63_1_,
       this_.c_baseCurrencyDebtorAmount AS c10_63_1_,
       this_.c_minAmount AS c11_63_1_,
       this_.c_accountTitle AS c12_63_1_,
       this_.c_amount AS c13_63_1_,
       this_.c_debtorCirculationCount AS c14_63_1_,
       this_.c_baseCurrencyAmount AS c15_63_1_,
       this_.c_seCurrencyCreditorAmount AS c16_63_1_,
       this_.c_maxAmount AS c17_63_1_,
       this_.c_openingDate AS c18_63_1_,
       this_.c_enable AS c19_63_1_,
       this_.c_serial AS c20_63_1_,
       this_.c_accountType AS c21_63_1_,
       this_.c_oppositeAccount AS c22_63_1_,
       this_.c_accountGroup AS c23_63_1_,
       this_.c_currency AS c24_63_1_,
       this_.c_branch AS c25_63_1_,
       this_.c_status AS c26_63_1_,
       at1_.id AS id69_0_,
       at1_.c_version AS c2_69_0_,
       at1_.c_active AS c3_69_0_,
       at1_.c_manualId AS c4_69_0_,
       at1_.c_totalDebtorAmount AS c5_69_0_,
       at1_.c_creditorCirculationCount AS c6_69_0_,
       at1_.c_atestAutoGeneratedNumber AS c7_69_0_,
       at1_.c_eqTtDebtAm AS c8_69_0_,
       at1_.c_totalCreditorAmount AS c9_69_0_,
       at1_.c_totalAmount AS c10_69_0_,
       at1_.c_code AS c11_69_0_,
       at1_.c_eqTtAm AS c12_69_0_,
       at1_.c_debtorCirculationCount AS c13_69_0_,
       at1_.c_eqDebtCirCn AS c14_69_0_,
       at1_.c_eqCredCirCn AS c15_69_0_,
       at1_.c_eqTtCredAm AS c16_69_0_,
       at1_.c_enable AS c17_69_0_,
       at1_.c_oppositeAccountType AS c18_69_0_,
       at1_.c_topic AS c19_69_0_,
       at1_.c_currency AS c20_69_0_,
       at1_.c_branch AS c21_69_0_
  FROM t_Account this_ INNER JOIN t_AccountType at1_
          ON this_.c_accountType = at1_.id
 WHERE this_.c_branch = :1 AND this_.c_currency = :2 AND at1_.c_topic = :3 ;


    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 16404
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT ;



SELECT this_.id AS id62_1_,
       this_.c_version AS c2_62_1_,
       this_.c_active AS c3_62_1_,
       this_.c_debtorAmount AS c4_62_1_,
       this_.c_manualId AS c5_62_1_,
       this_.c_accountNumber AS c6_62_1_,
       this_.c_creditorAmount AS c7_62_1_,
       this_.c_creditorCirculationCount AS c8_62_1_,
       this_.c_currencyAccount AS c9_62_1_,
       this_.c_baseCurrencyDebtorAmount AS c10_62_1_,
       this_.c_minAmount AS c11_62_1_,
       this_.c_accountTitle AS c12_62_1_,
       this_.c_amount AS c13_62_1_,
       this_.c_debtorCirculationCount AS c14_62_1_,
       this_.c_baseCurrencyAmount AS c15_62_1_,
       this_.c_seCurrencyCreditorAmount AS c16_62_1_,
       this_.c_maxAmount AS c17_62_1_,
       this_.c_openingDate AS c18_62_1_,
       this_.c_enable AS c19_62_1_,
       this_.c_serial AS c20_62_1_,
       this_.c_accountType AS c21_62_1_,
       this_.c_oppositeAccount AS c22_62_1_,
       this_.c_accountGroup AS c23_62_1_,
       this_.c_currency AS c24_62_1_,
       this_.c_branch AS c25_62_1_,
       this_.c_status AS c26_62_1_,
       at1_.id AS id68_0_,
       at1_.c_version AS c2_68_0_,
       at1_.c_active AS c3_68_0_,
       at1_.c_manualId AS c4_68_0_,
       at1_.c_totalDebtorAmount AS c5_68_0_,
       at1_.c_creditorCirculationCount AS c6_68_0_,
       at1_.c_atestAutoGeneratedNumber AS c7_68_0_,
       at1_.c_eqTtDebtAm AS c8_68_0_,
       at1_.c_totalCreditorAmount AS c9_68_0_,
       at1_.c_totalAmount AS c10_68_0_,
       at1_.c_code AS c11_68_0_,
       at1_.c_eqTtAm AS c12_68_0_,
       at1_.c_debtorCirculationCount AS c13_68_0_,
       at1_.c_eqDebtCirCn AS c14_68_0_,
       at1_.c_eqCredCirCn AS c15_68_0_,
       at1_.c_eqTtCredAm AS c16_68_0_,
       at1_.c_enable AS c17_68_0_,
       at1_.c_oppositeAccountType AS c18_68_0_,
       at1_.c_topic AS c19_68_0_,
       at1_.c_currency AS c20_68_0_,
       at1_.c_branch AS c21_68_0_
  FROM t_Account this_ INNER JOIN t_AccountType at1_
          ON this_.c_accountType = at1_.id
 WHERE this_.c_branch = :1 AND this_.c_currency = :2 AND at1_.c_topic = :3 ;



/* Formatted on 14-Aug-13 11:31:47 AM (QP5 v5.136.908.31019) */
SELECT this_.id AS id63_1_,
       this_.c_version AS c2_63_1_,
       this_.c_active AS c3_63_1_,
       this_.c_debtorAmount AS c4_63_1_,
       this_.c_manualId AS c5_63_1_,
       this_.c_accountNumber AS c6_63_1_,
       this_.c_creditorAmount AS c7_63_1_,
       this_.c_creditorCirculationCount AS c8_63_1_,
       this_.c_currencyAccount AS c9_63_1_,
       this_.c_baseCurrencyDebtorAmount AS c10_63_1_,
       this_.c_minAmount AS c11_63_1_,
       this_.c_accountTitle AS c12_63_1_,
       this_.c_amount AS c13_63_1_,
       this_.c_debtorCirculationCount AS c14_63_1_,
       this_.c_baseCurrencyAmount AS c15_63_1_,
       this_.c_seCurrencyCreditorAmount AS c16_63_1_,
       this_.c_maxAmount AS c17_63_1_,
       this_.c_openingDate AS c18_63_1_,
       this_.c_enable AS c19_63_1_,
       this_.c_serial AS c20_63_1_,
       this_.c_accountType AS c21_63_1_,
       this_.c_oppositeAccount AS c22_63_1_,
       this_.c_accountGroup AS c23_63_1_,
       this_.c_currency AS c24_63_1_,
       this_.c_branch AS c25_63_1_,
       this_.c_status AS c26_63_1_,
       at1_.id AS id69_0_,
       at1_.c_version AS c2_69_0_,
       at1_.c_active AS c3_69_0_,
       at1_.c_manualId AS c4_69_0_,
       at1_.c_totalDebtorAmount AS c5_69_0_,
       at1_.c_creditorCirculationCount AS c6_69_0_,
       at1_.c_atestAutoGeneratedNumber AS c7_69_0_,
       at1_.c_eqTtDebtAm AS c8_69_0_,
       at1_.c_totalCreditorAmount AS c9_69_0_,
       at1_.c_totalAmount AS c10_69_0_,
       at1_.c_code AS c11_69_0_,
       at1_.c_eqTtAm AS c12_69_0_,
       at1_.c_debtorCirculationCount AS c13_69_0_,
       at1_.c_eqDebtCirCn AS c14_69_0_,
       at1_.c_eqCredCirCn AS c15_69_0_,
       at1_.c_eqTtCredAm AS c16_69_0_,
       at1_.c_enable AS c17_69_0_,
       at1_.c_oppositeAccountType AS c18_69_0_,
       at1_.c_topic AS c19_69_0_,
       at1_.c_currency AS c20_69_0_,
       at1_.c_branch AS c21_69_0_
  FROM t_Account this_ INNER JOIN t_AccountType at1_
          ON this_.c_accountType = at1_.id
 WHERE this_.c_branch = :1 AND this_.c_currency = :2 AND at1_.c_topic = :3 ; 


/* Formatted on 14-Aug-13 11:53:19 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 15942
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT ;


/* Formatted on 14-Aug-13 11:53:44 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 142653
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT ;


/* Formatted on 14-Aug-13 11:54:34 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 17244
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT ;

/* Formatted on 14-Aug-13 11:54:49 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 16656
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT ;


/* Formatted on 14-Aug-13 11:56:12 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 16131
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT


/* Formatted on 14-Aug-13 11:56:36 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 16845
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT


/* Formatted on 14-Aug-13 11:57:01 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 15753
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT


/* Formatted on 14-Aug-13 11:57:17 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = '2F2060'
           AND account0_.c_branch = 145631
           AND account0_.c_currency = 1087
FOR UPDATE OF account0_.id NOWAIT

/* Formatted on 14-Aug-13 11:57:35 AM (QP5 v5.136.908.31019) */
    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
     WHERE     account0_.c_accountType = accounttyp1_.id
           AND accounttyp1_.c_topic = topic2_.id
           AND topic2_.c_code = :1
           AND account0_.c_branch = :2
           AND account0_.c_currency = :3
FOR UPDATE OF account0_.id NOWAIT


6--> NFK_ACCO_BRAN21 --->DO NOT CREATE THIS INDEX (DISTNICT C_BRANCHFIELD_ IS NULL AND FK IS DISABLE)
(C_BRANCHFIELD_) ,NORMAL ,   NONUNIQUE, CLUSTERING_FACTOR =0,   DISTINCT_KEYS=0

---NO SQL FOUND


7--> ACCOUNT_CIX1   -->DO NOT CREATE THIS INDEX ( THE FOLLOWING QUERY USE PK)
(ID,C_CURRENCY) ,NORMAL ,   UNIQUE,    CLUSTERING_FACTOR =5458161 ,    DISTINCT_KEYS= 7183682 


RANGE SCAN :

  SELECT ACTI.ID ACCTYPEITEMID,
         ACTI.C_ENABLE,
         ACTI.C_ACTIVE,
         ACTI.C_DEBTOR,
         C_ISSUANCEID VI_ISSUANCEID,
         ACC.C_CURRENCY ACCCURRENY,
         ACTI.C_CURRENCYID ACTICURRENCY,
         ACTI.C_EQATIID
    FROM T_ACCOUNTTYPEITEM ACTI INNER JOIN T_ACCOUNT ACC
            ON ACC.ID = ACTI.C_ACCOUNTID
   WHERE     C_ACCOUNTTYPEID = :B4
         AND C_ISSUANCEID > :B3
         AND C_ISSUANCEID <= :B2
         AND C_BRANCHID = :B1
ORDER BY C_ISSUANCEID;

/* Formatted on 14-Aug-13 12:05:56 PM (QP5 v5.136.908.31019) */
  SELECT ACTI.ID ACCTYPEITEMID,
         ACTI.C_ENABLE,
         ACTI.C_ACTIVE,
         ACTI.C_DEBTOR,
         C_ISSUANCEID VI_ISSUANCEID,
         ACC.C_CURRENCY ACCCURRENY,
         ACTI.C_CURRENCYID ACTICURRENCY,
         ACTI.C_EQATIID
    FROM T_ACCOUNTTYPEITEM ACTI INNER JOIN T_ACCOUNT ACC
            ON ACC.ID = ACTI.C_ACCOUNTID
   WHERE     C_ACCOUNTTYPEID = :B4
         AND C_ISSUANCEID > :B3
         AND C_ISSUANCEID <= :B2
         AND C_BRANCHID = :B1
ORDER BY C_ISSUANCEID;


UNIQUE SCAN :
/* Formatted on 14-Aug-13 12:06:02 PM (QP5 v5.136.908.31019) */
SELECT this_.id AS id471_1_,
       this_.c_version AS c2_471_1_,
       this_.c_active AS c3_471_1_,
       this_.c_manualId AS c4_471_1_,
       this_.c_enable AS c5_471_1_,
       this_.c_account AS c6_471_1_,
       this_.c_topic AS c7_471_1_,
       this_.c_currency AS c8_471_1_,
       this_.c_branch AS c9_471_1_,
       acc1_.id AS id63_0_,
       acc1_.c_version AS c2_63_0_,
       acc1_.c_active AS c3_63_0_,
       acc1_.c_debtorAmount AS c4_63_0_,
       acc1_.c_manualId AS c5_63_0_,
       acc1_.c_accountNumber AS c6_63_0_,
       acc1_.c_creditorAmount AS c7_63_0_,
       acc1_.c_creditorCirculationCount AS c8_63_0_,
       acc1_.c_currencyAccount AS c9_63_0_,
       acc1_.c_baseCurrencyDebtorAmount AS c10_63_0_,
       acc1_.c_minAmount AS c11_63_0_,
       acc1_.c_accountTitle AS c12_63_0_,
       acc1_.c_amount AS c13_63_0_,
       acc1_.c_debtorCirculationCount AS c14_63_0_,
       acc1_.c_baseCurrencyAmount AS c15_63_0_,
       acc1_.c_seCurrencyCreditorAmount AS c16_63_0_,
       acc1_.c_maxAmount AS c17_63_0_,
       acc1_.c_openingDate AS c18_63_0_,
       acc1_.c_enable AS c19_63_0_,
       acc1_.c_serial AS c20_63_0_,
       acc1_.c_accountType AS c21_63_0_,
       acc1_.c_oppositeAccount AS c22_63_0_,
       acc1_.c_accountGroup AS c23_63_0_,
       acc1_.c_currency AS c24_63_0_,
       acc1_.c_branch AS c25_63_0_,
       acc1_.c_status AS c26_63_0_
  FROM t_CurrencyDealAccount this_ INNER JOIN t_Account acc1_
          ON this_.c_account = acc1_.id
 WHERE     this_.c_currency = :1
       AND this_.c_topic = :2
       AND this_.c_branch = :3
       AND acc1_.c_currency = :4 



8--> ACCOUNT_CIX7 ---> create this global hash by id
(ID,C_ACCOUNTTYPE) , NORMAL  ,  UNIQUE  ,  CLUSTERING_FACTOR=    5269194,    DISTINCT_KEYS=6832518 
    
RANGE SCAN : 

/* Formatted on 14-Aug-13 2:03:03 PM (QP5 v5.136.908.31019) */
SELECT COUNT (id)
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_Date >= :2
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :3
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :4
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE);

SELECT *
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_Date >= :2
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :3
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :4
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE)
 WHERE ROWNUM <= :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                                  DOC.ID,
                                  DOC.C_VERSION,
                                  DOC.C_ACTIVE,
                                  DOC.C_MANUALID,
                                  DOC.C_SHEETNUMBER,
                                  DOC.C_EFFECTIVEDATE,
                                  DOC.C_COMMENT,
                                  DOC.C_DATE,
                                  DOC.C_EQUIVALENT,
                                  DOC.C_DOCUMENTNUMBER,
                                  DOC.C_ISSUANCEDATE,
                                  DOC.C_TRANSACTIONNUMBER,
                                  DOC.C_ENDOFYEARDOCUMENT,
                                  DOC.C_SERIAL,
                                  DOC.C_ENABLE,
                                  DOC.C_BRANCHBANKBOOK,
                                  DOC.C_EQUIVALENTDOCUMENT,
                                  DOC.C_BANKBOOK,
                                  DOC.C_CURRENCY,
                                  DOC.C_STATUS,
                                  DOC.C_RELATEDBRANCH,
                                  DOC.C_ISSUER,
                                  DOC.C_CONFIRMER,
                                  DOC.C_SYSTEMOPERATION,
                                  DOC.C_SUBSYSTEM,
                                  DOC.C_BRANCH,
                                  DOC.C_TEMPLATECODE
                    FROM T_DOCUMENT DOC,
                         T_DOCUMENTITEM DI,
                         T_ACCOUNT AC,
                         T_ACCOUNTTYPE ACT,
                         T_TOPIC TP,
                         T_AUTHORITY AU,
                         T_PERSONNEL PER
                   WHERE     1 = 1
                         AND DOC.C_RELATEDBRANCH = :1
                         AND DOC.C_Date >= :2
                         AND DOC.C_ISSUER = AU.ID
                         AND AU.C_PERSONNEL = PER.ID
                         AND PER.C_UID = :3
                         AND DI.C_DOCUMENT = DOC.ID
                         AND DI.C_ACCOUNT = AC.ID
                         AND TP.C_CODE = :4
                         AND AC.C_ACCOUNTTYPE = ACT.ID
                         AND ACT.C_TOPIC = TP.ID
                ORDER BY DOC.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2, :3, :4)
FOR UPDATE OF account0_.id NOWAIT;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 1394966
                                   AND DOC.C_Date >= '1392/05/12-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4835')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/12-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_CURRENCY = :2
                 AND DOC.C_Date >= :3
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :4
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_Date >= :2
                 AND DOC.C_Date <= :3
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :4
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :5
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE);

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/13-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 143845
                           AND DOC.C_Date >= '1392/03/26-00:00.00.000'
                           AND DOC.C_Date <= '1392/04/01-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '2956')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 278354
                                   AND DOC.C_Date >= '1392/05/14-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4822')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/14-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 602554
                                   AND DOC.C_Date >= '1392/05/14-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4247')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/15-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_CURRENCY = :2
                 AND DOC.C_Date >= :3
                 AND DOC.C_Date <= :4
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :5
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :6
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE);

SELECT *
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER,
                 T_AUTHORITY AU1,
                 T_PERSONNEL PER1
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_Date >= :2
                 AND DOC.C_Date <= :3
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :4
                 AND DOC.C_ISSUER = AU1.ID
                 AND AU1.C_PERSONNEL = PER1.ID
                 AND PER1.C_PERSONNELCODE <> 'switch'
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :5
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE)
 WHERE ROWNUM <= :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC,
                           T_AUTHORITY AU,
                           T_PERSONNEL PER,
                           T_AUTHORITY AU1,
                           T_PERSONNEL PER1
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1149467628
                           AND DOC.C_CURRENCY = 1087
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/16-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4669'
                           AND DOC.C_ISSUER = AU1.ID
                           AND AU1.C_PERSONNEL = PER1.ID
                           AND PER1.C_PERSONNELCODE <> 'switch')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER,
                          T_AUTHORITY AU1,
                          T_PERSONNEL PER1
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_CURRENCY = :2
                          AND DOC.C_Date >= :3
                          AND DOC.C_Date <= :4
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :5
                          AND DOC.C_ISSUER = AU1.ID
                          AND AU1.C_PERSONNEL = PER1.ID
                          AND PER1.C_UID <> 'switch'
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :6
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1185058062
                           AND DOC.C_Date >= '1392/05/16-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4810')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1185058062
                           AND DOC.C_Date >= '1392/05/16-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4810')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                                  DOC.ID,
                                  DOC.C_VERSION,
                                  DOC.C_ACTIVE,
                                  DOC.C_MANUALID,
                                  DOC.C_SHEETNUMBER,
                                  DOC.C_EFFECTIVEDATE,
                                  DOC.C_COMMENT,
                                  DOC.C_DATE,
                                  DOC.C_EQUIVALENT,
                                  DOC.C_DOCUMENTNUMBER,
                                  DOC.C_ISSUANCEDATE,
                                  DOC.C_TRANSACTIONNUMBER,
                                  DOC.C_ENDOFYEARDOCUMENT,
                                  DOC.C_SERIAL,
                                  DOC.C_ENABLE,
                                  DOC.C_BRANCHBANKBOOK,
                                  DOC.C_EQUIVALENTDOCUMENT,
                                  DOC.C_BANKBOOK,
                                  DOC.C_CURRENCY,
                                  DOC.C_STATUS,
                                  DOC.C_RELATEDBRANCH,
                                  DOC.C_ISSUER,
                                  DOC.C_CONFIRMER,
                                  DOC.C_SYSTEMOPERATION,
                                  DOC.C_SUBSYSTEM,
                                  DOC.C_BRANCH,
                                  DOC.C_TEMPLATECODE
                    FROM T_DOCUMENT DOC,
                         T_DOCUMENTITEM DI,
                         T_ACCOUNT AC,
                         T_ACCOUNTTYPE ACT,
                         T_TOPIC TP,
                         T_AUTHORITY AU1,
                         T_PERSONNEL PER1
                   WHERE     1 = 1
                         AND DOC.C_RELATEDBRANCH = :1
                         AND DOC.C_Date >= :2
                         AND DOC.C_ISSUER = AU1.ID
                         AND AU1.C_PERSONNEL = PER1.ID
                         AND PER1.C_PERSONNELCODE <> 'switch'
                         AND DI.C_DOCUMENT = DOC.ID
                         AND DI.C_ACCOUNT = AC.ID
                         AND TP.C_CODE = :3
                         AND AC.C_ACCOUNTTYPE = ACT.ID
                         AND ACT.C_TOPIC = TP.ID
                ORDER BY DOC.C_DATE) row_
         WHERE ROWNUM <= :4)
 WHERE rownum_ > :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/16-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2, :3, :4)
FOR UPDATE OF account0_.id NOWAIT;

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 144790
                           AND DOC.C_Date >= '1392/05/16-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '3332')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 3050271099
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/17-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '2855')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1394966
                           AND DOC.C_Date >= '1392/05/15-00:00.00.000'
                           AND DOC.C_Date <= '1393/05/15-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4782')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 3050271099
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/01-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '2855')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_DOCUMENTITEM DI
                     WHERE     1 = 1
                           AND DOC.C_BRANCH = 1149467628
                           AND DOC.C_RELATEDBRANCH = 1149467628
                           AND DOC.C_Date >= '1392/03/17-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/17-23:59.59.999'
                           AND DI.C_COMMENT LIKE '%افتتاح%'
                           AND DI.C_DOCUMENT = DOC.ID)
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_BRANCH = :1
                          AND DOC.C_RELATEDBRANCH = :2
                          AND DOC.C_Date >= :3
                          AND DOC.C_Date <= :4
                          AND DI.C_COMMENT LIKE '%' || :5 || '%'
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :6
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 278354
                                   AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4822')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 3050271099
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/01-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '2855')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1185058062
                           AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4810')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1185058062
                           AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4810')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 75881526
                           AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '3335')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 75881526
                           AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '3335')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/17-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 16152
                           AND DOC.C_Date >= '1392/05/16-00:00.00.000')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :3
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 145558
                           AND DOC.C_Date >= '1392/02/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/04/31-23:59.59.999')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 278354
                                   AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4822')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 16572
                                   AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4428')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 354837141
                                   AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4595')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 145558
                           AND DOC.C_Date >= '1392/02/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/04/31-23:59.59.999')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1185058062
                           AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4810')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 1394966
                                   AND DOC.C_Date >= '1392/05/20-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4835')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 16572
                                   AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4428')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                                  DOC.ID,
                                  DOC.C_VERSION,
                                  DOC.C_ACTIVE,
                                  DOC.C_MANUALID,
                                  DOC.C_SHEETNUMBER,
                                  DOC.C_EFFECTIVEDATE,
                                  DOC.C_COMMENT,
                                  DOC.C_DATE,
                                  DOC.C_EQUIVALENT,
                                  DOC.C_DOCUMENTNUMBER,
                                  DOC.C_ISSUANCEDATE,
                                  DOC.C_TRANSACTIONNUMBER,
                                  DOC.C_ENDOFYEARDOCUMENT,
                                  DOC.C_SERIAL,
                                  DOC.C_ENABLE,
                                  DOC.C_BRANCHBANKBOOK,
                                  DOC.C_EQUIVALENTDOCUMENT,
                                  DOC.C_BANKBOOK,
                                  DOC.C_CURRENCY,
                                  DOC.C_STATUS,
                                  DOC.C_RELATEDBRANCH,
                                  DOC.C_ISSUER,
                                  DOC.C_CONFIRMER,
                                  DOC.C_SYSTEMOPERATION,
                                  DOC.C_SUBSYSTEM,
                                  DOC.C_BRANCH,
                                  DOC.C_TEMPLATECODE
                    FROM T_DOCUMENT DOC,
                         T_DOCUMENTITEM DI,
                         T_ACCOUNT AC,
                         T_ACCOUNTTYPE ACT,
                         T_TOPIC TP,
                         T_AUTHORITY AU,
                         T_PERSONNEL PER,
                         T_AUTHORITY AU1,
                         T_PERSONNEL PER1
                   WHERE     1 = 1
                         AND DOC.C_RELATEDBRANCH = :1
                         AND DOC.C_Date >= :2
                         AND DOC.C_ISSUER = AU.ID
                         AND AU.C_PERSONNEL = PER.ID
                         AND PER.C_UID = :3
                         AND DOC.C_ISSUER = AU1.ID
                         AND AU1.C_PERSONNEL = PER1.ID
                         AND PER1.C_PERSONNELCODE <> 'switch'
                         AND DI.C_DOCUMENT = DOC.ID
                         AND DI.C_ACCOUNT = AC.ID
                         AND TP.C_CODE = :4
                         AND AC.C_ACCOUNTTYPE = ACT.ID
                         AND ACT.C_TOPIC = TP.ID
                ORDER BY DOC.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 602554
                           AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4247')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 602554
                                   AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4247')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 143147
                           AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4513')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE)
 WHERE ROWNUM <= :5;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 1394966
                                   AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4835')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/21-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 1040390659
                           AND DOC.C_CURRENCY = 1087
                           AND DOC.C_Date >= '1392/05/01-00:00.00.000'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '4090')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_CURRENCY = :2
                          AND DOC.C_Date >= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (DOC.ID || doc.c_date),
                          DOC.ID,
                          DOC.C_VERSION,
                          DOC.C_ACTIVE,
                          DOC.C_MANUALID,
                          DOC.C_SHEETNUMBER,
                          DOC.C_EFFECTIVEDATE,
                          DOC.C_COMMENT,
                          DOC.C_DATE,
                          DOC.C_EQUIVALENT,
                          DOC.C_DOCUMENTNUMBER,
                          DOC.C_ISSUANCEDATE,
                          DOC.C_TRANSACTIONNUMBER,
                          DOC.C_ENDOFYEARDOCUMENT,
                          DOC.C_SERIAL,
                          DOC.C_ENABLE,
                          DOC.C_BRANCHBANKBOOK,
                          DOC.C_EQUIVALENTDOCUMENT,
                          DOC.C_BANKBOOK,
                          DOC.C_CURRENCY,
                          DOC.C_STATUS,
                          DOC.C_RELATEDBRANCH,
                          DOC.C_ISSUER,
                          DOC.C_CONFIRMER,
                          DOC.C_SYSTEMOPERATION,
                          DOC.C_SUBSYSTEM,
                          DOC.C_BRANCH,
                          DOC.C_TEMPLATECODE
            FROM T_DOCUMENT DOC,
                 T_DOCUMENTITEM DI,
                 T_ACCOUNT AC,
                 T_ACCOUNTTYPE ACT,
                 T_TOPIC TP,
                 T_AUTHORITY AU,
                 T_PERSONNEL PER
           WHERE     1 = 1
                 AND DOC.C_RELATEDBRANCH = :1
                 AND DOC.C_Date >= :2
                 AND DOC.C_Date <= :3
                 AND DOC.C_COMMENT LIKE '%' || :4 || '%'
                 AND DOC.C_ISSUER = AU.ID
                 AND AU.C_PERSONNEL = PER.ID
                 AND PER.C_UID = :5
                 AND DI.C_DOCUMENT = DOC.ID
                 AND DI.C_ACCOUNT = AC.ID
                 AND TP.C_CODE = :6
                 AND AC.C_ACCOUNTTYPE = ACT.ID
                 AND ACT.C_TOPIC = TP.ID
        ORDER BY DOC.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC, T_AUTHORITY AU, T_PERSONNEL PER
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 145425
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/22-23:59.59.999'
                           AND DOC.C_ISSUER = AU.ID
                           AND AU.C_PERSONNEL = PER.ID
                           AND PER.C_UID = '3882')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP,
                          T_AUTHORITY AU,
                          T_PERSONNEL PER
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DOC.C_ISSUER = AU.ID
                          AND AU.C_PERSONNEL = PER.ID
                          AND PER.C_UID = :4
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :5
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_
     WHERE account0_.id IN
                 (:1,
                  :2,
                  :3,
                  :4,
                  :5,
                  :6,
                  :7,
                  :8,
                  :9,
                  :10,
                  :11,
                  :12,
                  :13,
                  :14,
                  :15,
                  :16,
                  :17,
                  :18,
                  :19,
                  :20,
                  :21)
FOR UPDATE OF account0_.id NOWAIT;

SELECT *
  FROM (SELECT row_.*, ROWNUM rownum_
          FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                                  tbl.ID,
                                  tbl.C_VERSION,
                                  tbl.C_ACTIVE,
                                  tbl.C_MANUALID,
                                  tbl.C_SHEETNUMBER,
                                  tbl.C_EFFECTIVEDATE,
                                  tbl.C_COMMENT,
                                  tbl.C_DATE,
                                  tbl.C_EQUIVALENT,
                                  tbl.C_DOCUMENTNUMBER,
                                  tbl.C_ISSUANCEDATE,
                                  tbl.C_TRANSACTIONNUMBER,
                                  tbl.C_ENDOFYEARDOCUMENT,
                                  tbl.C_SERIAL,
                                  tbl.C_ENABLE,
                                  tbl.C_BRANCHBANKBOOK,
                                  tbl.C_EQUIVALENTDOCUMENT,
                                  tbl.C_BANKBOOK,
                                  tbl.C_CURRENCY,
                                  tbl.C_STATUS,
                                  tbl.C_RELATEDBRANCH,
                                  tbl.C_ISSUER,
                                  tbl.C_CONFIRMER,
                                  tbl.C_SYSTEMOPERATION,
                                  tbl.C_SUBSYSTEM,
                                  tbl.C_BRANCH,
                                  tbl.C_TEMPLATECODE
                    FROM ( (SELECT DOC.*
                              FROM T_DOCUMENT DOC,
                                   T_AUTHORITY AU,
                                   T_PERSONNEL PER
                             WHERE     1 = 1
                                   AND DOC.C_RELATEDBRANCH = 84526
                                   AND DOC.C_Date >= '1392/05/22-00:00.00.000'
                                   AND DOC.C_ISSUER = AU.ID
                                   AND AU.C_PERSONNEL = PER.ID
                                   AND PER.C_UID = '4556')
                          MINUS
                          (SELECT DOC.*
                             FROM T_DOCUMENT DOC,
                                  T_DOCUMENTITEM DI,
                                  T_ACCOUNT AC,
                                  T_ACCOUNTTYPE ACT,
                                  T_TOPIC TP,
                                  T_AUTHORITY AU,
                                  T_PERSONNEL PER
                            WHERE     1 = 1
                                  AND DOC.C_RELATEDBRANCH = :1
                                  AND DOC.C_Date >= :2
                                  AND DOC.C_ISSUER = AU.ID
                                  AND AU.C_PERSONNEL = PER.ID
                                  AND PER.C_UID = :3
                                  AND DI.C_DOCUMENT = DOC.ID
                                  AND DI.C_ACCOUNT = AC.ID
                                  AND TP.C_CODE = :4
                                  AND AC.C_ACCOUNTTYPE = ACT.ID
                                  AND ACT.C_TOPIC = TP.ID)) tbl
                ORDER BY tbl.C_DATE) row_
         WHERE ROWNUM <= :5)
 WHERE rownum_ > :6;

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 3332389349
                           AND DOC.C_Date >= '1392/01/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/03/31-23:59.59.999')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);

SELECT COUNT (id)
  FROM (  SELECT DISTINCT (tbl.ID || tbl.c_date),
                          tbl.ID,
                          tbl.C_VERSION,
                          tbl.C_ACTIVE,
                          tbl.C_MANUALID,
                          tbl.C_SHEETNUMBER,
                          tbl.C_EFFECTIVEDATE,
                          tbl.C_COMMENT,
                          tbl.C_DATE,
                          tbl.C_EQUIVALENT,
                          tbl.C_DOCUMENTNUMBER,
                          tbl.C_ISSUANCEDATE,
                          tbl.C_TRANSACTIONNUMBER,
                          tbl.C_ENDOFYEARDOCUMENT,
                          tbl.C_SERIAL,
                          tbl.C_ENABLE,
                          tbl.C_BRANCHBANKBOOK,
                          tbl.C_EQUIVALENTDOCUMENT,
                          tbl.C_BANKBOOK,
                          tbl.C_CURRENCY,
                          tbl.C_STATUS,
                          tbl.C_RELATEDBRANCH,
                          tbl.C_ISSUER,
                          tbl.C_CONFIRMER,
                          tbl.C_SYSTEMOPERATION,
                          tbl.C_SUBSYSTEM,
                          tbl.C_BRANCH,
                          tbl.C_TEMPLATECODE
            FROM ( (SELECT DOC.*
                      FROM T_DOCUMENT DOC
                     WHERE     1 = 1
                           AND DOC.C_RELATEDBRANCH = 3332389349
                           AND DOC.C_Date >= '1392/04/01-00:00.00.000'
                           AND DOC.C_Date <= '1392/05/23-23:59.59.999')
                  MINUS
                  (SELECT DOC.*
                     FROM T_DOCUMENT DOC,
                          T_DOCUMENTITEM DI,
                          T_ACCOUNT AC,
                          T_ACCOUNTTYPE ACT,
                          T_TOPIC TP
                    WHERE     1 = 1
                          AND DOC.C_RELATEDBRANCH = :1
                          AND DOC.C_Date >= :2
                          AND DOC.C_Date <= :3
                          AND DI.C_DOCUMENT = DOC.ID
                          AND DI.C_ACCOUNT = AC.ID
                          AND TP.C_CODE = :4
                          AND AC.C_ACCOUNTTYPE = ACT.ID
                          AND ACT.C_TOPIC = TP.ID)) tbl
        ORDER BY tbl.C_DATE);
        

9--> ACCOUNT_STATUS  ---> do not create this  ( not used)     
(C_STATUS),NORMAL ,  NONUNIQUE  ,     CLUSTERING_FACTOR =623875,   DISTINCT_KEYS=5

---> NO SQL FOUND


10--> T_ACCOUNT_CIX1 ---> do not create this  ( not used)
(C_ACCOUNTNUMBER,C_OPPOSITEACCOUNT,ID),NORMAL ,   NONUNIQUE  ,   CLUSTERING_FACTOR=7116712 ,   DISTINCT_KEYS=7389631

---> NO SQL FOUND

11--> T_ACCOUNT_INDEX1 ---> create this local for queries of index ACCOUNT_CIX6
 (C_BRANCH,C_CURRENCY) NORMAL  ,  NONUNIQUE ,   CLUSTERING_FACTOR =3553997,   DISTINCT_KEYS = 842
---> NO SQL FOUND
      
12--> ACOOUNT_CIX2   ----> do not create this  ( not used)          
(C_ACCOUNTNUMBER,ID,C_OPPOSITEACCOUNT) ,  NORMAL ,   NONUNIQUE ,  CLUSTERING_FACTOR=6825933, DISTINCT_KEYS= 7058917
---> NO SQL FOUND

13--> SYS_C0012414 ---> create as primary key
(ID) , NORMAL  ,  UNIQUE  , CLUSTERING_FACTOR=5415794,    DISTINCT_KEYS=  7070674

UNIQUE SCAN :      
       
SELECT account0_.id AS id62_0_,
       account0_.c_version AS c2_62_0_,
       account0_.c_active AS c3_62_0_,
       account0_.c_debtorAmount AS c4_62_0_,
       account0_.c_manualId AS c5_62_0_,
       account0_.c_accountNumber AS c6_62_0_,
       account0_.c_creditorAmount AS c7_62_0_,
       account0_.c_creditorCirculationCount AS c8_62_0_,
       account0_.c_currencyAccount AS c9_62_0_,
       account0_.c_baseCurrencyDebtorAmount AS c10_62_0_,
       account0_.c_minAmount AS c11_62_0_,
       account0_.c_accountTitle AS c12_62_0_,
       account0_.c_amount AS c13_62_0_,
       account0_.c_debtorCirculationCount AS c14_62_0_,
       account0_.c_baseCurrencyAmount AS c15_62_0_,
       account0_.c_seCurrencyCreditorAmount AS c16_62_0_,
       account0_.c_maxAmount AS c17_62_0_,
       account0_.c_openingDate AS c18_62_0_,
       account0_.c_enable AS c19_62_0_,
       account0_.c_serial AS c20_62_0_,
       account0_.c_accountType AS c21_62_0_,
       account0_.c_oppositeAccount AS c22_62_0_,
       account0_.c_accountGroup AS c23_62_0_,
       account0_.c_currency AS c24_62_0_,
       account0_.c_branch AS c25_62_0_,
       account0_.c_status AS c26_62_0_
  FROM t_Account account0_
 WHERE account0_.id = :1;

UPDATE t_Account
   SET c_version = :1,
       c_active = :2,
       c_debtorAmount = :3,
       c_manualId = :4,
       c_accountNumber = :5,
       c_creditorAmount = :6,
       c_creditorCirculationCount = :7,
       c_currencyAccount = :8,
       c_baseCurrencyDebtorAmount = :9,
       c_minAmount = :10,
       c_accountTitle = :11,
       c_amount = :12,
       c_debtorCirculationCount = :13,
       c_baseCurrencyAmount = :14,
       c_seCurrencyCreditorAmount = :15,
       c_maxAmount = :16,
       c_openingDate = :17,
       c_enable = :18,
       c_serial = :19,
       c_accountType = :20,
       c_oppositeAccount = :21,
       c_accountGroup = :22,
       c_currency = :23,
       c_branch = :24,
       c_status = :25
 WHERE id = :26 AND c_version = :27;

SELECT account0_.id AS id63_0_,
       account0_.c_version AS c2_63_0_,
       account0_.c_active AS c3_63_0_,
       account0_.c_debtorAmount AS c4_63_0_,
       account0_.c_manualId AS c5_63_0_,
       account0_.c_accountNumber AS c6_63_0_,
       account0_.c_creditorAmount AS c7_63_0_,
       account0_.c_creditorCirculationCount AS c8_63_0_,
       account0_.c_currencyAccount AS c9_63_0_,
       account0_.c_baseCurrencyDebtorAmount AS c10_63_0_,
       account0_.c_minAmount AS c11_63_0_,
       account0_.c_accountTitle AS c12_63_0_,
       account0_.c_amount AS c13_63_0_,
       account0_.c_debtorCirculationCount AS c14_63_0_,
       account0_.c_baseCurrencyAmount AS c15_63_0_,
       account0_.c_seCurrencyCreditorAmount AS c16_63_0_,
       account0_.c_maxAmount AS c17_63_0_,
       account0_.c_openingDate AS c18_63_0_,
       account0_.c_enable AS c19_63_0_,
       account0_.c_serial AS c20_63_0_,
       account0_.c_accountType AS c21_63_0_,
       account0_.c_oppositeAccount AS c22_63_0_,
       account0_.c_accountGroup AS c23_63_0_,
       account0_.c_currency AS c24_63_0_,
       account0_.c_branch AS c25_63_0_,
       account0_.c_status AS c26_63_0_
  FROM t_Account account0_
 WHERE account0_.id = :1;

  SELECT dep.c_branch,
         aci.c_currency,
         SUM(CASE
                WHEN bdept.c_validityperiod IS NULL AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            kotahmodat,
         SUM(CASE
                WHEN     dept.c_isexternal <> 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            gharzolhasane,
         SUM(CASE
                WHEN     dept.c_isexternal = 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            nazdeBank,
         SUM(CASE
                WHEN     bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            jari,
         SUM(CASE
                WHEN bdept.c_validityperiod < 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            kotahvije,
         SUM(CASE
                WHEN bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            yeksale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 24 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            dosale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            sesale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 48 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            charsale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 60 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            panjsale
    FROM t_deposit dep
         INNER JOIN t_deposittype dept
            ON dept.id = dep.c_deposittype
         INNER JOIN t_basedeposittype bdept
            ON bdept.id = dept.id
         INNER JOIN t_accountinfo aci
            ON (   dep.id = aci.c_depositofblockedacc
                OR dep.id = aci.c_depositofintblockacc
                OR dep.id = aci.c_depositofmainacc)
         INNER JOIN t_account acc
            ON aci.c_accountid = acc.id
         INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
            ON BRANCHGROUPBRANCH.end2_id = dep.c_branch
   WHERE     dep.c_active = 1
         AND dept.c_isspecial IN (0, NULL)
         AND BRANCHGROUPBRANCH.end1_id = :1
         AND aci.c_currency <> 1087
GROUP BY dep.c_branch, aci.c_currency;

  SELECT dep.c_branch,
         aci.c_currency,
         SUM(CASE
                WHEN bdept.c_validityperiod IS NULL AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            kotahmodat,
         SUM(CASE
                WHEN     dept.c_isexternal <> 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            gharzolhasane,
         SUM(CASE
                WHEN     dept.c_isexternal = 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            nazdeBank,
         SUM(CASE
                WHEN     bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            jari,
         SUM(CASE
                WHEN bdept.c_validityperiod < 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            kotahvije,
         SUM(CASE
                WHEN bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            yeksale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 24 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            dosale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            sesale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 48 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            charsale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 60 AND bdept.c_hasinterest = 1
                THEN
                   acc.C_BASECURRENCYAMOUNT
             END)
            panjsale
    FROM t_deposit dep
         INNER JOIN t_deposittype dept
            ON dept.id = dep.c_deposittype
         INNER JOIN t_basedeposittype bdept
            ON bdept.id = dept.id
         INNER JOIN t_accountinfo aci
            ON (   dep.id = aci.c_depositofblockedacc
                OR dep.id = aci.c_depositofintblockacc
                OR dep.id = aci.c_depositofmainacc)
         INNER JOIN t_account acc
            ON aci.c_accountid = acc.id
         INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
            ON BRANCHGROUPBRANCH.end2_id = dep.c_branch
   WHERE     dep.c_active = 1
         AND dept.c_isspecial IN (0, NULL)
         AND BRANCHGROUPBRANCH.end1_id = :1
         AND aci.c_currency <> 1087
GROUP BY dep.c_branch, aci.c_currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.c_BASECURRENCYAMOUNT, 0) AMOUNT,
                          NVL (MAINAD.c_BASECURRENCYAMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.c_BASECURRENCYAMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_BASECURRENCYAMOUNT, 0) POAmount,
                          NVL (MAINDO.c_BASECURRENCYAMOUNT, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency <> 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.c_BASECURRENCYAMOUNT, 0) AMOUNT,
                          NVL (MAINAD.c_BASECURRENCYAMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.c_BASECURRENCYAMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_BASECURRENCYAMOUNT, 0) POAmount,
                          NVL (MAINDO.c_BASECURRENCYAMOUNT, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency <> 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.c_BASECURRENCYAMOUNT, 0) AMOUNT,
                          NVL (MAINAD.c_BASECURRENCYAMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.c_BASECURRENCYAMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_BASECURRENCYAMOUNT, 0) POAmount,
                          NVL (MAINDO.c_BASECURRENCYAMOUNT, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency <> 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.c_BASECURRENCYAMOUNT, 0) AMOUNT,
                          NVL (MAINAD.c_BASECURRENCYAMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.c_BASECURRENCYAMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_BASECURRENCYAMOUNT, 0) POAmount,
                          NVL (MAINDO.c_BASECURRENCYAMOUNT, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency <> 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.c_BASECURRENCYAMOUNT, 0) AMOUNT,
                          NVL (MAINAD.c_BASECURRENCYAMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.c_BASECURRENCYAMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_BASECURRENCYAMOUNT, 0) POAmount,
                          NVL (MAINDO.c_BASECURRENCYAMOUNT, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency <> 1087)
GROUP BY branchId, currency;

    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2)
FOR UPDATE OF account0_.id NOWAIT;

    SELECT account0_.id AS id62_,
           account0_.c_version AS c2_62_,
           account0_.c_active AS c3_62_,
           account0_.c_debtorAmount AS c4_62_,
           account0_.c_manualId AS c5_62_,
           account0_.c_accountNumber AS c6_62_,
           account0_.c_creditorAmount AS c7_62_,
           account0_.c_creditorCirculationCount AS c8_62_,
           account0_.c_currencyAccount AS c9_62_,
           account0_.c_baseCurrencyDebtorAmount AS c10_62_,
           account0_.c_minAmount AS c11_62_,
           account0_.c_accountTitle AS c12_62_,
           account0_.c_amount AS c13_62_,
           account0_.c_debtorCirculationCount AS c14_62_,
           account0_.c_baseCurrencyAmount AS c15_62_,
           account0_.c_seCurrencyCreditorAmount AS c16_62_,
           account0_.c_maxAmount AS c17_62_,
           account0_.c_openingDate AS c18_62_,
           account0_.c_enable AS c19_62_,
           account0_.c_serial AS c20_62_,
           account0_.c_accountType AS c21_62_,
           account0_.c_oppositeAccount AS c22_62_,
           account0_.c_accountGroup AS c23_62_,
           account0_.c_currency AS c24_62_,
           account0_.c_branch AS c25_62_,
           account0_.c_status AS c26_62_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2, :3)
FOR UPDATE OF account0_.id NOWAIT;

  SELECT dep.c_branch,
         aci.c_currency,
         SUM(CASE
                WHEN bdept.c_validityperiod IS NULL AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahmodat,
         SUM(CASE
                WHEN     dept.c_isexternal <> 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            gharzolhasane,
         SUM(CASE
                WHEN     dept.c_isexternal = 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            nazdeBank,
         SUM(CASE
                WHEN     bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 1
                THEN
                   acc.c_amount
             END)
            jari,
         SUM(CASE
                WHEN bdept.c_validityperiod < 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahvije,
         SUM(CASE
                WHEN bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            yeksale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 24 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            dosale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            sesale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 48 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            charsale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 60 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            panjsale
    FROM t_deposit dep
         INNER JOIN t_deposittype dept
            ON dept.id = dep.c_deposittype
         INNER JOIN t_basedeposittype bdept
            ON bdept.id = dept.id
         INNER JOIN t_accountinfo aci
            ON (   dep.id = aci.c_depositofblockedacc
                OR dep.id = aci.c_depositofintblockacc
                OR dep.id = aci.c_depositofmainacc)
         INNER JOIN t_account acc
            ON aci.c_accountid = acc.id
         INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
            ON BRANCHGROUPBRANCH.end2_id = dep.c_branch
   WHERE     dep.c_active = 1
         AND dept.c_isspecial IN (0, NULL)
         AND BRANCHGROUPBRANCH.end1_id = :1
         AND aci.c_currency = 1087
GROUP BY dep.c_branch, aci.c_currency;

  SELECT dep.c_branch,
         aci.c_currency,
         SUM(CASE
                WHEN bdept.c_validityperiod IS NULL AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahmodat,
         SUM(CASE
                WHEN     dept.c_isexternal <> 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            gharzolhasane,
         SUM(CASE
                WHEN     dept.c_isexternal = 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            nazdeBank,
         SUM(CASE
                WHEN     bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 1
                THEN
                   acc.c_amount
             END)
            jari,
         SUM(CASE
                WHEN bdept.c_validityperiod < 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahvije,
         SUM(CASE
                WHEN bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            yeksale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 24 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            dosale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            sesale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 48 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            charsale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 60 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            panjsale
    FROM t_deposit dep
         INNER JOIN t_deposittype dept
            ON dept.id = dep.c_deposittype
         INNER JOIN t_basedeposittype bdept
            ON bdept.id = dept.id
         INNER JOIN t_accountinfo aci
            ON (   dep.id = aci.c_depositofblockedacc
                OR dep.id = aci.c_depositofintblockacc
                OR dep.id = aci.c_depositofmainacc)
         INNER JOIN t_account acc
            ON aci.c_accountid = acc.id
         INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
            ON BRANCHGROUPBRANCH.end2_id = dep.c_branch
   WHERE     dep.c_active = 1
         AND dept.c_isspecial IN (0, NULL)
         AND BRANCHGROUPBRANCH.end1_id = :1
         AND aci.c_currency = 1087
GROUP BY dep.c_branch, aci.c_currency;

  SELECT dep.c_branch,
         aci.c_currency,
         SUM(CASE
                WHEN bdept.c_validityperiod IS NULL AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahmodat,
         SUM(CASE
                WHEN     dept.c_isexternal <> 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            gharzolhasane,
         SUM(CASE
                WHEN     dept.c_isexternal = 1
                     AND bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 0
                THEN
                   acc.c_amount
             END)
            nazdeBank,
         SUM(CASE
                WHEN     bdept.c_validityperiod IS NULL
                     AND bdept.c_hasinterest = 0
                     AND dept.c_hassupporter = 1
                THEN
                   acc.c_amount
             END)
            jari,
         SUM(CASE
                WHEN bdept.c_validityperiod < 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            kotahvije,
         SUM(CASE
                WHEN bdept.c_validityperiod = 12 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            yeksale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 24 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            dosale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 36 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            sesale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 48 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            charsale,
         SUM(CASE
                WHEN bdept.c_validityperiod = 60 AND bdept.c_hasinterest = 1
                THEN
                   acc.c_amount
             END)
            panjsale
    FROM t_deposit dep
         INNER JOIN t_deposittype dept
            ON dept.id = dep.c_deposittype
         INNER JOIN t_basedeposittype bdept
            ON bdept.id = dept.id
         INNER JOIN t_accountinfo aci
            ON (   dep.id = aci.c_depositofblockedacc
                OR dep.id = aci.c_depositofintblockacc
                OR dep.id = aci.c_depositofmainacc)
         INNER JOIN t_account acc
            ON aci.c_accountid = acc.id
         INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
            ON BRANCHGROUPBRANCH.end2_id = dep.c_branch
   WHERE     dep.c_active = 1
         AND dept.c_isspecial IN (0, NULL)
         AND BRANCHGROUPBRANCH.end1_id = :1
         AND aci.c_currency = 1087
GROUP BY dep.c_branch, aci.c_currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.C_AMOUNT, 0) AMOUNT,
                          NVL (MAINAD.C_AMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.C_AMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_amount, 0) POAmount,
                          NVL (MAINDO.c_amount, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency = 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.C_AMOUNT, 0) AMOUNT,
                          NVL (MAINAD.C_AMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.C_AMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_amount, 0) POAmount,
                          NVL (MAINDO.c_amount, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency = 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.C_AMOUNT, 0) AMOUNT,
                          NVL (MAINAD.C_AMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.C_AMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_amount, 0) POAmount,
                          NVL (MAINDO.c_amount, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency = 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.C_AMOUNT, 0) AMOUNT,
                          NVL (MAINAD.C_AMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.C_AMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_amount, 0) POAmount,
                          NVL (MAINDO.c_amount, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency = 1087)
GROUP BY branchId, currency;

  SELECT BRANCHID,
         CURRENCY,
         SUM (AMOUNT),
         SUM (ADAMOUNT),
         SUM (OVAMOUNT),
         SUM (POAmount),
         SUM (DOAmount)
    FROM (SELECT DISTINCT LOANFILE.id AS loanId,
                          LOANTYPEECOSECCURRUNECY.c_currency AS currency,
                          LOANFILE.c_branch AS branchId,
                          NVL (MAINA.C_AMOUNT, 0) AMOUNT,
                          NVL (MAINAD.C_AMOUNT, 0) ADAMOUNT,
                          NVL (MAINOV.C_AMOUNT, 0) OVAMOUNT,
                          NVL (MAINPO.c_amount, 0) POAmount,
                          NVL (MAINDO.c_amount, 0) DOAmount
            FROM t_loanfile LOANFILE
                 INNER JOIN t_com_fanap_domain_loan_ba LOANTYPEECOSECCURRUNECY
                    ON LOANFILE.c_conomicalsectioncurrency =
                          LOANTYPEECOSECCURRUNECY.id
                 INNER JOIN mm_branchgroup_branch BRANCHGROUPBRANCH
                    ON BRANCHGROUPBRANCH.end2_id = LOANFILE.c_branch
                 INNER JOIN t_branchgroup BRANCHGROUP
                    ON BRANCHGROUP.id = BRANCHGROUPBRANCH.end1_id
                 INNER JOIN t_loanaccountinfo mainI
                    ON mainI.c_loanfilefield_ = LOANFILE.id
                 INNER JOIN t_loantopic mainT
                    ON mainI.c_loantopic = mainT.id
                 INNER JOIN t_relationtype mainR
                    ON mainR.id = mainT.c_relationType
                 INNER JOIN t_basicinfo mainB
                    ON mainB.id = mainR.id
                 LEFT OUTER JOIN T_ACCOUNT MAINA
                    ON (MAINI.C_ACCOUNTID = MAINA.id AND MAINB.C_CODE = '1')
                 LEFT OUTER JOIN T_ACCOUNT MAINAD
                    ON (MAINI.C_ACCOUNTID = MAINAD.id AND MAINB.C_CODE = '8')
                 LEFT OUTER JOIN T_ACCOUNT MAINOV
                    ON (MAINI.C_ACCOUNTID = MAINOV.id AND MAINB.C_CODE = '5')
                 LEFT OUTER JOIN T_ACCOUNT MAINPO
                    ON (MAINI.C_ACCOUNTID = MAINPO.id AND MAINB.C_CODE = '6')
                 LEFT OUTER JOIN T_ACCOUNT MAINDO
                    ON (MAINI.C_ACCOUNTID = MAINDO.id AND MAINB.C_CODE = '7')
           WHERE BRANCHGROUPBRANCH.end1_id = :1
                 AND LOANTYPEECOSECCURRUNECY.c_currency = 1087)
GROUP BY branchId, currency;

    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2, :3)
FOR UPDATE OF account0_.id NOWAIT;

    SELECT account0_.id AS id63_,
           account0_.c_version AS c2_63_,
           account0_.c_active AS c3_63_,
           account0_.c_debtorAmount AS c4_63_,
           account0_.c_manualId AS c5_63_,
           account0_.c_accountNumber AS c6_63_,
           account0_.c_creditorAmount AS c7_63_,
           account0_.c_creditorCirculationCount AS c8_63_,
           account0_.c_currencyAccount AS c9_63_,
           account0_.c_baseCurrencyDebtorAmount AS c10_63_,
           account0_.c_minAmount AS c11_63_,
           account0_.c_accountTitle AS c12_63_,
           account0_.c_amount AS c13_63_,
           account0_.c_debtorCirculationCount AS c14_63_,
           account0_.c_baseCurrencyAmount AS c15_63_,
           account0_.c_seCurrencyCreditorAmount AS c16_63_,
           account0_.c_maxAmount AS c17_63_,
           account0_.c_openingDate AS c18_63_,
           account0_.c_enable AS c19_63_,
           account0_.c_serial AS c20_63_,
           account0_.c_accountType AS c21_63_,
           account0_.c_oppositeAccount AS c22_63_,
           account0_.c_accountGroup AS c23_63_,
           account0_.c_currency AS c24_63_,
           account0_.c_branch AS c25_63_,
           account0_.c_status AS c26_63_
      FROM t_Account account0_
     WHERE account0_.id IN (:1, :2)
FOR UPDATE OF account0_.id NOWAIT;


14--> SYS_C0012415   ---> create this uniqe hash by c_accountnumber
(C_ACCOUNTNUMBER),  NORMAL   , UNIQUE,  CLUSTERING_FACTOR = 7022258   , DISTINCT_KEYS=  7283650

UNIQUE SCAN :    

TO_CHAR(SUBSTR(T1.SQL_TEXT,1,8000))||';'/* Formatted on 14-Aug-13 3:23:23 PM (QP5 v5.136.908.31019) */
SELECT this_.id AS id62_0_,
       this_.c_version AS c2_62_0_,
       this_.c_active AS c3_62_0_,
       this_.c_debtorAmount AS c4_62_0_,
       this_.c_manualId AS c5_62_0_,
       this_.c_accountNumber AS c6_62_0_,
       this_.c_creditorAmount AS c7_62_0_,
       this_.c_creditorCirculationCount AS c8_62_0_,
       this_.c_currencyAccount AS c9_62_0_,
       this_.c_baseCurrencyDebtorAmount AS c10_62_0_,
       this_.c_minAmount AS c11_62_0_,
       this_.c_accountTitle AS c12_62_0_,
       this_.c_amount AS c13_62_0_,
       this_.c_debtorCirculationCount AS c14_62_0_,
       this_.c_baseCurrencyAmount AS c15_62_0_,
       this_.c_seCurrencyCreditorAmount AS c16_62_0_,
       this_.c_maxAmount AS c17_62_0_,
       this_.c_openingDate AS c18_62_0_,
       this_.c_enable AS c19_62_0_,
       this_.c_serial AS c20_62_0_,
       this_.c_accountType AS c21_62_0_,
       this_.c_oppositeAccount AS c22_62_0_,
       this_.c_accountGroup AS c23_62_0_,
       this_.c_currency AS c24_62_0_,
       this_.c_branch AS c25_62_0_,
       this_.c_status AS c26_62_0_
  FROM t_Account this_
 WHERE this_.c_accountNumber = :1;

SELECT this_.id AS id63_0_,
       this_.c_version AS c2_63_0_,
       this_.c_active AS c3_63_0_,
       this_.c_debtorAmount AS c4_63_0_,
       this_.c_manualId AS c5_63_0_,
       this_.c_accountNumber AS c6_63_0_,
       this_.c_creditorAmount AS c7_63_0_,
       this_.c_creditorCirculationCount AS c8_63_0_,
       this_.c_currencyAccount AS c9_63_0_,
       this_.c_baseCurrencyDebtorAmount AS c10_63_0_,
       this_.c_minAmount AS c11_63_0_,
       this_.c_accountTitle AS c12_63_0_,
       this_.c_amount AS c13_63_0_,
       this_.c_debtorCirculationCount AS c14_63_0_,
       this_.c_baseCurrencyAmount AS c15_63_0_,
       this_.c_seCurrencyCreditorAmount AS c16_63_0_,
       this_.c_maxAmount AS c17_63_0_,
       this_.c_openingDate AS c18_63_0_,
       this_.c_enable AS c19_63_0_,
       this_.c_serial AS c20_63_0_,
       this_.c_accountType AS c21_63_0_,
       this_.c_oppositeAccount AS c22_63_0_,
       this_.c_accountGroup AS c23_63_0_,
       this_.c_currency AS c24_63_0_,
       this_.c_branch AS c25_63_0_,
       this_.c_status AS c26_63_0_
  FROM t_Account this_
 WHERE this_.c_accountNumber = :1;

15-->ACCOUNT_ACCOUNTGROUP ---> CREATE THIS HASH BY  C_ACCOUNTGROUP
(C_ACCOUNTGROUP), NORMAL  ,  NONUNIQUE ,CLUSTERING_FACTOR=4408394, DISTINCT_KEYS= 4427264

RANGE SCAN :
SELECT relatedacc0_.c_accountGroup AS c23_1_,
       relatedacc0_.id AS id1_,
       relatedacc0_.id AS id62_0_,
       relatedacc0_.c_version AS c2_62_0_,
       relatedacc0_.c_active AS c3_62_0_,
       relatedacc0_.c_debtorAmount AS c4_62_0_,
       relatedacc0_.c_manualId AS c5_62_0_,
       relatedacc0_.c_accountNumber AS c6_62_0_,
       relatedacc0_.c_creditorAmount AS c7_62_0_,
       relatedacc0_.c_creditorCirculationCount AS c8_62_0_,
       relatedacc0_.c_currencyAccount AS c9_62_0_,
       relatedacc0_.c_baseCurrencyDebtorAmount AS c10_62_0_,
       relatedacc0_.c_minAmount AS c11_62_0_,
       relatedacc0_.c_accountTitle AS c12_62_0_,
       relatedacc0_.c_amount AS c13_62_0_,
       relatedacc0_.c_debtorCirculationCount AS c14_62_0_,
       relatedacc0_.c_baseCurrencyAmount AS c15_62_0_,
       relatedacc0_.c_seCurrencyCreditorAmount AS c16_62_0_,
       relatedacc0_.c_maxAmount AS c17_62_0_,
       relatedacc0_.c_openingDate AS c18_62_0_,
       relatedacc0_.c_enable AS c19_62_0_,
       relatedacc0_.c_serial AS c20_62_0_,
       relatedacc0_.c_accountType AS c21_62_0_,
       relatedacc0_.c_oppositeAccount AS c22_62_0_,
       relatedacc0_.c_accountGroup AS c23_62_0_,
       relatedacc0_.c_currency AS c24_62_0_,
       relatedacc0_.c_branch AS c25_62_0_,
       relatedacc0_.c_status AS c26_62_0_
  FROM t_Account relatedacc0_
 WHERE relatedacc0_.c_accountGroup = :1;



16-->ACCOUNT_ACCOUNTTITLE ---> CRAETE THIS BY HAHS C_ACCOUNTTITLE (C_ACCOUNTTITLE,C_ACCOUNTTYPE)
(C_ACCOUNTTITLE) , NORMAL  ,  NONUNIQUE  , CLUSTERING_FACTOR =  7026177  ,  DISTINCT_KEYS=5790208

RANGE SCAN :     
TO_CHAR(SUBSTR(T1.SQL_TEXT,1,8000))||';'
/* Formatted on 14-Aug-13 3:46:36 PM (QP5 v5.136.908.31019) */
SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic6_
 WHERE account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic6_.id
       AND (account0_.c_accountTitle LIKE
               'مطالبات سررسيد گذشته%')
       AND account0_.c_amount >= 1000000000
       AND (accounttyp1_.c_branch IN (SELECT branch4_.id
                                        FROM t_BranchGroup branchgrou2_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches3_
                                                ON branchgrou2_.id =
                                                      branches3_.end1_id
                                             LEFT OUTER JOIN t_Branch branch4_
                                                ON branches3_.end2_id =
                                                      branch4_.id
                                             LEFT OUTER JOIN t_BaseBranch branch4_1_
                                                ON branch4_.id =
                                                      branch4_1_.id
                                       WHERE branchgrou2_.id = 384613))
       AND topic6_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic6_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic6_.id
       AND (account0_.c_accountTitle LIKE 'صندوق%')
       AND (accounttyp1_.c_branch IN (SELECT branch4_.id
                                        FROM t_BranchGroup branchgrou2_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches3_
                                                ON branchgrou2_.id =
                                                      branches3_.end1_id
                                             LEFT OUTER JOIN t_Branch branch4_
                                                ON branches3_.end2_id =
                                                      branch4_.id
                                             LEFT OUTER JOIN t_BaseBranch branch4_1_
                                                ON branch4_.id =
                                                      branch4_1_.id
                                       WHERE branchgrou2_.id = 384809))
       AND topic6_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic6_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic6_.id
       AND (account0_.c_accountTitle LIKE 'بستانکاران موقت%')
       AND (accounttyp1_.c_branch IN (SELECT branch4_.id
                                        FROM t_BranchGroup branchgrou2_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches3_
                                                ON branchgrou2_.id =
                                                      branches3_.end1_id
                                             LEFT OUTER JOIN t_Branch branch4_
                                                ON branches3_.end2_id =
                                                      branch4_.id
                                             LEFT OUTER JOIN t_BaseBranch branch4_1_
                                                ON branch4_.id =
                                                      branch4_1_.id
                                       WHERE branchgrou2_.id = 384812))
       AND topic6_.c_bankBook = 1105;        




17-->ACCOUNT_ACCOUNTTYPE CRAETE THIS HASH BY (C_ACCOUNTTYPE)
(C_ACCOUNTTYPE), NORMAL   , NONUNIQUE, CLUSTERING_FACTOR = 5398052 ,   DISTINCT_KEYS=213696  

RANGE SCAN:
/* Formatted on 14-Aug-13 3:51:13 PM (QP5 v5.136.908.31019) */
SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND (topic2_.c_code IN
                  (:1,
                   :2,
                   :3,
                   :4,
                   :5,
                   :6,
                   :7,
                   :8,
                   :9,
                   :10,
                   :11,
                   :12,
                   :13,
                   :14))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384625))
       AND topic2_.c_bankBook = 1105    


/* Formatted on 14-Aug-13 3:51:21 PM (QP5 v5.136.908.31019) */
SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 1
       AND (topic2_.c_code IN
                  (:1,
                   :2,
                   :3,
                   :4,
                   :5,
                   :6,
                   :7,
                   :8,
                   :9,
                   :10,
                   :11,
                   :12,
                   :13,
                   :14))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384628))
       AND topic2_.c_bankBook = 1105


FAST FULL SCAN:

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND topic2_.c_bankBook = 1105



18-->ACCOUNT_AMOUNT ---> CREATE NEW COMPOSITE INDEX (C_AMOUNT,C_ACCOUNTTYPE,CID,STATUS,CURRENCY) HASH BY C_AMOUNT
(C_AMOUNT),NORMAL, NONUNIQUE ,   CLUSTERING_FACTOR=4337186,    DISTINCT_KEYS= 1638272

RANGE SCAN :       

/* Formatted on 14-Aug-13 4:27:38 PM (QP5 v5.136.908.31019) */
SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 0
       AND account0_.c_amount <= 0
       AND account0_.c_status = 2
       AND (topic2_.c_code IN
                  (:1,
                   :2,
                   :3,
                   :4,
                   :5,
                   :6,
                   :7,
                   :8,
                   :9,
                   :10,
                   :11,
                   :12,
                   :13,
                   :14,
                   :15,
                   :16,
                   :17,
                   :18,
                   :19,
                   :20,
                   :21,
                   :22,
                   :23,
                   :24,
                   :25,
                   :26,
                   :27,
                   :28,
                   :29,
                   :30,
                   :31,
                   :32,
                   :33,
                   :34,
                   :35,
                   :36,
                   :37,
                   :38,
                   :39,
                   :40,
                   :41,
                   :42,
                   :43,
                   :44,
                   :45,
                   :46,
                   :47,
                   :48,
                   :49,
                   :50,
                   :51,
                   :52,
                   :53,
                   :54,
                   :55,
                   :56,
                   :57,
                   :58,
                   :59,
                   :60,
                   :61,
                   :62,
                   :63,
                   :64,
                   :65,
                   :66,
                   :67,
                   :68,
                   :69,
                   :70,
                   :71,
                   :72,
                   :73,
                   :74,
                   :75,
                   :76,
                   :77,
                   :78,
                   :79,
                   :80,
                   :81,
                   :82,
                   :83,
                   :84,
                   :85,
                   :86,
                   :87,
                   :88,
                   :89,
                   :90,
                   :91,
                   :92,
                   :93,
                   :94,
                   :95,
                   :96,
                   :97,
                   :98,
                   :99,
                   :100,
                   :101,
                   :102,
                   :103,
                   :104,
                   :105,
                   :106,
                   :107,
                   :108,
                   :109,
                   :110,
                   :111,
                   :112,
                   :113,
                   :114,
                   :115,
                   :116,
                   :117,
                   :118,
                   :119,
                   :120,
                   :121,
                   :122,
                   :123,
                   :124,
                   :125,
                   :126,
                   :127,
                   :128,
                   :129,
                   :130,
                   :131,
                   :132,
                   :133,
                   :134,
                   :135,
                   :136,
                   :137,
                   :138,
                   :139))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384622))
       AND account0_.c_currency = 1087
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 1
       AND account0_.c_amount <= 99999999
       AND account0_.c_status = 2
       AND (topic2_.c_code IN (:1, :2))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384663))
       AND account0_.c_currency = 1087
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 106567
       AND account0_.c_amount <= 99999999
       AND (topic2_.c_code IN (:1, :2))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384663))
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 1
       AND account0_.c_amount <= 11111111
       AND (topic2_.c_code IN (:1, :2, :3, :4))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384835))
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic6_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic6_.id
       AND account0_.c_amount >= 1
       AND account0_.c_amount <= 1000000000
       AND (accounttyp1_.c_branch IN (SELECT branch4_.id
                                        FROM t_BranchGroup branchgrou2_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches3_
                                                ON branchgrou2_.id =
                                                      branches3_.end1_id
                                             LEFT OUTER JOIN t_Branch branch4_
                                                ON branches3_.end2_id =
                                                      branch4_.id
                                             LEFT OUTER JOIN t_BaseBranch branch4_1_
                                                ON branch4_.id =
                                                      branch4_1_.id
                                       WHERE branchgrou2_.id = 384649))
       AND account0_.c_currency = 1087
       AND topic6_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 1
       AND account0_.c_amount <= 111111
       AND (topic2_.c_code IN (:1, :2))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384835))
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount <= 30
       AND (topic2_.c_code IN (:1, :2, :3, :4))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 3332267985))
       AND account0_.c_currency = 1087
       AND topic2_.c_bankBook = 1105;

SELECT COUNT (account0_.id) AS col_0_0_
  FROM t_Account account0_, t_AccountType accounttyp1_, t_Topic topic2_
 WHERE     account0_.c_accountType = accounttyp1_.id
       AND accounttyp1_.c_topic = topic2_.id
       AND account0_.c_amount >= 50
       AND account0_.c_amount <= 3000
       AND (topic2_.c_code IN
                  (:1,
                   :2,
                   :3,
                   :4,
                   :5,
                   :6,
                   :7,
                   :8,
                   :9,
                   :10,
                   :11,
                   :12,
                   :13,
                   :14,
                   :15,
                   :16,
                   :17,
                   :18,
                   :19,
                   :20,
                   :21,
                   :22,
                   :23,
                   :24,
                   :25,
                   :26,
                   :27,
                   :28,
                   :29,
                   :30,
                   :31,
                   :32,
                   :33,
                   :34,
                   :35,
                   :36,
                   :37,
                   :38,
                   :39,
                   :40,
                   :41,
                   :42,
                   :43,
                   :44,
                   :45,
                   :46,
                   :47,
                   :48,
                   :49,
                   :50,
                   :51,
                   :52,
                   :53,
                   :54,
                   :55,
                   :56,
                   :57,
                   :58,
                   :59,
                   :60,
                   :61,
                   :62,
                   :63,
                   :64,
                   :65,
                   :66,
                   :67,
                   :68,
                   :69,
                   :70,
                   :71,
                   :72,
                   :73,
                   :74,
                   :75,
                   :76,
                   :77,
                   :78,
                   :79,
                   :80,
                   :81,
                   :82,
                   :83,
                   :84,
                   :85,
                   :86,
                   :87,
                   :88,
                   :89,
                   :90,
                   :91,
                   :92,
                   :93,
                   :94,
                   :95,
                   :96,
                   :97,
                   :98,
                   :99,
                   :100,
                   :101,
                   :102,
                   :103,
                   :104,
                   :105,
                   :106,
                   :107,
                   :108,
                   :109,
                   :110,
                   :111,
                   :112,
                   :113,
                   :114,
                   :115,
                   :116,
                   :117,
                   :118,
                   :119,
                   :120,
                   :121,
                   :122,
                   :123,
                   :124,
                   :125,
                   :126,
                   :127,
                   :128,
                   :129,
                   :130,
                   :131,
                   :132,
                   :133,
                   :134,
                   :135,
                   :136,
                   :137,
                   :138,
                   :139,
                   :140,
                   :141,
                   :142,
                   :143,
                   :144,
                   :145,
                   :146,
                   :147,
                   :148,
                   :149,
                   :150,
                   :151,
                   :152,
                   :153,
                   :154,
                   :155,
                   :156,
                   :157,
                   :158,
                   :159,
                   :160,
                   :161,
                   :162,
                   :163,
                   :164,
                   :165,
                   :166,
                   :167,
                   :168,
                   :169,
                   :170,
                   :171,
                   :172,
                   :173,
                   :174,
                   :175,
                   :176,
                   :177,
                   :178,
                   :179,
                   :180,
                   :181,
                   :182,
                   :183,
                   :184,
                   :185,
                   :186,
                   :187,
                   :188,
                   :189,
                   :190,
                   :191,
                   :192,
                   :193,
                   :194,
                   :195,
                   :196,
                   :197,
                   :198,
                   :199,
                   :200,
                   :201,
                   :202,
                   :203,
                   :204,
                   :205,
                   :206,
                   :207,
                   :208,
                   :209,
                   :210,
                   :211,
                   :212,
                   :213,
                   :214,
                   :215,
                   :216,
                   :217,
                   :218,
                   :219,
                   :220,
                   :221,
                   :222,
                   :223,
                   :224,
                   :225,
                   :226,
                   :227,
                   :228,
                   :229,
                   :230,
                   :231,
                   :232,
                   :233,
                   :234,
                   :235,
                   :236,
                   :237,
                   :238,
                   :239,
                   :240,
                   :241,
                   :242,
                   :243,
                   :244,
                   :245))
       AND (accounttyp1_.c_branch IN (SELECT branch6_.id
                                        FROM t_BranchGroup branchgrou4_
                                             LEFT OUTER JOIN mm_BranchGroup_Branch branches5_
                                                ON branchgrou4_.id =
                                                      branches5_.end1_id
                                             LEFT OUTER JOIN t_Branch branch6_
                                                ON branches5_.end2_id =
                                                      branch6_.id
                                             LEFT OUTER JOIN t_BaseBranch branch6_1_
                                                ON branch6_.id =
                                                      branch6_1_.id
                                       WHERE branchgrou4_.id = 384764))
       AND topic2_.c_bankBook = 1105;



19-->ACCOUNT_BRANCH --->DO NOT CREATE THIS INDEX( NOT USED and fk is disable)
(C_BRANCH)NORMAL ,  NONUNIQUE,   CLUSTERING_FACTOR=4337186,   DISTINCT_KEYS= 1638272

---> NO SQL FOUND       

20-->ACCOUNT_CIX2 ----> DO NOT CREATE THIS INDEX (THE FOLLOWING QUERY USE OF INDEX(C_ACCOUNTNUMBER) )
(C_ACCOUNTNUMBER,ID) , NORMAL,    NONUNIQUE , CLUSTERING_FACTOR =4337186,   DISTINCT_KEYS =1638272 

RANGE SCAN:   
select max(c_serial) from t_account where c_accountnumber like :1   ;        

21-->ACCOUNT_CIX3  --->DO NOT CREATE THIS INDEX( NOT USED)
(C_OPPOSITEACCOUNT,ID) ,NORMAL ,   NONUNIQUE , CLUSTERING_FACTOR=  5405835 ,    DISTINCT_KEYS =6993915
---> NO SQL FOUND

        
22-->ACCOUNT_CIX5   DO NOT CREATE THIS INDEX (THE FOLLOWING QUERY USE OF PK )
(ID,C_BRANCH) ,NORMAL  ,  NONUNIQUE , CLUSTERING_FACTOR= 5644208,    DISTINCT_KEYS =7278330

RANGE SCAN :
SELECT c_branch FROM t_account WHERE id = :1   ;
       
23-->ACCOUNT_CURRENCY--->DO NOT CREATE THIS INDEX( NOT USED and fk is disable)
(C_CURRENCY), NORMAL  ,  NONUNIQUE   , CLUSTERING_FACTOR=349724   , DISTINCT_KEYS=36
---> NO SQL FOUND


24-->ACCOUNT_CURRENCYACCOUNT   --->DO NOT CREATE THIS INDEX( NOT USED) 
(C_CURRENCYACCOUNT), NORMAL,  NONUNIQUE,   CLUSTERING_FACTOR=384156,    DISTINCT_KEYS=2
---> NO SQL FOUND
        

25-->ACCOUNT_OPPOSITEACCOUNT  --->DO NOT CREATE THIS INDEX( NOT USED)
(C_OPPOSITEACCOUNT) , NORMAL  ,  NONUNIQUE  ,  CLUSTERING_FACTOR=  52401,    DISTINCT_KEYS =109590
  
---> NO SQL FOUND


26-->ACCOUNT_SERIAL  ---> CREATE THIS INDEX BY HASH(C_SERIAL)  (C_SERIAL,C_ACCOUNTTYPE)
(C_SERIAL) ,NORMAL ,   NONUNIQUE,    CLUSTERING_FACTOR=   5933616    DISTINCT_KEYS = 24250


SELECT this_.id AS id63_1_,
       this_.c_version AS c2_63_1_,
       this_.c_active AS c3_63_1_,
       this_.c_debtorAmount AS c4_63_1_,
       this_.c_manualId AS c5_63_1_,
       this_.c_accountNumber AS c6_63_1_,
       this_.c_creditorAmount AS c7_63_1_,
       this_.c_creditorCirculationCount AS c8_63_1_,
       this_.c_currencyAccount AS c9_63_1_,
       this_.c_baseCurrencyDebtorAmount AS c10_63_1_,
       this_.c_minAmount AS c11_63_1_,
       this_.c_accountTitle AS c12_63_1_,
       this_.c_amount AS c13_63_1_,
       this_.c_debtorCirculationCount AS c14_63_1_,
       this_.c_baseCurrencyAmount AS c15_63_1_,
       this_.c_seCurrencyCreditorAmount AS c16_63_1_,
       this_.c_maxAmount AS c17_63_1_,
       this_.c_openingDate AS c18_63_1_,
       this_.c_enable AS c19_63_1_,
       this_.c_serial AS c20_63_1_,
       this_.c_accountType AS c21_63_1_,
       this_.c_oppositeAccount AS c22_63_1_,
       this_.c_accountGroup AS c23_63_1_,
       this_.c_currency AS c24_63_1_,
       this_.c_branch AS c25_63_1_,
       this_.c_status AS c26_63_1_,
       acc1_.id AS id69_0_,
       acc1_.c_version AS c2_69_0_,
       acc1_.c_active AS c3_69_0_,
       acc1_.c_manualId AS c4_69_0_,
       acc1_.c_totalDebtorAmount AS c5_69_0_,
       acc1_.c_creditorCirculationCount AS c6_69_0_,
       acc1_.c_atestAutoGeneratedNumber AS c7_69_0_,
       acc1_.c_eqTtDebtAm AS c8_69_0_,
       acc1_.c_totalCreditorAmount AS c9_69_0_,
       acc1_.c_totalAmount AS c10_69_0_,
       acc1_.c_code AS c11_69_0_,
       acc1_.c_eqTtAm AS c12_69_0_,
       acc1_.c_debtorCirculationCount AS c13_69_0_,
       acc1_.c_eqDebtCirCn AS c14_69_0_,
       acc1_.c_eqCredCirCn AS c15_69_0_,
       acc1_.c_eqTtCredAm AS c16_69_0_,
       acc1_.c_enable AS c17_69_0_,
       acc1_.c_oppositeAccountType AS c18_69_0_,
       acc1_.c_topic AS c19_69_0_,
       acc1_.c_currency AS c20_69_0_,
       acc1_.c_branch AS c21_69_0_
  FROM t_Account_it this_ INNER JOIN t_AccountType acc1_
          ON this_.c_accountType = acc1_.id
 WHERE acc1_.id = :1 AND this_.c_serial = :2
          












