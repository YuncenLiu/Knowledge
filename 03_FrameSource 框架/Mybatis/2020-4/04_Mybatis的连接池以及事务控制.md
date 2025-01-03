##  一、连接池

### 1、连接池：

我们在实际开发中，都会使用连接池，因为它可以减少我们获取连接所消耗的时间。

![连接池](images/%E8%BF%9E%E6%8E%A5%E6%B1%A0.png)

### 2、mybatis中的连接池

​		mybatis连接池提供了3中方式的配置：

​				配置的位置：

​						主配置文件   SqlMapConfig.xml   中的   dataSource  标签，type  属性就是表示采用何种连接池方式

​				type属性的取值：

​						POOLED						采用传统的 javax.sql.DateSource  规范中的连接池   mybatis中有针对规范的实现

​						UNPOOLED					采用传统的获取连接的方式，虽然也实现   Javax.sql.DataSource  接口，但是并没有使用池的思想（每次用都重新获取一个链接）

​						JNDI								采用服务器提供的   JNDI  技术实现，来获取   DataSource  对象，不同的服务器所能拿到 DataSource 是不一样

​																注意：如果不是   web   或者  maven  的  war  工程，是不能使用的。

​																我们课程中使用的是  Tomcat  服务器，采用的连接池 就是 dbcp  连接池。

我们先来讲一下 POOLED  和  UNPOOLED 的区别

在配置连接池的地方有这样的代码串：

```xml
<!-- 配置连接池 -->
            <dataSource type="UNPOOLED">
                <property name="driver" value="${jdbc.driver}"></property>
                <property name="url" value="${jdbc.url}"></property>
                <property name="username" value="${jdbc.username}"></property>
                <property name="password" value="${jdbc.password}"></property>
            </dataSource>
```

这里有可以写 POOLED  也可以写 UNPOOLED  两种写法，截然不同的效果

![无标题2](images/POOLED%E5%92%8CUNPOOLED.png)

分析源码：

​		底层都实现了	DataSource	接口，这个是	jdbc	连接池规范里的定义，

==当我们用	UnpooledDataSource	的时候，注册驱动、获取连接，把连接返回回去，这是非连接池的效果==

==当我们用	PooledDataSource	的时候，首先看到了	synchronized	关键字，我们清楚，连接池是需要线程同步的，这个时候我们就大致清楚了，如果我们空闲还有位置，我们就拿一个出来用，如果不够了判断我们这里有没有地（活动的连接池数量小于设定的最大值）我们就	new	一个出来，或者说没有地了，就会去获取活动池最老的，清理一下，就拿过来用==

![1](images/Pooled%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90.jpg)

图解：

![mybatis_pooled的过程](images/mybatis_pooled%E7%9A%84%E8%BF%87%E7%A8%8B.png)

**当我们知道	UNPOOLED	和	POOLED	的区别之后，我们肯定是要用	POOLED	以池的思想来管理连接数据库的**

## 二、事务

### 3、mybatis中的事务

+  什么是事务？

  ​		含义：事务由单独单元的一个或者多个sql语句组成，在这个单元中，每个mysql语句时相互依赖的。而整个单独单元作为一个不可分割的整体，如果单元中某条sql语句一旦执行失败或者产生错误，整个单元将会回滚，也就是所有受到影响的数据将会返回到事务开始以前的状态；如果单元中的所有sql语句均执行成功，则事务被顺利执行。

  ​		事务的属性
  原子性：一个事务不可在分割，要么都执行要么都不执行。
  一致性：一个事务的执行会使数据从一个一致状态切换到另一个一致的状态。
  隔离性：一个事务的执行不受其他事物的干扰
  持久性： 一个事务一旦提交，则会永久的改变数据库的数据
  ​		事务的创建
  隐式事务：事务没有明显的开启和结束的标记
  显式事务：事务具有明显的开启和结束的标记 前提：必须先设置自动提交功能为禁用

  ```
  步骤1：开启事务
      set autocommit=0;
      start transaction;可选的
  步骤2：编写事务中的sql语句(select insert update delete)
        语句1
        语句2
  步骤3：结束事务
      commit;提交事务
      rollback;回滚事务
  ```

