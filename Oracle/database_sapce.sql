-- 查詢表空間語句
SELECT UPPER(F.TABLESPACE_NAME) "tablespace_name",     
       trunc((D.TOT_GROOTTE_MB - F.TOTAL_BYTES)/1024/1024/1024,2) "used(G)",  
       trunc(F.TOTAL_BYTES/1024/1024/1024,2) "free(G)",
       trunc(D.TOT_GROOTTE_MB/1024/1024/1024,2) "allocation(G)",
       trunc((ddf.MAX_BYTES-(D.TOT_GROOTTE_MB - F.TOTAL_BYTES))/1024/1024/1024,2) "free_max(G)",
       trunc(ddf.MAX_BYTES/1024/1024/1024,2) "max(G)",     
       trunc(((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) * 100) /D.TOT_GROOTTE_MB,2) || '%' "now_per",
       trunc(((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) * 100) /ddf.max_bytes,2) || '%' "max_per"--,
       --round((D.TOT_GROOTTE_MB - F.TOTAL_BYTES-0.75*ddf.MAX_BYTES)/1024/1024/1024/0.75/25,1) "need_files"
  FROM (SELECT TABLESPACE_NAME,SUM(BYTES) TOTAL_BYTES
          FROM SYS.DBA_FREE_SPACE
         GROUP BY TABLESPACE_NAME) F,
       (SELECT DD.TABLESPACE_NAME,SUM(DD.BYTES) TOT_GROOTTE_MB
          FROM SYS.DBA_DATA_FILES DD GROUP BY DD.TABLESPACE_NAME) D,(select tablespace_name,
          sum(case  when maxbytes != '0' then  maxbytes  else  bytes end) max_bytes
          from dba_data_files group by tablespace_name) ddf
 WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME
   and d.TABLESPACE_NAME = ddf.TABLESPACE_NAME
   --and D.tablespace_name not in   (select distinct (tablespace_name) from dba_undo_extents)
 ORDER BY (D.TOT_GROOTTE_MB - F.TOTAL_BYTES)/ddf.max_bytes desc;

 select occupant_name,occupant_desc,round(space_usage_kbytes/1024/1024,2) GB from v$sysaux_occupants order by 3 desc;


select owner,segment_name,bytes/1024/1024,segment_type from dba_segments  where tablespace_name='SYSAUX' 
and bytes>1024*1024*10
order by 3 desc;


truncate table audsys.aud$unified


select table_owner,table_name, partition_name, INTERVAL, HIGH_VALUE, HIGH_VALUE_LENGTH,num_rows,blocks*8/1024 MB,last_analyzed
  from dba_tab_partitions
 where table_name = 'AUD$UNIFIED';

 BEGIN
 DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL(
   interval_number       => 1,
   interval_frequency    => 'DAY');
 END;
/

BEGIN
  DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
  AUDIT_TRAIL_TYPE     =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
  LAST_ARCHIVE_TIME    =>  SYSDATE-10 );
END;
/

BEGIN
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
container => DBMS_AUDIT_MGMT.CONTAINER_CURRENT,
use_last_arch_timestamp => FALSE);
END;
/

BEGIN
  DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
  AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
  USE_LAST_ARCH_TIMESTAMP => TRUE);
END;
/