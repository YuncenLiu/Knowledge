## Redis 高级命令

+ 返回满足所有键   keys * （支持模糊匹配）
+ exists 是否存在指定的 key
+ expire 设置某个 key 的过期时间，使用   ttl 查看剩余时间
+ persist 取消过期时间
+ select 选择数据库 数据库为  0 - 15 默认是进入 0 数据库
+ move 【key】 【数据库下标】 将当前数据库的 key 转移到其他数据库中
+ randomkey 随机返回数据库里的一个 key
+ rename  重命名 key
+ echo 打印命令
+ dbsize 查看数据库的 key 数量
+ info 获取数据库信息
+ conflg get 实时传储收到的请求（返回相关的配置信息）
     + conflg get * 返回所有配置
+ flushdb 清空当前数据库，flushall 清空所有数据库

## 2、Redis 安全性

因为 redis 速度相当快，所以在一台比较好的服务器下，一个外部用户在一秒内可以进行 15万 次的密码尝试，这意味着你需要设定非常强大的密码来防止暴力破解

解决办法：

​	vi 编辑器 redis.conf 文件，找到下面进行保存修改

```sh
# requirepass footbared
requirepass root
```

重启服务器 pkill redis-server

​	再次进入  你会发现不能直接进行操作，需要输入  auth  root 才能进入

​	或者在登录的时候，直接     redis-cli -a root

## 3、主从复制

1.  Master 可以拥有多个 slave
2. 多个 Slave 可以连接一个 master 外，还可以连接其他的 slave
3. 主从复制不会阻塞 master 在同步数据时，master 可以继续处理 clien 请求
4. 提供系统的伸缩性

主从复制过程：

1. slave 与master  建立连接后，发送 sync 同步命令
2. master 会启动一个后台进程，将数据库快照保存到文件中，同时master 主进程会开始收集新的写命令并缓存
3. 后台完成保存后，就将文件发送给slave
4. slave 将此文件保存到 硬盘上

主从复制配置

1. clone 服务器之后修改 slave 的 IP 地址
2. 修改配置文件：/usr/local/redis/etc/redis.conf
3. 第一步 ：slaveof <masterip><masterop>
4. 第二步：masterauth <master-password>

使用info 查看 role 角色即可指定是主服务还是从服务

### 3.1、操作

准备多台服务器  让多台服务器都拥有环境

假设   主服务器 ：   A

​		   从服务器1：  B

​           从服务器2：  C

1. 此时，三台设备上 都会有 dump.rdb  文件，我们吧 B   C 服务器上的  dump.rdb 文件删除

==在 B、C服务器上的  redis.conf 文件里，修改  slaveof 值， 写上 A 服务器的 ip 地址 +  端口号==  这样，主从服务器就配置好了，

```sh
slaveof 47.102.205.233 6379
```

​		我们启动三台服务器后，进入主服务器查看 info  可以看到  role  为  master ，connected_slaves:2 节点为2，

slave0:ip : B 服务器地址 ，port = B 服务器 redis 端口

slave1:ip : C 服务器地址 ，port = C 服务器 redis 端口

​		我们进入从服务器，查看info，role 为 slave，master_host 为主服务器的端口

>  之前，我们在  B C 服务器上的 dump.rdb 文件已经删除，只有 A 服务器上有数据，但是我们依然能查到  B 、C 上有数据，且和 A 服务器上一致，说明集群生效

==从服务器不支持写入，只支持读取==

## 4、Redis 简单事务

​	redis 的事务非常简单，使用方法如下：

​		首先是使用 multi 方法打开事务，然后进行设置，这时设置的数据都会存入队列里进行保存，最后使用 exec 执行，把数据一次存入到 redis 中，使用 discard 方法取消事务。

```sh
127.0.0.1:6379> multi
OK
127.0.0.1:6379> set name1 1
QUEUED
127.0.0.1:6379> set name2 2
QUEUED
127.0.0.1:6379> set name3 3
QUEUED
127.0.0.1:6379> exec
1) OK
2) OK
3) OK
127.0.0.1:6379> keys * 
1) "name3"
2) "name2"
3) "name1"
```

如果在 exec 提交的时候，不报错，就执行成功，如果在提交的时候，比如有给字符串自增的.... 异常之类的，就报错 回滚，全部不执行



## 5、持久化

​	redis 是一个支持持久化的内存数据库，也就是说 redis 需要经常将内存中的数据同步到硬盘来保证持久化。redis 持久化的两种方式.

1. snapshotting（快照）默认方式，将内存中以快照的方式写入二进制文件中，默认为 dump.rdb 可以通过配置设置自动做快照持久化的方式，我们可以配置 redis 在 n 秒内如果超过 m 个 key 则修改就自动快照。
     1.  snapshotting 设置
          + save 900 1 #900 秒内如果超过1个key被修改  则发起快照保存
          + save 300 10 #300 秒内如果超过10个key被修改 这发起快照保存
          + save 60 10000
