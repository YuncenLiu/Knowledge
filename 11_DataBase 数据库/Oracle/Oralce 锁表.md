

### 查询锁表语句，

```sql
SELECT
	sess.sid,
	sess.serial#,
	lo.oracle_username, -- 登录账户
	lo.os_user_name, -- 登录电脑
	ao.object_name, -- 被锁表名
	lo.locked_mode --锁住级别
FROM
	v$locked_object lo,
	dba_objects ao,
	v$session sess
WHERE
	ao.object_id = lo.object_id
	AND lo.session_id = sess.sid;
```

### 解锁语句

```sql
alter system kill session '68,51';
--分别为SID和SERIAL#号
```



### 查询因数据库引起的锁表语句

```sql
SELECT A.USERNAME,
       A.MACHINE,
       A.PROGRAM,
       A.SID,
       A.SERIAL#,
       A.STATUS,
       C.PIECE,
       C.SQL_TEXT
  FROM V$SESSION A, V$SQLTEXT C
 WHERE A.SID IN (SELECT DISTINCT T2.SID
                   FROM V$LOCKED_OBJECT T1, V$SESSION T2
                  WHERE T1.SESSION_ID = T2.SID)
   AND A.SQL_ADDRESS = C.ADDRESS(+)
 ORDER BY C.PIECE;
```

