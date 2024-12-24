select * from
(select t.sample_time,
s.PARSING_SCHEMA_NAME,
t.sql_id,t.sql_child_number as sql_child,
round(t.temp_space_allocated / 1024 / 1024 / 1024, 2) || ' G' as temp_used,
round(t.temp_space_allocated /(select sum(decode(d.autoextensible, 'YES', d.maxbytes, d.bytes)) from dba_temp_files d),2) * 100 || ' %' as temp_pct,
t.program,
t.module,
s.SQL_TEXT,
t.session_id
from v$active_session_history t, v$sql s
where t.sample_time > to_date('日期', 'yyyy-mm-dd hh24:mi:ss')
and t.sample_time < to_date('日期', 'yyyy-mm-dd hh24:mi:ss')
and t.temp_space_allocated is not null
and t.sql_id = s.SQL_ID
order by t.temp_space_allocated desc)
where rownum < 50
order by temp_used desc;

