[toc]

大家好，我是想想

昨天给大家说过了 MySQL 的事务隔离级别复现等问题，今天说一说 事务的具体实现：锁

> 事务隔离级别和锁的关系？

这是昨天最后抛出的问题：我个人的见解就是：**事务隔离级别底层就是用锁实现的，我们在日常开发中，如果用事务解决不了问题，再用锁去操作。**

事务的ACID特性我就不再阐述了。今天就具体分析分析MySQL有哪些锁可以用，可以怎么用。

## 锁分类

锁可以分成很多不同粒度和维度

+ 表级锁：存在于 MyISAM、InnoDB、BDB
+ 行级锁：只存在 InnoDB 中
+ 页级锁：一般存在 BDB 引擎中，锁相邻的数据。

读写方面又可以分为，读写锁可以以行级为单位

+ 读锁（共享锁），之间不会相互影响
+ 写锁（排他锁）没有操作完之前，阻断其他读锁和写锁

除了读写锁，还有意向读锁（IS锁）意向写锁（IX锁）这个从字面上很好理解，在加锁之前先先判断一下有没有意向锁，这个表级别的。

## 锁原理

在InnoDB引擎中，我们可以使用行锁和表锁、其中行锁分为共享锁和排他锁，**InnoDB行锁是通过对索引数据页上的记录加锁实现的**主要分为这3种算法

1. Record Lock：记录锁，锁定单行记录，支持RC、RR隔离级别
2. Gap Lock：间隙锁，锁定一个范围，支持 RR 级别
3. Next-key Lock：间隙锁和记录锁组合，同时锁住这一行和行前后范围，支持 RR 级别

在 RR 隔离级别，InnoDB 对记录加锁行为都是先采用 Next-key Lock，当 SQL 操作包含索引时，InnoDB 会对 Netx-key进行优化，降级为 RecordLock，仅锁住索引本身而非范围

```sql
select * from t1
```

select ... from 语句：InnoDB 引擎采用了 MVCC 机制实现非阻断，所以对普通 select 语句，InnoDB 不加锁

```sql
select * from t1 lock in share mode
```

select ... from lock in share mode 语句：追加了共享锁，**InnoDB 会使用 Next-key Lock 锁住，如果发现唯一索引，才降级为 RecordLock 锁** 通俗的讲，如果有索引，就锁住这条记录及周边范围，如果没有索引，锁全表

```sql
select * from t1 for update
```

select ... from for update 语句：追加排他锁，**InnoDB 会使用 Next-key Lock 锁住查询范围，如果发现唯一索引，才降级** 和上面一样

```sql
update t1 set name='A' where id=1
```

同上，**先 Next-Key Lock 锁住范围，发现索引，降级**

```sql
delete t1 where id=1
```

同上，**先 Next-Key Lock 锁住范围，发现索引，降级**

```sql
insert into t1 values(2,'b')
```

将在插入那一行设置个 Record Lock 记录锁。

## 锁实现

哔哩吧啦一大堆，总得操作一下看看

```sh
mysql> show columns from t1;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  | PRI | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)
```

```sh
mysql> select * from t1;
+------+------+
| id   | name |
+------+------+
|    1 | A    |
|    3 | C    |
|    5 | E    |
+------+------+
4 rows in set (0.01 sec)
```

### 主键加锁情况

```sh
PRIMARY KEY (`id`)
```

![image-20230809113029016](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809113029016.png)

我们发现排他锁，阻塞了其他客户端对数据的操作。

![image-20230809113315578](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809113315578.png)

![image-20230809113635274](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809113635274.png)

Record Lock 只对单行数据上锁。

**总结：主键索引，排他锁、排他锁只锁当前数据。**

### 索引加锁情况

删除主键索引

```sql
ALTER TABLE t1 DROP PRIMARY KEY;
```

创建索引

```sql
CREATE INDEX id USING BTREE ON t1 (id);
```

![image-20230809114258839](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809114258839.png)

**发现索引把id为 1-3 、3-5之间的数据都锁定了，满足 Next-key Lock 原理：同时锁住数据和数据前后范围**

![image-20230809114531638](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809114531638.png)

### 无索引加锁情况

删除索引

```sql
drop index id on t1;
```

![image-20230809114850090](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809114850090.png)

