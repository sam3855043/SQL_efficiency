二、查询次数最多的 sql
select *
 from (select s.SQL_TEXT,
        s.EXECUTIONS "执行次数",
        s.PARSING_USER_ID "用户名",
        rank() over(order by EXECUTIONS desc) EXEC_RANK
     from v$sql s
     left join all_users u
      on u.USER_ID = s.PARSING_USER_ID) t
 where exec_rank <= 100;
