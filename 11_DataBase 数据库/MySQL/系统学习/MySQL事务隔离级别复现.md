[toc]



大家好，我是想想。

很久没有给大家分享技术了，主要在计划一些事情，几乎没什么时间爽文了。

今天从实操上实现了MySQL事务隔离复现问题，就记录分享给大家吧。

### 正文

我们知道，著名的四大事务特性**ACID特性**

+ Atomicity 原子
+ Isolation 隔离
+ Durability 持久
+ Consistency 一致

在并发事务过程中，我们总是会考虑到 **隔离性** 我们可以很轻松的通过查阅资料发现分别有这4个不同的隔离级别

1. 读未提交
2. 读已提交
3. 可重复读
4. 串行化

我们知道有这四种，隔离等级从上至下越发安全，性能也越发下降。但是他们怎么在真实场景下展示出来呢？

下面演示：

## 隔离级别控制

```sql
-- 查询数据库事务隔离级别
select variables like 'tx_isolation';
select @@tx_isolation;
```

![image-20230807135940582](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807135940582.png)

我们知道 **MySQL** 默认的是 **REPEATABLE-READ** 可重复读

## 读未提交

```sql
set global tx_isolation='READ-UNCOMMITTED';
-- 全局提交，提交完重新连接一下
set tx_isolation='READ-UNCOMMITTED';
-- 当前客户端提交，不需要重连，重连之后就失效了
```

两种都可

```sh
mysql> select @@tx_isolation;
+------------------+
| @@tx_isolation   |
+------------------+
| READ-UNCOMMITTED |
+------------------+
```

在读未提交的情况下，可能会发生脏读、不可重复读、提交覆盖、幻读

初始化表

```sql
CREATE TABLE `hello` (
  `id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
)
```

创建两个客户端

### 脏读复现



![image-20230807142403196](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807142403196.png)

同时开启事务，一个客户端update ，但不提交，另一个客户端也可以查询到！

这是脏读了，当然了，这两次读取都不一样，也满足了，不可重复读这种情况。

## 读已提交

```sh
mysql> select @@tx_isolation;
+----------------+
| @@tx_isolation |
+----------------+
| READ-COMMITTED |
```

### 脏读问题解决

![image-20230807142725819](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807142725819.png)

重复操作，发现，**读已提交** 这个级别已经可以避免脏读、Oracle、SQL Server 默认就是这个隔离级别

但是这样依旧会发生 **不可重复读**、**幻读**

### 不可重复读复现

![image-20230807144001023](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807144001023.png)

这种在一个客户端内第二次读取数据发现变化的情况，就是 **不可重复读**

那要如何解决呢？ 修改为 **可重复读** 级别

## 可重复读

```sh
mysql> select @@tx_isolation;
+-----------------+
| @@tx_isolation  |
+-----------------+
| REPEATABLE-READ |
+-----------------+
```

### 不可重复读解决

![image-20230807144358750](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807144358750.png)

通过将隔离级别修改为 **可重复读**，发现不可重复读这个问题就已经解决啦

但是还是可能会出现 **幻读** 的情况

### 幻读复现

幻读，指的是两次读取，中间被其他事物插入了

我们模拟一下

![image-20230807144956203](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807144956203.png)

我没发现，并没有像理论那样，右边的事务查询到了更多的数据

> 原因是：MySQL 引入了间隙锁、范围锁这种概念，解决了这种情况。

我们再往下看

![image-20230807145640769](images/MySQL%E4%BA%8B%E5%8A%A1%E9%9A%94%E7%A6%BB%E7%BA%A7%E5%88%AB%E5%A4%8D%E7%8E%B0/image-20230807145640769.png)

间隙锁、范围锁 还是没办法解决这个问题。

## 串行化

自己去测试吧～



最后给大家带来一个面试题：

> 事务隔离级别和锁的关系？

