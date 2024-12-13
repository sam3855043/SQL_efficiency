--1、查詢oracle的連接數
    select count(*) from v$session;
--2、查詢oracle的併發連接數
   select count(*) from v$session where status='ACTIVE';
--3、查看不同使用者的連接數
 select username,count(username) from v$session where username is not null group by username;
--4、查看所有使用者：
  select * from all_users;
--5、查看使用者或角色系統許可權(直接賦值給使用者或角色的系統許可權)：
   select * from dba_sys_privs;
   select * from user_sys_privs;
--6、查看角色(只能查看登陸使用者擁有的角色)所包含的許可權
   select * from role_sys_privs;
--7、查看使用者物件使用權限：
   select * from dba_tab_privs;
   select * from all_tab_privs;
