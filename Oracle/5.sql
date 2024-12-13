--三、Oracle 查询 SQL 语句执行的耗时
select a.sql_text SQL语句,
       b.etime 执行耗时,
       c.user_id 用户ID,
       c.SAMPLE_TIME 执行时间,
       c.INSTANCE_NUMBER 实例数,
       u.username 用户名, a.sql_id SQL编号
  from dba_hist_sqltext a,
       (select sql_id, ELAPSED_TIME_DELTA / 1000000 as etime
          from dba_hist_sqlstat
         where ELAPSED_TIME_DELTA / 1000000 >= 1) b,
       dba_hist_active_sess_history c,
       dba_users u
 where a.sql_id = b.sql_id
   and u.username = 'SYNC_PLUS_1_20190109'
   and c.user_id = u.user_id
   and b.sql_id = c.sql_id
  -- and a.sql_text like '%insert into GK_ZWVCH_HSC_NEW      select  %'
 order by  SAMPLE_TIME desc,
  b.etime desc;
