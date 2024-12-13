--臨時表滿了查詢
select c.tablespace_name,
 
to_char(c.bytes/1024/1024/1024,'99,999.999') total_gb,
 
to_char( (c.bytes-d.bytes_used)/1024/1024/1024,'99,999.999') free_gb,
 
to_char(d.bytes_used/1024/1024/1024,'99,999.999') use_gb,
 
to_char(d.bytes_used*100/c.bytes,'99.99') || '%'use
 
from  (select tablespace_name,sum(bytes) bytes
 
from dba_temp_files GROUP by tablespace_name) c,
 
(select tablespace_name,sum(bytes_cached) bytes_used
 
from v$temp_extent_pool GROUP by tablespace_name) d
