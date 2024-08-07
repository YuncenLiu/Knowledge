

### 闲言两句

前两天，北京地铁10号线瘫痪了半个小时，于是我就在地铁里胡思乱想了半个小时。想的脸都通红通红的，其他乘客应该和我一样，也在胡思乱想，所以脸也通红通红的。

地铁运行就好比一个庞大的微服务系统。每个地铁站点就是一个微服务，突发性的大量用户，导致服务不可用。

地铁里的我们，就好比服务运行一半发生了宕机事件，可以从日志中找到，在下一次开启服务的时候，继续运行。

因为服务不可用，导致大量用户排队在地铁口，这样我们可以去增加队列，保证数据不丢失。

但是地铁不是服务，不能横向扩展，不能说，因为 “东单站” 人员太多了，就开两个 “东单站” ，虽然不能开两个东单地铁站，但是我们有公交站、火车站、飞机场、太空站.... （扯远了）总之，人类用了很多很多办法，解决生活中大大小小的系统问题。而这些问题，在我们程序员面前就是一个微观的世界。

我们要在性能和代价之间权衡。不能在一个小县城里盖五六个机场，也不能在一个一线城市只建公交不建地铁。总之！一切以业务为核心的去进行服务框架选型。

### 正片

前两周，我们学习了 MySQL 的体系架构，弄清楚了 MySQL 的存储引擎、系统文件层、运行机制等。如果不了解的，可以去看一下

这次我们学习一下 MySQL 的索引，有过一两年经验的朋友们，多少了解一点这东西的作用。

优化查询！

这次我们通过对 MySQL 的索引进行一个比较详细的了解

[toc]

# 索引类型

## 普通索引

对表的单独一个字段建立索引，没有任何限制

```sql
CREATE INDEX <索引的名字> ON tablename (字段名);
ALTER TABLE tablename ADD INDEX [索引的名字] (字段名);
CREATE TABLE tablename ( [...], INDEX [索引的名字] (字段名) );
```

## 唯一索引

和普通索引不同的是，唯一索引的值必须唯一，但允许空值

```sql
CREATE UNIQUE INDEX <索引的名字> ON tablename (字段名);
ALTER TABLE tablename ADD UNIQUE INDEX [索引的名字] (字段名);
CREATE TABLE tablename ( [...], UNIQUE [索引的名字] (字段名) ;
```

## 主键索引

和前两者不同的是，他是特殊的唯一索引，不允许空值，且每个表只能有一个主键

```sql
CREATE TABLE tablename ( [...], PRIMARY KEY (字段名) );
ALTER TABLE tablename ADD PRIMARY KEY (字段名);
```

## 复合索引

即可以在一张表的多个列中建立索引，这样可以优化多个条件查询。

```sql
CREATE INDEX <索引的名字> ON tablename (字段名1，字段名2...);
ALTER TABLE tablename ADD INDEX [索引的名字] (字段名1，字段名2...);
CREATE TABLE tablename ( [...], INDEX [索引的名字] (字段名1，字段名2...) );
```

复合索引可以代替多个单一索引，相比多个单一索引复合索引所需的开销更小，

索引同事有两个概念

- 窄索引（1-2列索引）
- 宽索引（大于2列索引）

设计索引重要的一个原则就是，能用窄索引不用宽索引。窄索引往往比组合索引更有效。

注意事项：

1. 使用复合索引时，要根据 where 条件创建，不要过多使用，否则会对操作效率有很大影响
2. 如果表已经有 col1、col2的复合索引，就不要再单独建立 col1索引了，如果已经有 col1 索引，查询条件需要col1 和 col2 时，可以建立 （col1、col2）复合索引，对查询有一定提高。

## 全文索引

全文索引在 MySQL 5.6 之前，只有MyISAM 引擎上有。5.6以后开始也支持 InnoDB

+ 全文索引必须在字符串、文本上建立
+ 全文索引字段必须在最小字符和最大字符之间才会有效 innodb 是 3-84；myisam 是 4-84 是可以修改的

