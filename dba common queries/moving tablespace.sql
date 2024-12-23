CREATE TABLESPACE new_tablespace
DATAFILE '/path_to_your_new_datafile/new_datafile.dbf' SIZE 100M;


ALTER TABLE schema_name.table_name MOVE TABLESPACE new_tablespace;
ALTER INDEX index_name REBUILD TABLESPACE new_tablespace;
DROP TABLESPACE old_tablespace INCLUDING CONTENTS AND DATAFILES;
