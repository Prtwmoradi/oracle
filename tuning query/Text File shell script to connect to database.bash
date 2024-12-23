#!/bin/bash

sqlplus -s sys as sysdba < startup
spool on;
spool ashu;
connect scott/tiger
select * from emp;
spool off;
exit;
EOF
cat ashu