```sql
mysql> show variables like '%innodb_ft_min_token_size%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| innodb_ft_min_token_size | 3     |
+--------------------------+-------+
1 row in set (0.14 sec)

mysql> show variables like '%innodb_ft_max_token_size%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| innodb_ft_max_token_size | 84    |
+--------------------------+-------+
1 row in set (0.08 sec)
```

+ 全文索引字段会进行切词处理，按 syntax 字符进行切割
+ 全文索引匹配模式，默认使用的是等值匹配。如果要通配符匹配这样写

```sql
select * from user where match(name) against('a*' in boolean mode);
```



#  索引原理

MySQL 官方定义索引：是存储用于快速查找记录的一种数据结构，需要额外开辟空间和数据维护工作。

+ 索引是屋里数据存储，在数据文件中（Innodb 中，ibd文件），利用数据页 page 存储
+ 索引可以加快查询索引速度，但是同时也会降低增删改操作速度，索引维护需要代价。

既然说到了 索引的原理，我们多少要理解一下 二分查找法、Hash和B+Tree 结构

## 数据结构

（没有基础就跳过这个吧，会用就行了）

### 二分查找

前提是查找的值，必须是有序的，

然后定位两个指针 left、right，计算中间值，判断目标值和中间值的大小，如果目标值比中间值小，说明在中间左边，这时，right 指针为中间值，然后重复此操作。

![image-20230315142750304](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315142750304.png)

![image-20230315142928853](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315142928853.png)

![image-20230315142944673](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315142944673.png)

![image-20230315142955441](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315142955441.png)

优点是等值查询、范围查询

缺点是更新数据、新增、删除数据（需要重新排二叉树【排序】）

### Hash结构

Key、Value 存储结构，非常适合根据 key 查找 value值（**等值查询**）

![image-20230315143332847](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315143332847.png)

从结构看，非常适合等值查询，但是范围查询就要全表扫描了，这种结果主要运用在 Memory 原生的 Hash 索引上，其实 Innodb 也有，自适应哈希索引

不知道还记不记得之前的那张图

![图片](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/640.png)

在 Buffer Pool 的左侧就有 Adaptive Hash Index （自适应Hash索引）

**InnoDB 提供的自适应哈希索引功能强大，是为了提高查询效率，InnoDB 存储引擎会监控表上各个索引页的查询，当 InnoDB 注意到某些索引访问非常频繁时，会在内存中基于 B+Tree 索引再创建一个哈希索引，是的内存中 B+Tree 索引具备哈希索引的功能。**

InnoDB 自适应哈希索引，在使用 Hash 索引访问时，一次性查询就能定位数据，等值查询效率要优于 B+Tree

自适应哈希索引的建立是的 InooDB 存储引擎自动更具索引页访问的频率和模式自定义地为某些热点也建立哈希索引来加速访问，另外 InnoDB 自适应哈希索引的功能，用户只能选择开启和关闭，无法人工干涉。

```sql
mysql> show engine innodb status \G;
```

![image-20230315144716411](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315144716411.png)

```sql
mysql> show variables like '%innodb_adaptive%';
+----------------------------------+--------+
| Variable_name                    | Value  |
+----------------------------------+--------+
| innodb_adaptive_flushing         | ON     |
| innodb_adaptive_flushing_lwm     | 10     |
| innodb_adaptive_hash_index       | ON     |
| innodb_adaptive_hash_index_parts | 8      |
| innodb_adaptive_max_sleep_delay  | 150000 |
+----------------------------------+--------+
```

### B+Tree

+ 非叶子节点不存储 data 数据，只存储索引值
+ 叶子节点包含所有索引值和data 数据
+ 叶子节点用指针链接，提高区间访问性能

![image-20230315145046282](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315145046282.png)

## 聚簇索引和辅助索引

聚簇索引和非聚簇索引，索引和数据在同一个文件就是聚簇索引，分开存放就是非聚簇索引

主索引和辅助索引，B+Tree 的叶子节点存放的就是主键字段值就是主键索引，如果存放的是非主键值就是辅助索引（二级索引）

