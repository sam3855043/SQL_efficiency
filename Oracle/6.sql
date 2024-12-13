--四：定位系统里面哪些 SQL 脚本存在 TABLE ACCESS FULL 行为
select *
  from v$sql_plan v
 where v.operation = 'TABLE ACCESS'
   and v.OPTIONS = 'FULL'
   and v.OBJECT_OWNER='SYNC_PLUS_1_20190109';


select s.SQL_TEXT
  from v$sqlarea s
 where s.SQL_ID = '4dpd97jh2gzsd'
   and s.HASH_VALUE = '1613233933'
   and s.PLAN_HASH_VALUE = '3592287464';
