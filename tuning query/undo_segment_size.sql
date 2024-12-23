SELECT segsize.TABLESPACE_NAME,
(segsize.sizeGB / filsize.sizeGB) * 100 usage_percent
FROM (SELECT tablespace_name, SUM (a.bytes) / 1024 / 1024 / 1024 sizeGB
FROM v$datafile a, v$tablespace b, dba_tablespaces c
 WHERE c.contents = 'UNDO'
 AND c.status = 'ONLINE'
 AND b.name = c.tablespace_name
 AND a.ts# = b.ts#
GROUP BY tablespace_name) filsize,
 (SELECT TABLESPACE_NAME, SUM (bytes) / 1024 / 1024 / 1024 sizeGB
FROM dba_segments ds
 WHERE DS.SEGMENT_TYPE = 'TYPE2 UNDO'
GROUP BY ds.TABLESPACE_NAME) segsize
 WHERE segsize.TABLESPACE_NAME = filsize.tablespace_name
 AND segsize.TABLESPACE_NAME <> 'ORAUNDOTBS5';