在 InnoDB 中就是采用聚簇索引结构存储。InnoDB 表要求必须要有聚簇所以你

+ 如果定义了主键，则主键索引就是聚簇索引
+ 如果表没有定义主键，则第一个非空 unique 列作为聚簇索引
+ **否则 InnoDB 会创建一个隐藏的 row-id 作为聚簇索引（主键）**

辅助索引，也叫二级索引，是根据索引列构建的 B+Tree 结构，但在  B+Tree 的叶子节点中只存了索引和主键，所以空间会比聚簇索引小很多。一张 InnoDB 表只能创建一个聚簇索引，但是可以创建多个辅助索引。

# 索引分析与优化

## EXPLAIN

MySQL 提供了一个 EXPLAIN 命令，它可以对 SELECT 语句进行分析，并输出详细的信息供开发人员进行针对性优化

```sql
mysql> explain select * from user where id <3 \G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: user
   partitions: NULL
         type: range
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: NULL
         rows: 2
     filtered: 100.00
        Extra: Using where
1 row in set, 1 warning (0.05 sec)
```

**select_type**

| 参数               | 解释                                                  |
| ------------------ | ----------------------------------------------------- |
| SIMPLE             | 表示查询语句不包含子查询或 union                      |
| PRIMARY            | 表示查询是最外层的查询                                |
| UNION              | 表示此查询是UNION的第二个或后续查询                   |
| DEPENDENT UNION    | UNION中的第二个或后续的查询语句，使用了外面的查询结果 |
| UNION RESULT       | UNION的结果                                           |
| SUBQUERY           | SELECT 子查询语句                                     |
| DEPENDENT SUBQUERY | SELECT 子查询语句依赖了外层查询结果                   |

**type**

表示存储引擎查询数据时候采用的方式，比较重要的一个属性，通过它可以判断出查询是全表扫描还是基于索引的部分扫描，效率从上至下依次增强

| 参数   | 解释                                                       |
| ------ | ---------------------------------------------------------- |
| ALL    | 全表扫描，速度最慢                                         |
| index  | 基于索引的全表扫描，先扫描索引然后在全表扫描               |
| range  | 使用范围查询 >、<、in 等等                                 |
| ref    | 使用非唯一索引进行单值查询                                 |
| eq_ref | 多表join查询，表示前面表的一个记录，只能匹配到后面表的一行 |
| const  | 使用主键或索引做等值查询，常量查询                         |
| NULL   | 不访问表，速度最快                                         |

**possible_keys**

表示查询能够使用到的索引，并不一定真正用

**key**

表示真正用到的索引

**rows**

MySQL 查询优化器会根据统计信息，估算SQL要查询到结果扫描多上，原则是 rowss 越少效率越高，可以直观的看到 SQL 效率高低

**Key_len**

表示查询使用索引的字节数量，可以判断是否全部使用了组合索引

**Extra**

表示很多额外信息，各种操作会在 Extra 提升相关信息。

| 参数            | 解释                                                     |
| --------------- | -------------------------------------------------------- |
| Using where     | 表示查询需要通过索引回表查询数据                         |
| Using index     | 索引就可以满足所需数据                                   |
| Using filesort  | 查询结果需要额外排序，数据小在内存，大就在硬盘，建议优化 |
| Using temproary | 使用到了临时表，一般用于去重，分组等操作                 |

## 回表查询

​	之前说到的辅助索引，辅助索引的叶子节点存储的是主键，通过辅助索引定位到主键后需要二次遍历索引数，然后通过聚簇索引定位行。他的性能比一次遍历低

## 索引覆盖

官方话：只需要再一颗索引树上就能获取SQL所需的所有数据，无需回表，速度快，这就叫索引覆盖

实现索引覆盖最常见的方法就是：将被查询字段，建立到组合索引

怎么用！ 

**请看下文！**

## 最左前缀原则

复合索引使用时候遵循最左前缀原则，顾名思义，最左有限，即使查询中使用最左边的列，那么查询就会使用到索引。