2. append-only file （缩写 aof）的方式（有点类似于 oracle 日志）由于快照方式是在一定时间间隔做一次，所以可能发生 redis 以外 down 的情况就会丢失最后一次快照的所有的修改数据、aof 比快照方式有更好的持久化，是由于使用 aof 时，redis 会将每一个收到的命令都通过 write 函数追加到命令中，当 redis 重新启动时，会重新执文件中保存的写好命令在内存中重新建立这个数据库的内容，这个文件在bin目录下  applendonly.aof 不是立即写入到磁盘上，可以通过配置文件修改强制写到磁盘中。
     1. aof 设置
          + appendonly     yes 				开启  aof  持久化方式有三种修改方式
          + appendfsync  always       收到写命令就立即写入磁盘，效率最慢，但是保证完全的持久化
          + appendfsync   everysec   每一秒写一次磁盘，在性能和持久化方面做好了折中   （默认）
          + appendfsync no                完全依赖 os  性能最好，持久化没保证

> 建议 aof 和 rdb 都开启



## 6、发布与订阅消息

redis 提供了简单的发布与订阅功能

使用 subscribe 【频道】  进行订阅监听

使用 publish 【频道】【发布内容】进行发布消息广播



## 7、javaAPI （一）使用

导入jar包

+ jedis
+ hamcrest-core
+ commons-pool2

测试代码

```java
public class TestSingleRedis {

    // 1 单独连接一台 redis 服务器
    private static Jedis jedis;
    // 2 主从，哨兵 使用 shard 在3.0后不再使用
    private static ShardedJedis shard;
    // 3 连接池
    private static ShardedJedisPool pool;


    @BeforeClass
    public static void setUpBeforeClass() throws Exception{
        jedis = new Jedis("47.102.205.233",6379);
        jedis.auth("root");

        List<JedisShardInfo> shards = Arrays.asList(new JedisShardInfo("47.102.205.233", 6379));
        shard = new ShardedJedis(shards);
        GenericObjectPoolConfig goConfig = new GenericObjectPoolConfig();
        goConfig.setMaxTotal(100);
        goConfig.setMaxIdle(20);
        goConfig.setMaxWaitMillis(-1);
        goConfig.setTestOnBorrow(true);
        pool = new ShardedJedisPool(goConfig,shards);
    }

    @AfterClass
    public static void tearDownAfterClass() throws Exception{
        jedis.disconnect();
        shard.disconnect();
        pool.destroy();
    }

    @Test
    public void testMap(){
        HashMap<String, String> map = new HashMap<>();
        map.put("name","xinxin");
        map.put("age","22");
        map.put("qq","123456");
        jedis.hmset("user",map);

        // 取出 user 中 name ，执行结果 [minxr] -->  注意结果是一个泛型的list
        // 第一个参数是存入 redis 中 map 对象的key，后面跟的是放入 map 中的对象 key，后面的 key 可以跟多个，是可变参数
        List<String> rsmap = jedis.hmget("user", "name", "age", "qq");
        System.out.println(rsmap);

        // 删除某个值
        //        jedis.hdel("user","age");

    }

    @Test
    public void testSel(){
        System.out.println(jedis.hmget("user","age"));
        System.out.println(jedis.hlen("user"));
        System.out.println(jedis.exists("user"));
        System.out.println(jedis.hkeys("user"));
        System.out.println(jedis.hvals("user"));

        Iterator<String> iter = jedis.hkeys("user").iterator();
        while (iter.hasNext()){
            String key = iter.next();
            System.out.println(key+":"+jedis.hmget("user",key));
        }
    }

    @Test
    public void testList(){
        // 删除所有
        jedis.del("java framework");
        jedis.lpush("java framework","spring");
        jedis.lpush("java framework","struts");
        jedis.lpush("java framework","hibernate");
        // 再取出所有数据 jedis.lrange 是按范围取出
        // 第一个是 key，第二个是起始位置，第三个是结束为止，jedis.llen 获取长度 -1 表示获取所有
        System.out.println(jedis.lrange("java framework",0,-1));

        jedis.del("java framework");
        jedis.rpush("java framework","spring");
        jedis.rpush("java framework","struts");
        jedis.rpush("java framework","hibernate");
        System.out.println(jedis.lrange("java framework",0,-1));
    }

    @Test
    public void testSet(){
        jedis.sadd("name","xiang");
        jedis.sadd("name","xinxin");
        jedis.sadd("name","ling");
        jedis.sadd("name","zhang");
        jedis.sadd("name","who");
        jedis.sadd("name","hello");

        // 移除
        jedis.srem("name","who");
        // 获取所有加入的 value
        System.out.println(jedis.smembers("name"));
        // 判断 who 是否存在 user 集合里
        System.out.println(jedis.sismember("name","who"));
        // 随机返回一个数
        System.out.println(jedis.srandmember("name"));
        // 返回集合的元素个数
        System.out.println(jedis.scard("name"));
    }
}
```



## 8、JavaAPI （二）设计

