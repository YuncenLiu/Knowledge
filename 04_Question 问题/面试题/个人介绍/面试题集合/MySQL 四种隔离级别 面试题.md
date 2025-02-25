## 什么是事务

事务是应用程序中一系列严密的操作，所有操作必须成功完成，否则在每个操作中所作的所有更改都会被撤消。也就是事务具有原子性，一个事务中的一系列的操作要么全部成功，要么一个都不做。

编者按：一系列相关的操作，要么全部成功，要么全部不执行。

事务的结束有两种，当事务中的所有步骤全部成功执行时，事务提交。如果其中一个步骤失败，将发生回滚操作，撤消之前到事务开始时的所有操作。另外，这篇[分布式事务不理解？一次给你讲清楚！](http://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247487861&idx=1&sn=1e041eb56eaec737f95af0b3e65ac0e8&chksm=eb539443dc241d55bdbcee140ab8b33182bcf9768f21a13ba4b03fcccf331ca1eb757ba6b90e&scene=21#wechat_redirect)推荐大家阅读。

编者按：所有的操作都成功执行才会提交（提交完毕才属于真正完成操作），否则回退所有动作，原始状态。

## 事务的 ACID

事务具有四个特征：

原子性（ Atomicity ）、一致性（ Consistency ）、隔离性（ Isolation ）和持续性（ Durability ）。

这四个特性简称为 ACID 特性。

- 原子性。事务是数据库的逻辑工作单位，事务中包含的各操作要么都做，要么都不做

编者按：一个事务就是一个原子，完整性，不会停留在某个中间状态，要么初始，要么成功结束。

- 一致性。事务执行的结果必须是使数据库从一个一致性状态变到另一个一致性状态。因此当数据库只包含成功事务提交的结果时，就说数据库处于一致性状态。如果数据库系统运行中发生故障，有些事务尚未完成就被迫中断，这些未完成事务对数据库所做的修改有一部分已写入物理数据库，这时数据库就处于一种不正确的状态，或者说是不一致的状态。

编者按：数据库应该不管多少并发事务执行，都应该保持一致性。

- 隔离性。一个事务的执行不能对其它事务形成干扰。即一个事务内部的操作及使用的数据对其它并发事务是隔离的，并发执行的各个事务之间不能互相干扰。

编者按：每个之间互不影响，及时相同操作，也如同串行一样，顺序执行，同一时间一份数据执行。

- 持续性。也称永久性，指一个事务一旦提交，它对数据库中的数据的改变就应该是永久性的。接下来的其它操作或故障不应该对其执行结果有任何影响。

编者按：提交完毕的事务不可回滚。覆水难收。

## Mysql的四种隔离级别

SQL标准定义了4类隔离级别，包括了一些具体规则，用来限定事务内外的哪些改变是可见的，哪些是不可见的。低级别的隔离级一般支持更高的并发处理，并拥有更低的系统开销。

### Read Uncommitted（读取未提交内容）

在该隔离级别，所有事务都可以看到其他未提交事务的执行结果。本隔离级别很少用于实际应用，因为它的性能也不比其他级别好多少。读取未提交的数据，也被称之为脏读（Dirty Read）。

编者按：就好比还没确定的消息，你却先知道了发布出去，最后又变更了，就是说瞎话了。常说的脏读，读到了还未提交的。

### Read Committed（读取提交内容）

这是大多数数据库系统的默认隔离级别（但不是MySQL默认的）。它满足了隔离的简单定义：一个事务只能看见已经提交事务所做的改变。这种隔离级别 也支持所谓的不可重复读（Nonrepeatable Read），因为同一事务的其他实例在该实例处理其间可能会有新的commit，所以同一select可能返回不同结果。

编者按：只能读取到已经提交的事务。

### Repeatable Read（可重读）

这是MySQL的默认事务隔离级别，它确保同一事务的多个实例在并发读取数据时，会看到同样的数据行。不过理论上，这会导致另一个棘手的问题：幻读 （Phantom Read）。简单的说，幻读指当用户读取某一范围的数据行时，另一个事务又在该范围内插入了新行，当用户再读取该范围的数据行时，会发现有新的“幻影” 行。InnoDB和Falcon存储引擎通过多版本并发控制（MVCC，Multiversion Concurrency Control）机制解决了该问题。

编者按：幻读。读到已提交的数据。

### Serializable（可串行化）

这是最高的隔离级别，它通过强制事务排序，使之不可能相互冲突，从而解决幻读问题。简言之，它是在每个读的数据行上加上共享锁。在这个级别，可能导致大量的超时现象和锁竞争。

编者按：事务顺序执行，没有并行，完全杜绝幻读。

这四种隔离级别采取不同的锁类型来实现，若读取的是同一个数据的话，就容易发生问题。例如：

- 脏读(Drity Read)：某个事务已更新一份数据，另一个事务在此时读取了同一份数据，由于某些原因，前一个RollBack了操作，则后一个事务所读取的数据就会是不正确的。读取到未提交事务的数据。读取阶段。
- 不可重复读(Non-repeatable read):在一个事务的两次查询之中数据不一致，这可能是两次查询过程中间插入了一个事务更新的原有的数据。
- 幻读(Phantom Read):在一个事务的两次查询中数据笔数不一致，例如有一个事务查询了几列(Row)数据，而另一个事务却在此时插入了新的几列数据，先前的事务在接下来的查询中，就有几列数据是未查询出来的，如果此时插入和另外一个事务插入的数据，就会报错。读取到新提交的数据，发生在插入阶段。

在MySQL中，实现了这四种隔离级别，分别有可能产生问题如下所示：

在MySQL中，实现了这四种隔离级别，分别有可能产生问题如下所示：

![img](https://upload-images.jianshu.io/upload_images/1627454-eceded962ef591d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/686/format/webp)

------

### **测试Mysql的隔离级别**

 

下面，将利用MySQL的客户端程序，我们分别来测试一下这几种隔离级别。

测试数据库为demo，表为test；表结构：

![img](https://upload-images.jianshu.io/upload_images/1627454-14163bb6124dd816.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/616/format/webp)

两个命令行客户端分别为A，B；不断改变A的隔离级别，在B端修改数据。

**（一）、将A的隔离级别设置为read uncommitted(未提交读)**

![img](https://upload-images.jianshu.io/upload_images/1627454-66609deaf1f77a2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/708/format/webp)

**A：**启动事务，此时数据为初始状态

![img](https://upload-images.jianshu.io/upload_images/1627454-46e15843b9af1164.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：**启动事务，更新数据，但不提交

![img](https://upload-images.jianshu.io/upload_images/1627454-ebdce5eedc07a388.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/716/format/webp)

**A：**再次读取数据，发现数据已经被修改了，这就是所谓的“脏读”

![img](https://upload-images.jianshu.io/upload_images/1627454-c2076c78c2f8721b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：**回滚事务

![img](https://upload-images.jianshu.io/upload_images/1627454-4e0eb8e5b93e7508.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/716/format/webp)

**A：**再次读数据，发现数据变回初始状态

![img](https://upload-images.jianshu.io/upload_images/1627454-e0c4697a63bb7756.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

经过上面的实验可以得出结论，事务B更新了一条记录，但是没有提交，此时事务A可以查询出未提交记录。造成脏读现象。未提交读是最低的隔离级别。

编者按：脏读，读取到未提交事务的数据。

**（二）、将客户端A的事务隔离级别设置为read committed(已提交读)**

![img](https://upload-images.jianshu.io/upload_images/1627454-9850c93ff1d0b87e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/713/format/webp)

**A：**启动事务，此时数据为初始状态

![img](https://upload-images.jianshu.io/upload_images/1627454-895da4e5af710e10.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/709/format/webp)

**B：**启动事务，更新数据，但不提交

![img](https://upload-images.jianshu.io/upload_images/1627454-ebdce5eedc07a388.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/716/format/webp)

**A：**再次读数据，发现数据未被修改

![img](https://upload-images.jianshu.io/upload_images/1627454-c27ffc43c74eaff7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：**提交事务

![img](https://upload-images.jianshu.io/upload_images/1627454-e7fcfe11e7bc77f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/706/format/webp)

**A：**再次读取数据，发现数据已发生变化，说明B提交的修改被事务中的A读到了，这就是所谓的“不可重复读”

![img](https://upload-images.jianshu.io/upload_images/1627454-f75e52220936ba91.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/709/format/webp)

经过上面的实验可以得出结论，已提交读隔离级别解决了脏读的问题，但是出现了不可重复读的问题，即事务A在两次查询的数据不一致，因为在两次查询之间事务B更新了一条数据。已提交读只允许读取已提交的记录，但不要求可重复读。

编者按：本次事务中不会读取到其他事务对相关数据做的改变，除非其他事务提交。不可重复读的意思就是说，如果另一事务B有提交，则A事务中两次读会出现不一致。

(三)、**将A的隔离级别设置为repeatable read(可重复读)**

![img](https://upload-images.jianshu.io/upload_images/1627454-cd82123669a159e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/711/format/webp)

**A：**启动事务，此时数据为初始状态

![img](https://upload-images.jianshu.io/upload_images/1627454-034eb70d85fb2765.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/708/format/webp)

**B：启动事务，更新数据，但不提交**

![img](https://upload-images.jianshu.io/upload_images/1627454-ebdce5eedc07a388.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/716/format/webp)

**A：**再次读取数据，发现数据未被修改

![img](https://upload-images.jianshu.io/upload_images/1627454-c27ffc43c74eaff7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：**提交事务

![img](https://upload-images.jianshu.io/upload_images/1627454-e7fcfe11e7bc77f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/706/format/webp)

**A：**再次读取数据，发现数据依然未发生变化，这说明这次可以重复读了

![img](https://upload-images.jianshu.io/upload_images/1627454-c27ffc43c74eaff7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：**插入一条新的数据，并提交

![img](https://upload-images.jianshu.io/upload_images/1627454-0cc15096520791ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/705/format/webp)

**A：**再次读取数据，发现数据依然未发生变化，虽然可以重复读了，但是却发现读的不是最新数据，这就是所谓的“幻读”

![img](https://upload-images.jianshu.io/upload_images/1627454-c27ffc43c74eaff7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

A：提交本次事务，再次读取数据，发现读取正常了

![img](https://upload-images.jianshu.io/upload_images/1627454-34a1fc2ace6ebc23.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/706/format/webp)

由以上的实验可以得出结论，可重复读隔离级别只允许读取已提交记录，而且在一个事务两次读取一个记录期间，其他事务不得更新该记录。但该事务不要求与其他事务可串行化。例如，当一个事务可以找到由一个已提交事务更新的记录，但是可能产生幻读问题(注意是可能，因为数据库对隔离级别的实现有所差别)。像以上的实验，就没有出现数据幻读的问题。

编者按：本次事务中不会读取到其他提交的事务数据，当前事务结束后再次读取会读到最新数据。

(**四)、\**将A的隔离级别设置为\**可串行化(Serializable)**

![img](https://upload-images.jianshu.io/upload_images/1627454-b3bdfa59a34f9f52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/705/format/webp)

**A：**启动事务，此时数据为初始状态

![img](https://upload-images.jianshu.io/upload_images/1627454-a703dc5fbfa9556f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/711/format/webp)

**B：**发现B此时进入了等待状态，原因是因为A的事务尚未提交，只能等待（此时，B可能会发生等待超时）

![img](https://upload-images.jianshu.io/upload_images/1627454-f6cc3d7f422eefa5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**A：**提交事务

![img](https://upload-images.jianshu.io/upload_images/1627454-7ab66d7a2ee442e1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/710/format/webp)

**B：发现插入成功**

![img](https://upload-images.jianshu.io/upload_images/1627454-5dd245d3cc5954f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/714/format/webp)

serializable完全锁定字段，若一个事务来查询同一份数据就必须等待，直到前一个事务完成并解除锁定为止。是完整的隔离级别，会锁定对应的数据表格，因而会有效率的问题。

编者按：排队，依次进行。

编者按：

# **总结**

1、事务具有四个特征：

原子性（ Atomicity ）、一致性（ Consistency ）、隔离性（ Isolation ）和持续性（ Durability ）。

2、Mysql的四种隔离级别

（1）Read Uncommitted（读取未提交内容）

A可以读取到B还未提交的事务。

（2）Read Committed（读取提交内容）

A只能读取到B已经提交的事务。并且A事务中两次读到的内容不一致，原有就是B提交事务。

（3）Repeatable Read（可重读）

A只能读取到B已经提交的事务。并且A事务中两次读到的内容一致，A事务结束后再读取会读取到B提交事务。

（4）Serializable（可串行化）A事务未提交，B事务就等待。

3、脏读、幻读、不可重复读

脏读：读到了还未提交事务的数据。

幻读：两次事务读到的数据不一致。中间有新事务提交。

不可重复读：一次事务中不允许多次读，会发生数据不一致。中间有新事务提交。