+ 事务的四大特性ACID==(事务的属性)==

  1、原子性(Atomicity): 事务中所有操作是不可再分割的原子单元。事务中所有操作要么都执行成功,要么都执行失败。

  2、一致性(Consistency): 事务执行后,数据库状态与其他业务规则保持一致。如转账业务，无论事务执行成功与否，参与转账的两个账户余额之和应该保持不变。

  3、隔离性(Isolation): 隔离性是指在并发操作中，不同事务之间应该隔离开来，使每个并发中的事务不会互相干扰。

  4、持久性(Durability): 一旦事务提交成功，事务中所有的数据操作都必须被持久化保存到数据库中，即使提交事务后，数据库崩溃，在数据库重启时，也必须能保证通过某种机制恢复数据。

+ 不考虑隔离性会产生的3个问题

  1、脏读：脏读是指在一个事务处理过程里读取了另一个未提交的事务中的数据。

  2、不可重复读：一个事务两次读取同一行的数据，结果得到不同状态的结果，中间正好另一个事务更新了该数据，两次结果相异，不可被信任。通俗来讲就是：事务T1在读取某一数据，而事务T2立马修改了这个数据并且提交事务给数据库，事务T1再次读取该数据就得到了不同的结果，发送了不可重复读。

  3、幻读（虚读）：一个事务执行两次查询，第二次结果集包含第一次中没有或某些行已经被删除的数据，造成两次结果不一致，只是另一个事务在这两次查询中间插入或删除了数据造成的。通俗来讲就是：例如事务T1对一个表中所有的行的某个数据项做了从“1”修改为“2”的操作，这时事务T2又对这个表中插入了一行数据项，而这个数据项的数值还是为“1”并且提交给数据库。而操作事务T1的用户如果再查看刚刚修改的数据，会发现还有一行没有修改，其实这行是从事务T2中添加的，就好像产生幻觉一样，这就是发生了幻读

+ 解决办法：四种隔离级别

1、Read Uncommited（读取未提交内容）

读未提交，顾名思义，就是一个事务可以读取另一个未提交事务的数据。但是，读未提交产生了脏读，采用读提交可以解决脏读问题

2、Read Commited（读取提交内容）

读提交，顾名思义，就是一个事务要等另一个事务提交后才能读取数据。读提交，若有事务对数据进行更新（UPDATE）操作时，读操作事务要等待这个更新操作事务提交后才能读取数据，可以解决脏读问题。但在这个事例中，出现了一个事务范围内两个相同的查询却返回了不同数据，这就是不可重复读。但是，读提交两次查询会产生不同的查询结果，就会造成不可重复读问题，采用重复读可以解决此问题。

3、Repeatable Read（重复读）

重复读，就是在开始读取数据（事务开启）时，不再允许修改操作。重复读可以解决不可重复读问题。应该明白的一点就是，不可重复读对应的是修改，即UPDATE操作。但是可能还会有幻读问题。因为幻读问题对应的是插入INSERT操作，而不是UPDATE操作。采用Serializable可以解决幻读问题

4、Serializable（可串行化）

Serializable 是最高的事务隔离级别，在该级别下，事务串行化顺序执行，可以避免脏读、不可重复读与幻读。但是这种事务隔离级别效率低下，比较耗数据库性能，一般不使用。

==【注意】==

1、大多数数据库默认的事务隔离级别是Read committed，比如Sql Server , Oracle。Mysql的默认隔离级别是Repeatable read。

2、隔离级别的设置只对当前链接有效。对于使用MySQL命令窗口而言，一个窗口就相当于一个链接，当前窗口设置的隔离级别只对当前窗口中的事务有效；对于JDBC操作数据库来说，一个Connection对象相当于一个链接，而对于Connection对象设置的隔离级别只对该Connection对象有效，与其他链接Connection对象无关。

3、设置数据库的隔离级别一定要是在开启事务之前。

```java
sqlSession = factory.openSession(true);
//  当我们设置autocommit就可以不用自己提交了，手动提交改成了自动提交
//        sqlSession.commit();
```

改就是这样改，但是你不要那么憨，如果多次对数据库进行交互，总是提交，会出问题滴。

