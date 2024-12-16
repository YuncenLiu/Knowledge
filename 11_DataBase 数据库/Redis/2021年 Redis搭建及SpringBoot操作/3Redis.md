## 1、Redis 集群搭建

​	在 redis 3.0 以前，提供了  Sentinel 工具来监控各 Master 状态，如果 Master异常。则会主从切换，将 slave 作为 master ，将 mastr 作为 slave。其配置也是稍微的复杂，并且各个方面表现一般，现在 redis 3.0 已经支持集群的容错功能，并且非常简单

### 1.1、搭建集群

> 集群搭建：至少要三个 master

##### 第一步：创建一个文件夹  redis-cluster，然后在其下面分别创建 6 个文件夹

+ ```sh
     mkdir -p /usr/local/redis-cluster
     ```

+ ```sh
     mkdir 7001 
     mkdir 7002
     mkdir 7003
     mkdir 7004 
     mkdir 7005
     mkdir 7006  （教程这个地方，是在一台服务器上，创建了6个redis的做法，如果是不同服务器，不需要这样）
     ```

![image-20200802193524119](images/redis%20%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.png)

#####  第二步：把之前的 redis.conf 配置文件分别copy到 ==700*== 下面，进行修改各个文件内容，也就是对  ==700*==   下的每个 copy 的 redis.conf  文件进行修改！如下：

+ daemonize   yes
+ ==port 700*  （分别对每个机器的端口进行设置）==
+ ==bind  IP （必须要绑定当前机器的 ip，不然会无限悲剧下去哇....  深坑勿入！！）==
+ ==dir /usr/local/redis-cluster/700*/  （指定数据文件存放位置，必须要指定不同的目录，不然会丢失数据，深坑勿入！！）==
+ ==cluster-enabled yes （启动集群模式，开始玩耍）==
+ ==cluster-config-file nodes700*.conf（这里最好是 700x 和port 对应上）==
+ cluster-node-timeout 5000
+ appendonly yes

##### 第三步：把修改后的配置文件，分别copy 到各个文件夹下，注意，每个文件要修改端口号，并且 nodes 文件也要相同！ ==（就是我们刚刚改的文件夹，已经改好了）==

##### 第四步：由于 redis 集群需要使用 ruby 命令，所以我们需要安装 ruby

```sh
yum install ruby
yum install rubygems
gem install redis (安装 redis 和 ruby 的接口)
```

会出现  gem install redis (安装 redis 和 ruby 的接口)  失败的问题

[升级ruby](https://blog.csdn.net/wildwolf_001/article/details/107672073)

[下载RVM](https://blog.csdn.net/Wjhsmart/article/details/85290474)

##### 第五步：分别启动 6 个 redis 实例，然后检查是否启动成功

```sh
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7001/redis.conf
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7002/redis.conf
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7003/redis.conf
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7004/redis.conf
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7005/redis.conf
/usr/local/redis/bin/redis-server  /usr/local/redis-cluster/7006/redis.conf
```

![image-20200802193850618](images/redis%20%E5%90%AF%E5%8A%A8.png)

##### 第六步：首先到 redis 3.0 安装目录下，然后执行  `redis-trib.rb`  命令                     ==最后的集群操作==

+ cd /usr/local/redis3.0/src

+ ./redis-trib.rb  create --replicas 1 【IP1】【IP2】【IP3】【IP4】【IP5】【IP6】  ==这里的1 指的是   （主节点   /    从节点 = 1）==

     + ​	确认：

     ![image-20200802194520761](images/redis%20%E5%90%AF%E5%8A%A82.png)

     + ![image-20200802194741267](images/redis%20%E5%90%AF%E5%8A%A83.png)



##### 第七步：到此为止我们集群搭建成功！进行验证

1. 连接任意一个客户端即可： 

     ```
     ./redis-cli -c -h -p -a root 
     c 代表集群模式，指定 ip 地址和端口号
     比如：    ./redis-cli -c -h 192.168.1.1.121 -p 7001
     ```

2. 进行验证：==cluster info==（查看集群消息）、==cluster nodes==（查看节点列表）

3. 进行数据操作验证

4. 关闭集群则需要逐个进行关闭，使用命令：

     ```
     redis-cli -c -h 192.168.1.171 -p 700X shutdown
     ```

##### 第八步：（补充）

> 当出现集群无法启动时，删除临时的数据文件，再次重新启动每个 redis 服务，然后重新构造集群环境

当我们登录  7001 的客户端的时候，set 一个值，他会告诉你放在那个曹里，不一定是在 7001 他是一个整体的环境，可能  主2  也可能是 主3



==要取消集群的话，把  7001-7006  文件下的  nodes-700X.conf 全部删掉==  不然就会创建失败

## 2、Redis 集群 JavaAPI

```java
public class TestClusterRedis {

    @Test
    public void test(){
        Set<HostAndPort> jedisClusterNode = new HashSet<>();
        jedisClusterNode.add(new HostAndPort("",6379));
        jedisClusterNode.add(new HostAndPort("",6379));
        jedisClusterNode.add(new HostAndPort("",6379));
        jedisClusterNode.add(new HostAndPort("",6379));
        jedisClusterNode.add(new HostAndPort("",6379));
        jedisClusterNode.add(new HostAndPort("",6379));
        JedisPoolConfig cfg = new JedisPoolConfig();
        cfg.setMaxTotal(100);
        cfg.setMaxIdle(20);
        cfg.setMaxWaitMillis(-1);
        cfg.setTestOnBorrow(true);
        JedisCluster jc = new JedisCluster(jedisClusterNode, 6000, 100, cfg);
		// 100 最大重定向此时
        jc.set("name", "zs");
        
        jc.close();
    }
}
```