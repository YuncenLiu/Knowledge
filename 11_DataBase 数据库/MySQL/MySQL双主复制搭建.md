> 创建于2021年11月19日
> 作者：想想

[toc]



# MySQL 双主复制

​	两台服务器：

+ King 82.157.67.18
+ Queen 82.157.58.225

两台服务器所配置都相似，CentOS8.0、MySQL8.0.26

## 1、环境配置

修改 `etc/my,cnf` 文件

![image-20211119112137233](images/image-20211119112137233.png)

```sh
# King
server_id = 70
socket = /tmp/mysql.sock
innodb_buffer_pool_size = 10G
log_bin=mysql-bin
expire_logs_days=3
# 指定同步的数据库
replicate-do-db=test
# 忽略同步的数据库
binlog-ignore-db=mysql,information_schema
auto-increment-increment = 2
# 是用来设定数据库中自动增长的起点的，回为这两台服务器都设定了一次自动增长值2，所以它们的起点必须要不同，这样才能避免两台服务器数据同步时出现主键冲突.
auto-increment-offset = 1
innodb-file-per-table =ON
skip_name_resolve=ON
```

```sh
# Queen
server_id = 71
socket = /tmp/mysql.sock
innodb_buffer_pool_size = 3G
log_bin=mysql-bin
expire_logs_days=3
replicate-do-db=test
replicate-ignore-db = mysql,information_schema
auto-increment-increment = 2
auto-increment-offset = 2
```

## 2、重启服务器

```sh
service mysql restart
```

## 3、同步数据，建立复制账号

```sql
# King
CREATE USER 'test'@'%' IDENTIFIED BY 'test';
GRANT REPLICATION SLAVE ON *.* TO 'test'@'%';
flush privileges;
```

```sql
CREATE USER 'test'@'%' IDENTIFIED BY 'test';
GRANT REPLICATION SLAVE ON *.* TO 'test'@'%';
flush privileges;
```

## 4、执行 change master 同步命令

```sql
show master status;
```

King

![image-20211119131014928](images/image-20211119131014928.png)

Queen

![image-20211119131006080](images/image-20211119131006080.png)

King

```sql
change master to master_host='82.157.58.225',master_user='test',master_port=3388,master_password='test',master_log_file='mysql-bin.000001',master_log_pos=1225;
```

Queen:

```sql
change master to master_host='82.157.67.18',master_user='test',master_password='test',master_port=3388,master_log_file='mysql-bin.000004',master_log_pos=1034;
```

如果参数写错了，重新执行抛出==ERROR 3021==错误 停止IO线层

```sql
STOP SLAVE IO_THREAD;  
```

执行同步：

```sql
start slave;
```

> 如果执行同步报错
>
> ![image-20211119113035175](images/image-20211119113035175.png)
>
> ```sql
> # 先执行
> reset slave;
> # 再执行
> start slave;
> ```

查看状态

```sql
show slave status\G
```

King

![image-20211119132729003](images/image-20211119132729003.png)

Queen

![image-20211119132752780](images/image-20211119132752780.png)

成功！



```sql
#King
drop user 'blog'@'%';
CREATE USER 'blog'@'%' IDENTIFIED BY 'blog';
GRANT REPLICATION SLAVE ON *.* TO 'blog'@'%';
flush privileges;

STOP SLAVE IO_THREAD;  
change master to master_host='82.157.58.225',master_user='blog',master_port=3388,master_password='blog',master_log_file='mysql-bin.000003',master_log_pos=4739;
start slave;
show slave status\G

#Queen
drop user 'blog'@'%';
CREATE USER 'blog'@'%' IDENTIFIED BY 'blog';
GRANT REPLICATION SLAVE ON *.* TO 'blog'@'%';
flush privileges;

STOP SLAVE IO_THREAD;  
change master to master_host='82.157.67.18',master_user='blog',master_port=3388,master_password='blog',master_log_file='mysql-bin.000007',master_log_pos=3281;
start slave;
show slave status\G



mysql -uroot -p546820.0@lyc

show master status;
```

