--------------------定位是否有阻塞情况
select a.SQL_TEXT,a.SQL_FULLTEXT,a.SQL_ID,a.LAST_ACTIVE_TIME,b.sid,b.SERIAL#,b.STATUS,b.PROCESS ap_process,round(b.last_call_et/60,4) time_min,
b.BLOCKING_SESSION_STATUS,b.BLOCKING_SESSION,b.FINAL_BLOCKING_SESSION_STATUS,b.FINAL_BLOCKING_SESSION,c.requesta,
c.lmode,c.request,c.type
from v$sql a,v$session b,(SELECT DECODE(request,0,'Holder: ','Waiter: ') requesta, sid sess , id1, id2, lmode,
request, type
   FROM V$LOCK
WHERE (id1, id2, type) IN (SELECT id1, id2, type FROM V$LOCK WHERE request>0)) c
where a.sql_id=b.sql_id and b.sid=c.sess
