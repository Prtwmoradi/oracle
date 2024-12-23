first :
--------
select address, hash_value from v$sqlarea where sql_id like '8z7x4y88kzrdq';


second :
---------
exec sys.dbms_shared_pool.purge('00000000A9F34F98, 1682024353','C');




explanation  of dbms_shared_pool.purge : 
-----------------------------------------
first parameter = cursor address 

second parameter = sql hash value

third  parameter = flag
P for package/procedure/function
T for type
R for trigger
Q for sequence
ANYTHING ELSE for others like C OR S OR Z OR ...

forth parameter = cursor location
by default = 1  witch means all the cursors of sql_id in sql area