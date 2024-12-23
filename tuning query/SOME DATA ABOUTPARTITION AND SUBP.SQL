-- subpartitions COUNT
select T.TABLE_NAME ,t.partition_name,count(1) from dba_tab_subpartitions t
where T.TABLE_NAME in('....','....','...' ,'...','...','...' ,'...','...','..','..'   )
and t.partition_name like '%1400_04_01'
group by T.TABLE_NAME ,t.partition_name
order by T.TABLE_NAME ,t.partition_name desc
;

select
--row_number() over(partition by T.TABLE_NAME order by t.high_value desc ),

 T.* from dba_tab_partitions t
where T.TABLE_NAME in('..','..','..' ,'T_GENERALLOG','..','..','...'   )
order by T.TABLE_NAME 
;

-- partitioning type COUNT
select  partitioning_type,count(*)  from DBA_PART_TABLES where owner in ('..','..')
group by  partitioning_type
;
-- partitioning type RANGE
select table_name,owner from DBA_PART_TABLES where owner in ('FCBN','ACHUSER') and partitioning_type='RANGE'
and table_name not  in('...','..','..' ,'..','..','..' ,'..','..','...','...'   
,'...','...','...' ,'..','..','..','..'   )
;
-- partitioning type HASH
select table_name,owner from DBA_PART_TABLES where owner in ('..','...') and partitioning_type='HASH'
and table_name not  in('...','...','...' ,'...','...','...' ,'..','..','..','..'   
,'...','...','..' ,'..','..','..','..'   )
;
-- partitioning type LIST
select table_name,owner from DBA_PART_TABLES where owner in ('..','..') and partitioning_type='LIST'