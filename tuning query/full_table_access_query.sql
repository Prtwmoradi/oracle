select aa.full_sqltext,bb.object_name from v$sqlarea aa , bb.v$sql_plan
where aa.sql_id=bb.sql_id
and bb.options='FULL' and aa.object_operation='TABLE ACCESS'
and object_owner=:schema_name
orderby bb.timestamp desc