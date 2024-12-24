select owner,segment_name,bytes/1024/1024,segment_type from dba_segments  where tablespace_name='SYSAUX' 
and bytes>1024*1024*10
order by 3 desc;
