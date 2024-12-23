
SELECT * FROM DBA_AUDIT_POLICIES;


BEGIN
   DBMS_FGA.ADD_POLICY (object_schema     => 'FCB',
                        object_name       => 'T_BLOBCONTAINER',
                        policy_name       => 'AUDIT_BLOBCONTAINER',
                        enable            => TRUE,
                        statement_types   => 'UPDATE,  DELETE');
END;


BEGIN
   DBMS_FGA.ADD_POLICY (object_schema     => 'FCB',
                        object_name       => 'T_BILL',
                        policy_name       => 'AUDIT_BILL',
                        enable            => TRUE,
                        statement_types   => 'UPDATE,  DELETE');
END;





BEGIN
   DBMS_FGA.DROP_POLICY (object_schema   => 'FCB',
                         object_name     => 'T_BLOBCONTAINER',
                         policy_name     => 'AUDIT_BLOBCONTAINER');
END;



BEGIN
   DBMS_FGA.DROP_POLICY (object_schema   => 'FCB',
                         object_name     => 'T_BILL',
                         policy_name     => 'AUDIT_BILL');
END;


SELECT *
  FROM DBA_AUDIT_TRAIL
 WHERE TIMESTAMP > TO_TIMESTAMP ('26-DEC-12 12:00:00.308991 PM')
       AND OBJ_NAME IN ('T_BILL', 'T_BLOBCONTAINER');


SELECT *
  FROM DBA_COMMON_AUDIT_TRAIL
 WHERE EXTENDED_TIMESTAMP > TO_TIMESTAMP ('26-DEC-12 12:00:00.308991 PM')
       AND OBJECT_NAME IN ('T_BILL', 'T_BLOBCONTAINER');
       
SELECT *
  FROM DBA_COMMON_AUDIT_TRAIL
 WHERE  OBJECT_NAME = 'T_BLOBCONTAINER' and     SQL_BIND like '%5446739942%'       
       
       
       