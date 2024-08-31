查看端口

```
show global variables like 'port';
```



```txt
version : 8.0 版本
```



创建用户： 需要 root 用户登录

```sql
-- 创建 EAST 用户名 密码为 EAST 指定 % 连接，意思是所有主机都可以登录
create user 'EAST'@'%' identified by 'EAST';
```

赋予权限：

```sql
grant all privileges on *.* to 'EAST'@'%' with grant option;
```

刷新权限

```sql
flush privileges;
```

创建数据库

```sql
CREATE DATABASE IF NOT EXISTS blog
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;
```

查询当前端口号：

```sql
show global variables like 'port';
```



> 查看当前被锁的语句

```sql
SELECT * FROM performance_schema.events_statements_history WHERE thread_id IN(
SELECT b.`THREAD_ID` FROM sys.`innodb_lock_waits` AS a , performance_schema.threads AS b
WHERE a.waiting_pid = b.`PROCESSLIST_ID`)
ORDER BY timer_start ASC;
```

> 查看持有锁的语句

```sql
SELECT * FROM performance_schema.events_statements_history WHERE thread_id IN(
SELECT b.`THREAD_ID` FROM sys.`innodb_lock_waits` AS a , performance_schema.threads AS b
WHERE a.`blocking_pid` = b.`PROCESSLIST_ID`)
ORDER BY timer_start ASC;
```



给%主机用户赋权时 1044 错误 1044 - Access denied for user 'root'@'%' to database 'bladex'

```sql
SELECT host,user,Grant_priv,Super_priv FROM mysql.user;
```

找到当条数据，将Grant_priv、Super_priv改为Y 再保存





指定IP、Port 登录

```sh
mysql -hlocalhost -P 3388 -uroot -p546820.0@lyc
mysql -h82.157.58.225 -P 3388 -uroot -p546820.0@lyc
```