举个例

```sql
CREATE INDEX 复合索引 ON 用户表 (姓名，年龄，性别);
```

如果查询条件是这样就走索引

```sql
select * from 用户表 where 姓名 = a;
select * from 用户表 where 姓名 = a and 年龄 = 20;
-- 三个列的复合索引，在匹配最左前缀不需要考虑顺序，之前内存篇见过，查询优化器会自动优化
select * from 用户表 where 年龄 = 20 and 姓名 = a;
select * from 用户表 where 年龄 = 20 and 姓名 = a and 性别 = 1;
```

如果是这样的就不走索引

```sql
select * from 用户表 where 性别 = 1;
select * from 用户表 where 年龄 = 18;
select * from 用户表 where 年龄 = 18 and 性别 = 1;
```

![image-20230315161610891](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315161610891.png)

## LIKE 查询走索引吗？

MySQL 在使用 like 模糊查询时候，能走索引吗？

特定情况是可以的，只有当 % 在后面才起作用

```sql
select * from user name like 'a%';

-- 不起作用的查询
select * from user name like '%a%';
select * from user name like '%a';
```

## NULL值，索引还有用吗？

如果 MySQL 表的某一列包含 Null 值，那么包含该列的索引是否有效？

对 MySQL 来说，null 是特殊字符，从概念上讲，null 意味着“一个未知值”，它的处理方式与其他值不一样，不能做 = > < 这样的运算，count 时候也不会包括 null，null 会比空字符串需要更多的存储空间

**官方原话：NULL 列需要增加额外空间来记录值是否为NULL，对于 MyISAM 表，每个空列额外占用1位，四舍五入最接近的字节**

虽然 MySQL 可以在包含 NULL 的列上使用索引，但 NULL 和其他数据还是有区别的，不建议列上允许为 NULL，最好设置 NOT NULL，并给一个默认值，比如 0 或 空字符串，如果是 datetime ，可以设置一个系统时间，或者给一个固定的特殊值 `1900-01-01 00:00:00` 等

## 索引与排序

MySQL 支持的排序方式有 `filesort` 和 `index` 两种，前者把结果查出，然后再缓存或磁盘里排序，效率低，后者利用索引自动排序，不需要额外再排序，效率高

这里主要讲 `filesort`

+ 双路排序：两次扫描磁盘，最终得到用户数据，第一次将排序字段取出，然后排序，第二次根据这个排序字段取其他字段的值
+ **单路排序：从磁盘中查询所有数据，然后在内存中排序返回结果，如果数据超出缓存 sort_buffer ，会导致多次磁盘读取操作，并创建临时表，最后产生了多次IO，增加负担（解决方案 少用select *；增加 sort_buffer_size 容量和 max_length_for_sort_data 容量）**

如果我们使用 Explain 分析SQL，在 Extra 显示 Using filesort，表示使用了 filesort 排序，需要优化，如果是现实 Using index，表示覆盖索引，前面我们也提到了，覆盖索引老快了。

以下情况会使用 index 方式排序

+ order by 子句索引列满足最左前缀

```sql
-- 对应索引 (id)、(id，name) 索引有效
explain select id from user order by id;
```

+ where 子句 + order by 子句满足最左前缀

```sql
-- 对应索引 (age，name) 索引有效
explain select id from user where age =18 order by name;
-- 对应索引 (name ,age ) 没有效、没有效、没有效 ！！！
```

以下情况会使用 filesort 方式排序

+ 同时使用 asc 和 desc 
+ where 子句和 order by 子句满足最左，但是 where 用了范围查询 < 、>、in 等
+ order by 或 where + order by 没有满足索引前列
+ 使用了不同的索引，myslq 每次只采用一个索引，order by 涉及了两个索引
+ where 子句与 order by 子句使用了不同索引
+ where 子句或者 order by 子句中索引列使用了表达式，包括函数表达式

# 查询优化

## 慢查询定位

开启慢查询日志

```sql
show variables like '%slow_query_log%';
```

![image-20230315163709351](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315163709351.png)