创建自己的索引规则，把查询规则建立后，在创建 hash 的同时，创建 set 集合，用来存储查询的key，这样可以快速的查询到 key ，通过key 在 hash 表里获取到值，这里拿了交集来举例

```java
public class TestRedis2 {
    final String SYS_USER_TABLE = "SYS_USER_TABLE";
    final String SYS_USER_SEL_AGE_25 = "SYS_USER_SEL_AGE_25";
    final String SYS_USER_SEL_SEX_m = "SYS_USER_SEL_SEX_m";
    final String SYS_USER_SEL_SEX_w = "SYS_USER_SEL_SEX_w";

    @Test
    public void test() {
        Jedis j = new Jedis("47.102.205.233", 6379);
        j.auth("root");



        HashMap<String, String> map = new HashMap<>();
        // 把 User 对象放入缓存数据中去
        String uuid = UUID.randomUUID().toString();
        User u1 = new User(uuid,"z3",28,"m");
        map.put(uuid, JSON.toJSONString(u1));
        j.sadd(SYS_USER_SEL_SEX_m,uuid);

        String u2id = UUID.randomUUID().toString();
        User u2 = new User(u2id,"z7",25,"m");
        map.put(u2id,JSON.toJSONString(u2));
        j.sadd(SYS_USER_SEL_AGE_25,u2id);
        j.sadd(SYS_USER_SEL_SEX_m,u2id);

        String u3id = UUID.randomUUID().toString();
        User u3 = new User(u3id,"w5",25,"w");
        map.put(u3id,JSON.toJSONString(u3));
        j.sadd(SYS_USER_SEL_AGE_25,u3id);
        j.sadd(SYS_USER_SEL_SEX_w,u3id);

        String u4id = UUID.randomUUID().toString();
        User u4 = new User(u4id,"z4",29,"m");
        map.put(u4id,JSON.toJSONString(u4));
        j.sadd(SYS_USER_SEL_SEX_m,u4id);


        String u5id = UUID.randomUUID().toString();
        User u5 = new User(u5id,"w6",28,"w");
        map.put(u5id,JSON.toJSONString(u5));
        j.sadd(SYS_USER_SEL_SEX_w,u5id);

        j.hmset("SYS_USER_TABLE",map);
    }



    @Test
    // 查询 男
    public void testSel(){
        Jedis j = new Jedis("47.102.205.233", 6379);
        j.auth("root");

        Set<String> user_sel = j.smembers(SYS_USER_SEL_SEX_m);
        for (String s : user_sel) {
            System.out.println(s);
            String ret = j.hget(SYS_USER_TABLE, s);
            System.out.println(ret);
        }
    }


    @Test
    // 25 和 男 交集
    public void testSel1(){
        Jedis j = new Jedis("47.102.205.233", 6379);
        j.auth("root");
        Set<String> sinter = j.sinter(SYS_USER_SEL_AGE_25, SYS_USER_SEL_SEX_m);
        for (String s : sinter) {
            System.out.println(s);
            String ret = j.hget(SYS_USER_TABLE, s);
            System.out.println(ret);
            User user = JSON.parseObject(ret, User.class);
            System.out.println(user);
        }
    }
}
```



## 9、哨兵

有了主从复制的实现后，我们如果想要对主机从服务器进行监控，那么在 redis 2.6 以后提供了一个哨兵 的机制，在2.6版本中的哨兵为  1.0 版本，并不稳定，会出现各种问题，在2.8以后的版本 哨兵才稳定起来。

顾名思义，哨兵的含义就是监控 Redis 系统的运行状况，其主要功能有 两 点：

1. 监控主数据库和从数据是否正常运行
2. 主数据库出现故障时，可以自动将从数据库切换为主数据库，实现自动切换

实现 步骤：

1. 在其中一台服务器 配置 ==sentinel.conf==   A 服务器IP

2. copy 文件 sentinel.conf 到  usr/local/redis/etc 中

3. 修改 sentinel.conf 文件：

     > sentine monitor ==mymaster 【ip地址】 【端口号】==   # 名称 、 ip 、 端口 ，投票选举次数
     >
     > sentinel down-after-milliseconds ==mymaster== 5000 # 默认 1s 检测一次，这里配置超时 5000 毫秒为宕机
     >
     > sentinel failover-timeout ==mymaster== 900000
     >
     > sentinel can-failover ==mymaster== yes
     >
     > sentinel paraller-syncs ==mymaster== 2

4. 启动 sentinel 哨兵

     ```
     /usr/local/redis/bin/redis-server /usr/local/redis/etc/sentinel.conf --sentinel &
     ```

5. 查看哨兵相关信息命令

     ```
     /usr/local/redis/bin/redis-cli -h 【A服务器 IP】 -p 26379 info Sentinel
     ```

6. 关闭主服务器查看集群信息

     ```
     /usr/local/redis/bin/redis-cli -h 【从服务器 IP】 -p 6379 shutdown
     ```

     

