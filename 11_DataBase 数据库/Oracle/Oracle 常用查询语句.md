```sql
select t.TABLE_NAME,t.NUM_ROWS from all_tables t where tablespace_name='EAST'  and table_name like 'TM%' order by num_rows desc; 
```

查询 East 表空间下，所有以 TM 开头的表名 和 表数据行数

```sql
SELECT b.sid oracleID,  
       b.username Oracle用户,  
       b.serial#,  
       spid 操作系统ID,  
       paddr,  
       sql_text 正在执行的SQL,  
       b.machine 计算机名  
FROM v$process a, v$session b, v$sqlarea c  
WHERE a.addr = b.paddr  
   AND b.sql_hash_value = c.hash_value;
```

查询 数据库 当前正在执行的语句，和用户