在去掉索引之后，GAP（Gap Lock） 锁无法对索引构建间隙锁，只能锁住全表

**总结：当没有索引时，会导致全表锁定，因为InnoDB引擎锁机制是基于索引实现的记录锁定**

## 悲观锁

概念大概就是，先假定他有锁，去获取锁。如果没发现有锁，再上锁这样个过程。从广义来讲，上面说到的 行锁、表锁、读锁、写锁、共享、排他锁都是属于悲观锁。

表级锁：每次锁操作都锁住整张表，并发度最低

```sql
lock table t1 read;
lock table t1 write;
```

查看表上加过的锁

```sql
show open tables;
```

删除表锁

```sql
unlock tables;
```

表读锁会阻塞写操作，当前连接可以做增删改操作，其他连接增删改都会阻塞。

## 乐观锁

乐观锁死相对于悲观锁而言的，它不是数据库提供的功能，需要开发者自己去实现，再操作数据库的时候想法很乐观。

就拿下单场景来说，我们新增一个 version （版本字段）

1. 第一步查询商品

	```sql
	select quantity,version from products where id = 1;
	```

	获取到数量和版本信息

2. 第二步可能要生成订单之类的操作

3. 第三步再去修改库存

	```sql
	update products set quantity = quantity -1,
	version = version+1
	where id=1 and version=#{version}
	```

> 重点： **and version = #{version}**

这样我们就手动的实现了乐观锁，如果再查询商品时候，获取的版本为1，那么在修改的时候，把版本信息当作修改条件进行update操作，如果操作没有影响到1行数据，就说明可能被其他线程抢先了这个行为。就应该发生回滚操作了。

## 死锁

这个和多线程死锁概念是一样的

|      | 事务A                                             | 事务B                                 |
| ---- | ------------------------------------------------- | ------------------------------------- |
| 1    | select * from t1 where id = 1 lock in share mode; |                                       |
| 2    |                                                   | update t1 set name ='B' where id = 1; |
| 3    | update t1 set name='cc' where id = 1;             |                                       |

![image-20230809132348198](images/MySQL%E9%94%81%E6%9C%BA%E5%88%B6/image-20230809132348198.png)

说一下解决方案：

1. 前端上控制按钮，不让客户重复点击。因为反复重复点击，容易造成上述这样的死锁
2. 使用乐观锁进行控制，避免长事务造成数据库开销。

### 死锁排查

查看近期死锁日志

```sql
show engine innodb status \G;

------------------------
LATEST DETECTED DEADLOCK
------------------------
2023-08-09 05:21:16 0x7f05a4395700
*** (1) TRANSACTION:
TRANSACTION 9218, ACTIVE 13 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 31, OS thread handle 139662205974272, query id 641 172.17.0.1 root updating
update t1 set name ='B' where id = 1
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 57 page no 3 n bits 72 index GEN_CLUST_INDEX of table `xiang`.`t1` trx id 9218 lock_mode X waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 5; compact format; info bits 0
 0: len 6; hex 000000000212; asc       ;;
 1: len 6; hex 0000000023cf; asc     # ;;
 2: len 7; hex ac000001200110; asc        ;;
 3: len 4; hex 80000001; asc     ;;
 4: len 1; hex 41; asc A;;
```

通过上述分析，我们可以看到死锁的SQL和时间、IP客户端等信息



查看死锁状态变量

```sql
mysql> show status like 'innodb_row_lock%';
+-------------------------------+--------+
| Variable_name                 | Value  |
+-------------------------------+--------+
| Innodb_row_lock_current_waits | 0      |
| Innodb_row_lock_time          | 298137 |
| Innodb_row_lock_time_avg      | 16563  |
| Innodb_row_lock_time_max      | 51017  |
| Innodb_row_lock_waits         | 18     |
+-------------------------------+--------+
5 rows in set (0.03 sec)
```

+ Innodb_row_lock_current_waits：当前正在等待锁的数量
+ Innodb_row_lock_time：从系统启动到现在锁定总时间长度
+ Innodb_row_lock_time_avg： 每次等待锁的平均时间
+ Innodb_row_lock_time_max：从系统启动到现在等待最长的一次锁的时间
+ Innodb_row_lock_waits：系统启动后到现在总共等待的次数



最后给大家来个汇总