如果发现未 OFF，那就打开

```sql
set global slow_query_log = ON;

-- 没有使用索引的 SQL，前提是 slow_query_log 必须未 on ，否则不生效
set global log_queries_not_using_indexes = ON;
```

也可以修改默认的 慢查询时间

```sql
mysql> show variables like '%long_query_time%';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
1 row in set (0.05 sec)


mysql> SET long_query_time = 10;
```

然后我们可以直接去打开  `/var/lib/mysql/0d8ebdb19b36-slow.log`

![image-20230315164435590](images/MySQL%E7%B4%A2%E5%BC%95%E7%AF%87/image-20230315164435590.png)

这里我特地设置了小的时间

| 参数          | 解释                         |
| ------------- | ---------------------------- |
| time          | 记录时间                     |
| User@Host     | 执行用户及主机               |
| Query_time    | 查询时间                     |
| Lock_time     | 锁表时间                     |
| Rows_sent     | 发给请求放的记录数，结果数量 |
| Rows_examined | 语句扫描的记录数             |
| SET timestamp | 语句执行的时间点             |
| Select...     | 执行的具体sql                |

除了直接打开文件，我们还可以使用 mysqldumpslow 查看

最简单的还是直接打开看

## 慢查询优化

### 索引和慢查询

+ 如何判断为慢查询？

MySQL 判断一条语句是否为慢查询，主要依据 SQL 语句的执行时间，它把当前语句的执行时间跟 long_query_time 参数做比较，如果执行时间 > long_query_time 就会把他放到慢查询日志里，long_query_time 默认是 10秒，那具体是多少，就得看业务了。

+ 如何判断是否走了索引

EXPLAIN 分析呀！看看key值那块是否为 null

+ 用了索引就一定快吗？

```sql
select * from user where id > 0;
```

上面这个sql 虽然用了索引，但是还是失去了索引 的意义，全表扫描。并不是说用了索引就一定快

### 提高索引过滤性

要知道，一张 五千万记录的表，再怎么优化也没有一张记录 5条记录的表快，所以数据量决定表的效率。

**阿里巴巴，建议一张表 500万数据**

所以我们在写逻辑查询时候，要过滤定位到 10条、100条。

我们来看这一条语句

```sql
select * from student where age=18 and name like '张%';
-- (全表扫描)
```

优化1： 给 name 添加索引

优化2：给 (age,name) 添加组合索引

优化3：创建虚拟列（Mysql5.7引入）把年龄和虚拟列做联合索引

```sql
alter table studnet add first_name varchar(2) generated always as (left(name,1)),add idnex(first_name,age);
-- 查询语句
select * from student where name = '张'and age =18
```

总结：

1. 全表扫描：explain 分析 type 属性 all
2. 全索引扫描：explain 分析 type 属性 index
3. 索引过滤性不好：靠索引字段选型、数据量和状态、表设计
4. 频繁回表查询开销：尽量少用 select *，使用覆盖索引

## 分页查询优化

一般用不到，一般分页都是 10页、20页，顶多也就 100页。

但就怕面试官问，所以我们做两组数据

1. 固定偏移量，返回的记录数对执行时间影响

```sql
0.01741425 | select * from user limit 10000,1
0.01726200 | select * from user limit 10000,10
0.01596125 | select * from user limit 10000,100
0.01809600 | select * from user limit 10000,1000
0.01788475 | select * from user limit 10000,10000          
```

变化量好小啊，多次测量，小于100 没什么区别

2. 固定返回记录数，变化偏移量

```sql
0.00098425 | select * from user limit 1,100
0.00110300 | select * from user limit 10,100 
0.00108600 | select * from user limit 100,100
0.00235425 | select * from user limit 1000,100 
0.01638600 | select * from user limit 10000,100  
```

我们可以发现，拆过1000 就急剧增大了

这种还得看线上情况，我们造的测试表，测不出多大的差距

优化方案如下：

1. 利用覆盖索引优化
2. 利用子查询优化

二者都是用的筛选优化策略



