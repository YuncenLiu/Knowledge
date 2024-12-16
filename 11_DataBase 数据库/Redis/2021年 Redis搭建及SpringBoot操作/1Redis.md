## 1、tcp-backlog 5111、NoSQL简介

NoSQL ，泛指非` 关系型数据库 `，NoSql 数据库的四大分类：

1. 键 值（Key - Value）存储数据库，这一类数据库主要会用到一个哈希表，这个表中有一个特定的键和一个指针指向特定的数据。如 Redis，Voldemort，Oracle BDB
2. 列存储数据库：这一列数据库通常是用来对应分布式存储的海量数据。键任然存在，但是他们的特点是指向多个列，如 HBase (大数据），Riak
3. 文档型数据：该类型的数据模型是版本化的文档，半结构化的文档以特定的格式存储，比如 JSON。文档型数据库可看作是键值数据库的升级版，允许之间嵌套键值。而且文档型数据库比键值数据库 查询效率更高。如 CouchDB、MongoDB
4. 图像（Graph）数据库，图形结构的数据库同其他行列以及刚性结构的SQL 数据库不同，他是使用灵活的图形模型，并且能够扩展到多个服务器上。NoSQL数据库没有标准的查询语言（SQL），因此进行数据库查询需要制定数据模型。许多 NoSQL 数据库都有 REST 式的数据接口或查询 API 如：Neo4J，InfoGrid，Infinite Graph

### 1.1、非关系数据库特点

+ 数据模型比较简单
+ 需要灵活性更强的 IT 系统
+ 对数据库性能要求较高
+ 不需要高度的数据一致性
+ 对于给定key，比较荣誉映射复杂值的环境

### 1.2、Redis简介

是以 key - value 形式存储，和传统的关系型数据库不一样，不一定遵循传统数据库的一些基本要求（非关系型的、分布式的、开源的。水平可扩展的）

+ ==优点：==
     + 对海量高并发读写
     + 对海量数据的高效率存储和访问
     + 对数据的可扩展和高可用性
+ ==缺点：==
     + redis（ACID 处理的非常简单）
     + 无法做到太复杂的关系数据库模型

Redis 是以 key - value store 存储，data structure service 数据结构服务器。键可以包含：（String）字符串，哈希，（list）链表，（set）集合，（zset）有序集合。这些数据集合都支持 push / pop  、add / remove及提交集和并集以及更丰富的操作，redis 支持各种不同的方式排序，为了保证效率，数据都是缓存在内存中。它也可以周期性的把更新的数据写入磁盘或者修改操作写入追加到文件中。

Redis 三种集群策略

1. 主从模式
     1. 一台主，可写可读，两台从，可读
     2. 主宕机，从也不可用
2. 哨兵模式 （Redis 2.0）
     1. 除了一个主，两个从，还有一个哨兵，四台
     2. 哨兵监控三台机器
     3. 主节点一旦挂了，哨兵会把一台从节点提升为主节点，当主节点修复成功后，再加入进来，会成为一台从节点
3. 集群模式（Redis 3.0）
     1. 多个 一主 多从类型，每个主分配数据，每台主都拥有不同数据
     2. 当主挂了，从可以继承数据，实现哨兵模式
     3. 还能再加主节点实现 可扩展

> 面试题：为什么 redis 会慢呢
>
> ​		redis 为了体现高可靠性，他会去默认开启一个 AOF（记录操作） ，当我们去开启多线程，去访问 Redis 集群 的时候，这个时候， Redis 写的性能会打折扣，但是在读的性能还行很高的，原因是因为，在并发去写的时候，他会去记入日志，写一条就记录一条。在2.0 我们可以去调整 jvm 的参数。在3.0以后，参数不能调了，无非是多加一些主服务器，分担写的压力。另外一种方法是，我们可以采用另外一种数据库，比如说 SSDB。

> 面试题：怎么实现高并发
>
> ​	前端的话，我们可以使用Nginx 加一个 lvs 或者是 keepaliver，Nginx 下面还挂了一些 Nginx，每个 从Ngnix 都去负责一些模块，java 做一些容器，做一些判断。最终要的还是后端。从 前端、java、业务、数据库层来做一些策略。

## 2、安装redis

下载 

```
https://download.redis.io/releases/redis-6.2.6.tar.gz
```

需要安装 gcc，

```
# 安装 gcc
yum install -y centos-release-scl scl-utils-build
yum install -y devtoolset-8-toolchain
scl enable devtoolset-8 bash
```

然后解压到  /usr/local  目录下，进入redis-3.0.0目录 ，执行 make 编译

```
make
```

编译完成后，再进入 src

```
make install
```

执行完成后，src 下多了两个文件   redis-server  启动       redis-cli  客户端，看到了，说明安装完成

创建两个文件夹，分别存放 redis 的配置 和  命令

```
mkdir -p /usr/local/redis/etc
mkdir -p /usr/local/redis/bin
```

把redis-3.0.0里的 redis.conf 拷贝到   刚刚新建的 redis/etc 下

再把 redis-3.0.0 /src 里的一些文件 放到刚刚新建的 redis /bin下

```
mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server /usr/local/redis/bin
```

然后修改 redis/etc 下面的 redis.conf ，把 daemonize 改为yes 记得修改密码，3.0 conf 默认注释了 IP

修改 redis.conf

```
# 运行所有服务器访问改 reids
bind 0.0.0.0  

# 允许后台启动，否则关闭窗口，redis 立刻停止服务
daemonize yes
```







进入 redis/bin 下面启动

```
redis-server /usr/local/redis/etc/redis.conf
```

验证是否启动

```
ps -ef | grep redis
netstat -tunp | grep 6379
```

进入客户端  在bin目录下

```
./redis-cli
```

退出Redis 服务  三种办法

```
pkill redis-server
kill 6379
./redis-cli -a root shutdown
```

### 2.1、redis.conf

+ bind 默认 127.0.0.1 -::1 这样默认只能本地访问 改为 bind 0.0.0.0 后，外部才能访问

+ daemonize    前后台运行模式， 值为 yes 或 no  默认为 no 前台运行，启动后，占用客户端，建议更改为 yes

+ pidfile /var/run/redis.pid  进程位置 这里表示 进程值会放在 var/run 下的 redis.pid 里，我们可以查询 这个pid ，然后kill这个值，就相当于关闭redis 服务

+ port  端口，默认6379

+ tcp-backlog 511 缓存队列，默认511  解析：

     > ​       服务器端 TCP 内核模块有 2 个队列，我们称之为 A，B吧，客户端向服务器端 connect 的时候，会发送带有 SYN 标志的包（第一次握手），服务器收到客户端发送来的 SYN 时，想客户端发送 SYN ACK 确认（第二次握手），此时 TCP  内核模块把客户端连接加入 A 队列中，然后服务器收到客户端段发来的 ACK 时（第三次挥手），TCP 内核模块把客户端连接从 A 队列移动到 B队列，连接完成，应用程序的  accept 回复暗号，也就是说 accept 从B队列中去除完成三次挥手的链接。A对也和B队列的长度之和是 backlog。当A，B队列的长度之和大于 backlog 时，新连接将会被 TCP 内核拒绝。所以，如果 backlog 过小，可能会出现 accept 速度跟不上，A，B队列满了，导致新的客户端无法链接。要注意的是：backlog 对程序链接的连接次数并无影响，backlog影响的至少还没背 accpet 取出的连接

+ databases 16 默认16个，分数据库

+ dbfilename  dump.rbd   默认格式是放进 dump.rbd ，redis 是缓存服务器，是内存形式的，一旦断电，将失去所有数据，这时，没过一段时间就要将数据写入 rbd 文件中，保持持久化，也可以设置为 aof==（上面提过AOF）== 格式

+ dir ./  以后加的文件，默认放在 redis 跟路径，我们这里修改放到 etc 里去

+ requirepass 密码，默认注释了，注释就没有密码

+ appendonly  aof配置，默认是 no 

+ appendfilename "appendonly.aof"  aof 配置生成的文件名

### 2.2、redis-cli

登录

```
auth root
```

查询所有

```
keys *
```

添加

```
set key value
```

获取

```
get key
```

删除

```
del key
```

退出客户端 或者 ctrl + c

```
quit
```

### 2.3、dump.rdb

如果关闭了 redis 数据在哪里呢，就会在 dump.rdb ，如果删掉 dump.rdb 文件则会丢失数据

## 3、数据类型

redis 一共分为五种基本数据类型：String、Hash、List、Set、ZSet

### 3,1、String

​		String 类型是包含很多类型的特殊类型，并且是二进制安全的。比如序列化的对象进行存储，比如一张图片进行二进制存储，比如一共简单的字符串，数字等

set 和 get 方法

+ 设置值：set name key   （设置name多次会覆盖）
+ 取值： get name
+ 删除值：del name

> 使用 setnx （not exist）

​	name 如果不存在进行设置，存在就不需要进行设置，返回0

> 使用 setex（expired）

​	setex color 10 red 设置 color 的有效期为 10 秒，10秒后返回 nil （在 redis 里 nil 表示空）

> 使用 setrange 替换字符串

​	set email 12345678@fox.com

​	setrange email 10 ww  （10 表示从第10位开始替换，后面的跟谁替换字符串）

> 使用一次性设置多个值的  mset、mget方法：

​	mset key1 a key2 b key3 11           mget key1 key2 key3

> 使用一次性取值的 getset 发膜护发

​	get key4 cc

​	getset key4 changchu 返回旧值并设置新值的方法

> incr 和 decr 方法：对某一个值进行递增和递减

> incrby 和 decrby 方法：对某一个值进行指定长度的递增和递减
>
> ​	incrby  key  长度

> append 和 【name】 方法：字符串追加方法

> strlen【name】 方法：获取字符串长度

### 3.2、Hash

Hash类型是 String类型的 field 和 value 的映射表，或者说一个 String 集合。它的特点适合存储对象，相对而言，将一个对象类型存储在Hash类型里要比存储在String类型里占用更少的内存空间，并方便存储整个对象

比如：hset myhash filed1 hello   含义是：hset 是 hash集合，myhash是集合名字，field是字段名 hello 为值， 使用hget myhash field1 获取内容，也可以存储多个值。hmset 可以进行批量存入多个键值对：hmset myhash sex nan addr beijing，也可以使用hmget 进行批量获取多个键值对

同样的，hsetnx 和 setnx 大同小异

+ hincrby 和 hdecrby 集合递增和递减
+ hexists 是否存在key ，存在返回，不存在返回0
+ hlen 返回hash 集合里的所有键值对
+ hdel 删除指定hash 的 field
+ hkeys 返回 hash 里面所有字段
+ hvals 返回hash 的所有 value
+ hgetall 返回 hash里多有的key 和 value

### 3.3、List

> ==清空数据库==
>
> ```
> flushdb
> ```

​	List 类型是一个链表结合的集合，其主要功能有 push、pop、获取元素等。更详细的说，List 类型是一个双链表结构，我们可以通过进行集合的头部或尾部添加删除元素，list的设计非常简单精巧，既可以作为栈，又可以作为队列。满足绝大数需求

> lpush方法：从头部加入元素（栈）先进后出
>
> ```
> lpush list1 "hello" lpush list1 "world"
> lrange list1 0-1 表示从头取到尾
> ```

> rpush 方法：从尾部加入元素（队列）先进先出
>
> ```
> rpush list2 "beijing" rpush list "sxt"
> lrange list 0-1
> ```

> linsert 方法：插入元素
>
> ```
> linsert list3 before [集合的元素][插入的元素]
> linsert list3 after [集合的元素][插入的元素]
> ```
>
> 在集合元素的  前面、后面  添加插入元素，符合栈、队列形式

> lset 方法：将指定下标的元素替换
>
> ```
> lset list3 0 one
> ```

> lrem 方法：删除元素，返回元素个数，有多少个two 就删多个 two，从前往后找，找 2 个 two 删掉，其他排序不变，大于总数量，全删
>
> ```
> lrem list4 2 two
> ```

> ltrim 方法：保留指定 key 的值范围内的数据
>
> ```
> ltrim list5 2 3
> ```

> lpop方法：从 list 的头部删除元素，并返回元素个数
>
> rpop方法：从 list 的尾部删除元素，并返回元素个数

> rpoplpush 方法：第一步从尾部删除元素，然后第二部从头部加入元素 ，把最后一个放到最前面去 （置顶）
>
> lindex 方法：返回名称为 key 的list 中index 的位置（根据下标取value）
>
> llen 方法：返回元素个数

### 3.4、Set

​	set 集合是String类型的无序集合，set是通过hashtable 实现的，对集合我们可以取交集、并集、差集。

+ sadd 方法： 向名称为 key 的set 中添加元素

     + set 集合不允许重复元素 smembers 查看 set 集合元素

+ semembers 方法：查看集合里所有元素

+ srem 方法：删除 set 集合元素

+ spop 方法：随机返回删除的 key

+ sdiff 方法：返回两个集合的不同元素（哪个集合在前面就以哪个集合为标准）

+ sdiffstore 方法：将方法的不同元素存储到另外一个集合里去

     + 这里是吧 set1 和 set2 不同元素（以 set1 为准） 存储到 set3 集合里去

          ```shell
          127.0.0.1:6379> smembers set1
          1) "bbb"
          2) "ccc"
          127.0.0.1:6379> smembers set2
          1) "bbb"
          2) "aaa"
          127.0.0.1:6379> sdiffstore set3 set1 set2
          (integer) 1
          127.0.0.1:6379> smembers set3
          1) "ccc"
          ```

+ sinter 方法：返回集合交集

+ sinterstore 方法：返回交集，存入 set4 中

+ sunion 方法：取并集

+ sunionstore 方法：取得并集，存入set5 中   ==(set1 和  set2 都是取值对象， set5 才是存入对象，这一点和前面几个方法保持一致)==

     ```shell
     sunionstore  set5 set1 set2
     ```

+ smove 方法：从一个 set 集合移动到另一个 set 集合里（就是复制）, set1  复制对象  set2 粘贴对象  aaa 复制元素

     ```sh
     smove set1 set2 aaa
     ```

+ scard 方法：查看集合里元素个数

+ sismember 方法：判断某元素是否为集合中元素，返回1 是，返回 0 不是

+ srandmember 方法：随机返回一个元素

### 3.5、ZSet

+ zadd 向有序集合中添加一个元素，该元素如果存在，则更新顺序，在重复插入的时候，会根据顺序的属性更新，5 是排序为5  five 是参数，两个参数必须存在

     ```sh
     zadd zset1 5 five
     ```

+ zrange 方法：查看所有元素

     + 尾部跟随  withscores  就会出现位置

+ zrem 删除名称为 key 的zset 中的元素 

+ zincrby 以指定值去自动递增或者递减，用法和之前 incrby 类似

+ zremrangebyrank 删除  1 到1

+ zremrangebyscore  删除指定序号

+ zrank 返回排序索引，从小到打排序（升序排序之后再找索引） 

+ zrevrank 返回排序索引，从大到小排序

+ zrangebyscore  

     + zrangebyscore  zset1 2 3 withscroes 找到指定区间范围的数据进行返回  这里返回 2  3 之间

+ zcard 返回集合里所有元素的个数

+ zcount 返回集合中score 在给定区间的数量  

```
LRANGE SYS_USER_SEL_SEX_m 0 -1
```