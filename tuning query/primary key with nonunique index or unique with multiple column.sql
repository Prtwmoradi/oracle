(
select index_name,table_name,index_type,uniqueness from DBA_INDEXES where index_name in ( 
select index_name from dba_constraints   where owner = 'FCB' and constraint_type ='P'  
) and uniqueness = 'NONUNIQUE'  and owner ='FCB' and 
)
union all
(
select index_name,table_name,index_type,uniqueness from DBA_INDEXES where index_name in ( 
select index_name from dba_constraints  where owner = 'FCB' and constraint_type ='P'  
) and uniqueness = 'UNIQUE'  and owner ='FCB' and table_name not like 'MM_%' and index_name in (select index_name from DBA_IND_COLUMNS where table_owner='FCB' and column_position=2 )
);
