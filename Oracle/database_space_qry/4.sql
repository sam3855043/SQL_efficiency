select table_owner,table_name, partition_name, INTERVAL, HIGH_VALUE, HIGH_VALUE_LENGTH,num_rows,blocks*8/1024 MB,last_analyzed
  from dba_tab_partitions
 where table_name = 'AUD$UNIFIED';