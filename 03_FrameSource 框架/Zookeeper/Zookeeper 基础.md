## 1、Zookeeper 简介

​		Zookeeper 是一个高效的分布式协调服务，它暴露了一些公共服务，比如命名 / 配置管理 / 同步控制 /  群组服务 等。我们可以使用 ZK 来实现比如打成共识 /  集群管理 / leader 选举等。

​		Zookeeper 是一个高可用的分布式管理与协调框架，基于 ZAB 算法（原子消息广播协议）的实现。该框架能够很好的保证分布式环境中数据的一致性。也正是基于这样的特性，使得 Zookeeper 成为了解决分布式一致性问题的利器。

+ 顺序一致性：从一个客户端发起的事务请求，最终将会严格地按照发起的顺序被应用到 zookerper 中去
+ 原子性：所有事务请求的处理结果在整个集群中所有机器上的应用情况是一致的，也就是说，要么整个集群所有机器都成功用了某一个事务，要么都没有应用，一定不会出现部分机器应用了该事务，而另一个部分没哟应用的情况。
+ 单一视图：无论客户连接的是哪一个 zookeeper 服务器，其他看到服务器端数据模型都是一样的
+ 可靠性：一旦服务器成功地应用到了一个事务，并完成对客户端的响应，那么该事务所引起服务器端状态将会被一致性保留下来。除非有另一个事务对其更改。
+ 实时性：通常所说的实时性就是指一旦事务被成功应用，那么客户端就能立刻从服务器上获取变更后的数据，zookeeper 仅仅能保证在一段时间内，客户端最终一定能从服务器端读取到最新的数据状态

​		

### 1.1、Zookeeper 组成

ZK server 根据其自身份特性分为三种  leader、Follower、Observer（==可以理解为java操作 ZK==），其中 Follower 和 Observer 又统称Leamer（学习者）

+ Leader：负责客户端 Writer 类型请求
+ Follower：负责客户端的 reader 类型请求，参与 leader 选举等
+ Observer：特殊的 Follower，其可以接受客户端reader 请求，但不参与选举

扩容系统支撑能力，提供了读取速度，因为它不接受任何同步的写入请求，只负责leader 同步数据

### 1.2、Zookeeper 应用场景

Zookeeper 从设计模式角度来看，是一个基于观察者模式设计的分布式服务管理框架，它负责存储和管理大家都关心的数据，然后接受观察者的注册，一旦这些数据的状态发生了变化，Zookeeper 就将负责通知已经在 Zookeeper 上注册的那些观察者做出相对反应，从而实现集群中类似于 Master / Slave 管理模式

+ 配置管理
+ 集群管理
+ 发布与订阅
+ 数据库切换
+ 分布式日志的收集
+ 分布式锁、队列管理等

### 1.3、配置管理

配置的管理在分布式应用环境中很常见，比如我们在平常的应用系统中，经常会碰到这样的需求：如机器的配置列表、运行时的开关配置、数据库配置信息等。这些完全配置信息通常刚具备3个特性：

+ 数据量比较小
+ 数据内容在运行时动态发生改变
+ 集群中各个节点共享信息，配置一致

### 1.4、集群管理

ZK 不仅能帮你维护当前的集群中机器的服务器状态，而且能够帮你筛选出一个“总管”，这个总管帮你管理集群，这就是 Zookeeper 的另一个功能，Leader ，并且实现集群容错的功能

+ 希望知道当前集群中究竟有多少机器在工作
+ 对集群中每天集群的运行时状态进行数据收集
+ 对集群中每台集群进行上下线操作

### 1.5、发布与订阅

ZK 是一个典型的发布 / 订阅模式的分布式数控管理与协调框架，开发人员可以用他来进行分步式数据的发布与订阅



## 2、Zookeeper 安装环境

1. 在三个节点上进行操作

2. 解压到

     ```shell
     tar -zxvf -C zookeeper-3.4.5.tar.gz -C /usr/local/
     ```

3. 重命名

     ```shell
     mv zookeeper-3.4.5 zookeeper
     ```

4. 修改环境变量

     ```shell
     vi /etc/profile
     # Zookeeper
     export JAVA_HOME=/usr/java/jdk1.8.0_121/jre
     export ZOOKEEPER_HOME=/usr/local/zookeeper
     export PATH=.:$JAVA_HOME/bin:$ZOOKEEPER_HOME/bin:$PATH
     ```

5. 刷新

     ```
     source /etc/profile
     ```

6. 到 Zookeeper 下修改配置文件

     ```shell
     cd /usr/local/zookeeper/conf
     mv zoo_sample.cfg zoo.cfg
     ```

7. 修改 conf

     ```sh
     vi zoo.cfg 
     # 修改两处
     # (1) dataDir=/usr/local/zookeeper/data
     # (2) 最后添加
     # 		server.0=ip:2888:3888
     # 		server.1=ip1:2888:3888
     # 		server.2=ip2:2888:3888
     ```

8. 服务器标识配置

     ```shell
     # 创建文件夹
     mkdir data
     # 创建文件 myid 并且填写内容为 0
     
     # 在 ip  服务器上，写的是 0
     # 在 ip1 服务器上，写的是 1
     # 在 ip2 服务器上，写的是 2   这里对应的是 上面的 server.编号  里面的编号
     
     vi myid
     # 内容为 0
     ```

9. 运行客户端

     ```
     zkCli.sh
     ```

10. 建议使用工具打开

     1. [下载工具](https://issues.apache.org/jira/secure/attachment/12436620/ZooInspector.zip)
     2. java -jar 里面的 jar包

### 2.1、Zookeeper 操作 Shell

zkCli.sh  进入 Zookeeper 客户端

+ 查找  : ls /     ls /zookeeper
+ 创建并赋值  : create          create /xiang good
+ 获取：get    get   /xiang
+ 设值：set     set  /xiang ok
+ 递归删除节点 ：rmr        rmr  /path
+ 删除某个指定节点：delete      delete   /path/child

创建节点有两个类型：短暂（ephemeral)    持久(persistent)



### 2.2、zoo.cfg 详解

+ tickTime：基本事件单元，以毫秒为单位。这个时间是作为 Zookeeper 服务器之间或客户端与服务器之间维持心跳的时间间隔，也就是每隔  tickTime 时间就会发送一个心跳
+ dataDir：存储内存中数据库快照的位置，顾名思义就是 Zookeeper 保存数据的目录，默认情况下，Zookeeper 将写数据的日志也保留在这个目录里
+ clientPort：这个端口是客户端连接 Zookeeper 服务器的端口，Zookeeper 会监听这个端口，接受客户端的访问请求
+ initLimit：这个配置项是用来配置 Zookeeper 接受客户端初始化连接时，最长能忍受多少个心跳时间间隔，当已经超过 10 个心跳的时间（也就是 tickTIme）长度后 Zookeeper服务器还没收到客户端的返回信息，就表示这个客户端连接失败。总的时间长度就是 10 *2000 = 20秒
+ ==syncLimit：这个配置项标识Leader 与 Follower 之间发送信息，请求和应答时间长度，最长不能超过多少个 tickTIme 的时间长度，总的时长就是 5 * 2000 = 10秒==
+ server . A = B : C : D
     + A：表示这是几号服务器
     + B：表示这个服务器的 ip 地址
     + C：表示的是这个服务器与集群中的 Leader 服务器交换信息端口
     + D：表示的是万一集群中 Leader 服务器挂了，需要一个端口来重新进行选举，选出一个新的 Leader



## 3、Java 操作 zookeeper

  首先要使用 java 操作 Zookeeper，Zookeeper的 javaclient 使我们更轻松的去对 Zookeeper 进行各种朝着，我们引入  Zookeeper-3.4.5.jar 和 zkclient-0.1.jar 即可

+ Zookeeper（Arguments）方法（一共有4个构造方法，根据参数不同）
     + connectString：连接服务器列表，已 ”，“分割
     + sessionTimeOut：心跳检测时间周期（毫秒）
     + wather：事件处理通知器
     + canBeReadOnly：标识当前会话是否支持只读
     + sessionId 和 sessionPasswd：提供连接 Zookeeper 的 sessionId 和密码，通过两个确定唯一一台客户端，目的是可以重复提交会话

> 注意：Zookeeper 客户端和服务器端会话的建立是一个异步的过程，也就是说在程序中，我们程序方法在处理客户端初始化立即返回（也就说程序往下执行代码，这样，大多数情况下我们并没有真正构建好一个可用的会话，在会话的声明周期处于  “CONNECTING” 时才算真正建立完毕，所以我们需要使用多线程所学习的一个小工具类）



### 3.1、zkClient使用（一）

ZKClient 是有Datameer 的工程师 StefanGroschupf 和 Peter Voss 一起开发的，在源生API 接口基础上进行了疯张，简化了 ZK的复杂性

1. 创建客户端的方法：ZKclient（Arguments）

     1. zkServers zookeeper 服务器地址，用    ","  分割
     2. session Timeout 超时会话，为毫秒，默认是  30 000ms
     3. connection Timeout 连接超时会话
     4. IZkConnection 接口的实现类
     5. zkSerializer 自定义序列化实现

2. 创建节点方法：

     > create、createEphemeral、createEphemeralSequential、createPersistent、createPersistenSequential

     1. path：路径
     2. data：数据内容、可以传入 null
     3. mode：节点类型，为一个枚举类型，4种形式
     4. acl策略
     5. callback：回调函数
     6. context：上下文对象
     7. createParents：是否创建父节点

3. 删除节点方法：

     > delete、deleteRecursive

     1. path：路径
     2. callback：回调函数
     3. context：上下文对象

4. 读取子节点数据方法

     > getChildren

     1. path：路径

5. 读取节点数据方法

     > readData

     1. path：路径
     2. returnNullfPathNodeExists（避免为空节点抛出异常，直接返回null）
     3. 节点状态

6. 更新数据方法 writeData

     1. path：路径
     2. data：数据信息
     3. version：版本号

7. 检测节点是否存在方法 exists

     1. path：路径

### 3.2、zkClient使用（二）

​	subscribeChildChanges 方法

1. path：路径
2. 实现了 IZkChildListener 

```java
public class ZkClientBase {

	/** zookeeper地址 */
	static final String CONNECT_ADDR = "47.102.205.233:2181";
	/** session超时时间 */
	static final int SESSION_OUTTIME = 5000;//ms 
	
	
	public static void main(String[] args) throws Exception {
		ZkClient zkc = new ZkClient(new ZkConnection(CONNECT_ADDR), 5000);
		//1. create and delete方法 
		zkc.createEphemeral("/temp");
		zkc.createPersistent("/super/c1", true);
		Thread.sleep(10000);
		zkc.delete("/temp");
		zkc.deleteRecursive("/super");
		
		//2. 设置path和data 并且读取子节点和每个节点的内容
//		zkc.createPersistent("/super", "1234");
//		zkc.createPersistent("/super/c1", "c1内容");
//		zkc.createPersistent("/super/c2", "c2内容");
//		List<String> list = zkc.getChildren("/super");
//		for(String p : list){
//			System.out.println(p);
//			String rp = "/super/" + p;
//			String data = zkc.readData(rp);
//			System.out.println("节点为：" + rp + "，内容为: " + data);
//		}
		
		//3. 更新和判断节点是否存在
//		zkc.writeData("/super/c1", "新内容");
//		System.out.println(zkc.readData("/super/c1"));
//		System.out.println(zkc.exists("/super/c1"));
		
		//4.递归删除/super内容
//		zkc.deleteRecursive("/super");		
	}
}

```

1. 创建一个已有的节点，会创建失败
2. 没有父节点，就创建下的子节点，会创建失败
3. CreateMode.EPHEMERAL  创建临时节点，本次会话有效，会话关闭就取消

###  3.3、==zkClient 使用（三）==

```java
static final String CONNECT_ADDR = "47.102.205.233:2181";
static final int SESSION_OUTTIME = 5000;

public static void main(String[] args) throws Exception {
   ZkClient zkc = new ZkClient(new ZkConnection(CONNECT_ADDR), SESSION_OUTTIME);
}
```

+ zkc.createEphemeral("/temp");    创建节点

+ zkc.createPersistent("/super/c1", true);    迭代创建节点

+ zkc.delete("/temp");         删除节点

+ zkc.deleteRecursive("/super");   直接删除父节点

+ zkc.createPersistent("/super/c1", "c1内容");   添加子节点，并且设置内容

+ 打印 子节点  信息

     ```java
     for(String p : list){
        System.out.println(p);
        String rp = "/super/" + p;
        String data = zkc.readData(rp);
        System.out.println("节点为：" + rp + "，内容为: " + data);
     }
     ```

+ zkc.writeData("/super/c1", "新内容");   在该节点，设置新内容

+ Object o = zkc.readData("/super/c1");   获取该节点信息， 输出 o 即可显示

+ boolean exists = zkc.exists("/super/c1");   返回该节点是否存在， 返回 true / false

### 3.4、==zkClient 使用（四）==

我没发现，ZkClient 里面并没有类似的 watcher、watch 参数，这样就说我们开发人员无需再关心反复注册 watcher 的问题了， zkclient 给我们提供了一套监听方式，我们可以使用监听节点的方式进行操作，剔除了繁琐的反复 watcher 操作，简化了代码的负责程度

==*subscribeChildChanges*==  方法

参数1：path 路径

参数2：实现了 IZkChildListener 接口的类

只需要重写其 handlerChildChanges（String parentPath，List<String> currentChilds）方法。其中 参数 parentPath 为所监听节点全路径，currentChilds 为最新的子节点列表（相对路径）IZkChilListener 事件说明针对以下三个事件触发

新增子节点、减少子节点、删除节点

```
zkc.subscribeChildChanges("/super", new IZkChildListener() {
   @Override
   public void handleChildChange(String parentPath, List<String> currentChilds) throws Exception {
      System.out.println("parentPath: " + parentPath);
      System.out.println("currentChilds: " + currentChilds);
   }
});
```

以上代码 自动对 ==*/super*== 节点进行监控，只要出现 新增子节点、减少子节点、删除节点  就监控输出

### 3.4、java操作 Zookeeper

创建节点（node）方法 create：

提供了两套创建节点的方法，同步和异步创建方式

同步方式：

+ 参数1，节点路径（名称）：/nodeName （不允许递归创建节点，也就是说父节点不存在的情况下，不允许创建子节点）
+ 参数2，节点内容，要求类型是字节数组（也就是说，不支持序列化方式，如果需要实现序列化，可以使用java相关序列化框架，如Jessian，Kryo框架
+ 参数3，节点权限，使用Ids.OPEN_ACI_UNSAFE 开放权限即可。（这个参数一般在权限没有太高要求的情况下，没有必要关注）
+ 参数4，节点类型，创建节点的类型，CreateMode .* 提供四种节点类型
     + PERSISTENT（持久节点）
     + PERSISTENT_SEQUENTIAL（持久顺序节点）
     + EPHEMERAL（临时节点）
     + EPHEMERAL_SEQUENTIAL（临时顺序节点）

异步方式（在同步参数基础上增加两个参数）

+ 参数5，注册一个异步回调函数，要实现AsyncallBack，StringCallBack接口，重写ProcessResult（int rc,String path,Object ctx,String name)方法，当节点创建完毕后执行此方法
     + rc：为服务器响应码 0 表示调用成功，-4表示端口连接，-110表示指定节点存在，-112表示会话已经过期
     + path：调用接口时传入API 的数据节点的路径参数
     + ctx：为调用接口传入API的ctx值
     + name：实际上在服务器端创建节点的名称
+ 参数6，传递给回调函数一个参数，一般为上下文（Context）信息

### 3.5、Watcher、ZK状态、事件类型

​	zookeeper 有 watch 事件，是一次性触发的，当watch监视的数据发生改变时，通知设置了该 watch 的client，即watcher

​	同样，其 watcher 是监听数据发生了某些变化，那就一定会有对应的事件类型。和状态类型。

+ 事件类型：（znode节点相关的）
     + EventType.NodeCreated  （节点创建）
     + EventType.NodeDataChange （数据变更）
     + EventType.NodeChildrenChanged （子节点变更）
     + EventType.NodeDeleted  （节点删除）
+ 状态类型：（是跟客户端实例相关的）
     + KeeperState.Disconnected		（非连接）
     + KeeperState.SyncConnected    （连接成功）
     + KeeperState.AuthFailed    （失败）
     + KeeperState.Expired    （过期）

### 3.6、Watcher

> watcher 的特性：一次性、客户端串行执行、轻量

+ 一次性：对于ZK 的watcher，只需要记住一点，zookeeper 有 watch 事件，是一次性触发的，当watch 监视的数据发生变化时，通知设置了该wathch 的 client，即 watcher，由于zookeeper 的监控都是一次性的，所以每次必须设置监控
+ 客户端串行执行：客户端 Watcher 回调的过程是一个串行同步的过程，这为我们保证了顺序，同时需要开发人员注意一点，千万不要因为 一个 Watcher 的处理逻辑影响了整个客户端的 Watcher 回调
+ 轻量：watcherEvent 是 Zookeeper 整个 Watcher 通知机制的最小通知单元，整个结构只包含了三个部分，通知状态、事件类型和节点路径，需要客户自己去获取，比如 NdeDataChanged 事件，Zookeeper 只会通知客户端指定节点的数据发生了变更，而不会直接提供具体的数据内容

```java
public class ZooKeeperWatcher implements Watcher {

   /** 定义原子变量 */
   AtomicInteger seq = new AtomicInteger();
   /** 定义session失效时间 */
   private static final int SESSION_TIMEOUT = 10000;
   /** zookeeper服务器地址 */
   private static final String CONNECTION_ADDR = "47.102.205.233:2181,47.107.189.111:2181,123.56.0.183:2181";
   /** zk父路径设置 */
   private static final String PARENT_PATH = "/p";
   /** zk子路径设置 */
   private static final String CHILDREN_PATH = "/p/c";
   /** 进入标识 */
   private static final String LOG_PREFIX_OF_MAIN = "【Main】";
   /** zk变量 */
   private ZooKeeper zk = null;
   /**用于等待zookeeper连接建立之后 通知阻塞程序继续向下执行 */
   private CountDownLatch connectedSemaphore = new CountDownLatch(1);

   /**
    * 创建ZK连接
    * @param connectAddr ZK服务器地址列表
    * @param sessionTimeout Session超时时间
    */
   public void createConnection(String connectAddr, int sessionTimeout) {
      this.releaseConnection();
      try {
         //this表示把当前对象进行传递到其中去（也就是在主函数里实例化的new ZooKeeperWatcher()实例对象）
         zk = new ZooKeeper(connectAddr, sessionTimeout, this);
         System.out.println(LOG_PREFIX_OF_MAIN + "开始连接ZK服务器");
         connectedSemaphore.await();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   /**
    * 关闭ZK连接
    */
   public void releaseConnection() {
      if (this.zk != null) {
         try {
            this.zk.close();
         } catch (InterruptedException e) {
            e.printStackTrace();
         }
      }
   }

   /**
    * 创建节点
    * @param path 节点路径
    * @param data 数据内容
    * @return 
    */
   public boolean createPath(String path, String data, boolean needWatch) {
      try {
         //设置监控(由于zookeeper的监控都是一次性的所以 每次必须设置监控)
         this.zk.exists(path, needWatch);
         System.out.println(LOG_PREFIX_OF_MAIN + "节点创建成功, Path: " + 
                        this.zk.create( /**路径*/ 
                                        path, 
                                        /**数据*/
                                        data.getBytes(), 
                                        /**所有可见*/
                                        Ids.OPEN_ACL_UNSAFE, 
                                        /**永久存储*/
                                        CreateMode.PERSISTENT ) +  
                        ", content: " + data);
      } catch (Exception e) {
         e.printStackTrace();
         return false;
      }
      return true;
   }

   /**
    * 读取指定节点数据内容
    * @param path 节点路径
    * @return
    */
   public String readData(String path, boolean needWatch) {
      try {
         System.out.println("读取数据操作...");
         return new String(this.zk.getData(path, needWatch, null));
      } catch (Exception e) {
         e.printStackTrace();
         return "";
      }
   }

   /**
    * 更新指定节点数据内容
    * @param path 节点路径
    * @param data 数据内容
    * @return
    */
   public boolean writeData(String path, String data) {
      try {
         System.out.println(LOG_PREFIX_OF_MAIN + "更新数据成功，path：" + path + ", stat: " +
                        this.zk.setData(path, data.getBytes(), -1));
      } catch (Exception e) {
         e.printStackTrace();
         return false;
      }
      return true;
   }

   /**
    * 删除指定节点
    * 
    * @param path
    *            节点path
    */
   public void deleteNode(String path) {
      try {
         this.zk.delete(path, -1);
         System.out.println(LOG_PREFIX_OF_MAIN + "删除节点成功，path：" + path);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   /**
    * 判断指定节点是否存在
    * @param path 节点路径
    */
   public Stat exists(String path, boolean needWatch) {
      try {
         return this.zk.exists(path, needWatch);
      } catch (Exception e) {
         e.printStackTrace();
         return null;
      }
   }

   /**
    * 获取子节点
    * @param path 节点路径
    */
   private List<String> getChildren(String path, boolean needWatch) {
      try {
         System.out.println("读取子节点操作...");
         return this.zk.getChildren(path, needWatch);
      } catch (Exception e) {
         e.printStackTrace();
         return null;
      }
   }

   /**
    * 删除所有节点
    */
   public void deleteAllTestPath(boolean needWatch) {
      if(this.exists(CHILDREN_PATH, needWatch) != null){
         this.deleteNode(CHILDREN_PATH);
      }
      if(this.exists(PARENT_PATH, needWatch) != null){
         this.deleteNode(PARENT_PATH);
      }     
   }
   
   /**
    * 收到来自Server的Watcher通知后的处理。
    */
   @Override
   public void process(WatchedEvent event) {
      
      System.out.println("进入 process 。。。。。event = " + event);
      
      try {
         Thread.sleep(200);
      } catch (InterruptedException e) {
         e.printStackTrace();
      }
      
      if (event == null) {
         return;
      }
      
      // 连接状态
      KeeperState keeperState = event.getState();
      // 事件类型
      EventType eventType = event.getType();
      // 受影响的path
      String path = event.getPath();
      //原子对象seq 记录进入process的次数
      String logPrefix = "【Watcher-" + this.seq.incrementAndGet() + "】";

      System.out.println(logPrefix + "收到Watcher通知");
      System.out.println(logPrefix + "连接状态:\t" + keeperState.toString());
      System.out.println(logPrefix + "事件类型:\t" + eventType.toString());

      if (KeeperState.SyncConnected == keeperState) {
         // 成功连接上ZK服务器
         if (EventType.None == eventType) {
            System.out.println(logPrefix + "成功连接上ZK服务器");
            connectedSemaphore.countDown();
         } 
         //创建节点
         else if (EventType.NodeCreated == eventType) {
            System.out.println(logPrefix + "节点创建");
            try {
               Thread.sleep(100);
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         } 
         //更新节点
         else if (EventType.NodeDataChanged == eventType) {
            System.out.println(logPrefix + "节点数据更新");
            try {
               Thread.sleep(100);
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         } 
         //更新子节点
         else if (EventType.NodeChildrenChanged == eventType) {
            System.out.println(logPrefix + "子节点变更");
            try {
               Thread.sleep(3000);
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         } 
         //删除节点
         else if (EventType.NodeDeleted == eventType) {
            System.out.println(logPrefix + "节点 " + path + " 被删除");
         }
         else ;
      } 
      else if (KeeperState.Disconnected == keeperState) {
         System.out.println(logPrefix + "与ZK服务器断开连接");
      } 
      else if (KeeperState.AuthFailed == keeperState) {
         System.out.println(logPrefix + "权限检查失败");
      } 
      else if (KeeperState.Expired == keeperState) {
         System.out.println(logPrefix + "会话失效");
      }
      else ;

      System.out.println("--------------------------------------------");

   }

   /**
    * <B>方法名称：</B>测试zookeeper监控<BR>
    * <B>概要说明：</B>主要测试watch功能<BR>
    * @param args
    * @throws Exception
    */
   public static void main(String[] args) throws Exception {

      //建立watcher //当前客户端可以称为一个watcher 观察者角色
      ZooKeeperWatcher zkWatch = new ZooKeeperWatcher();
      //创建连接 
      zkWatch.createConnection(CONNECTION_ADDR, SESSION_TIMEOUT);
      //System.out.println(zkWatch.zk.toString());
      
      Thread.sleep(1000);
      
      // 清理节点
      zkWatch.deleteAllTestPath(false);
      
      //-----------------第一步: 创建父节点 /p ------------------------//
      if (zkWatch.createPath(PARENT_PATH, System.currentTimeMillis() + "", true)) {
         
         Thread.sleep(1000);
         
         //-----------------第二步: 读取节点 /p 和    读取/p节点下的子节点(getChildren)的区别 --------------//
         // 读取数据
         zkWatch.readData(PARENT_PATH, true);
      
         // 读取子节点(监控childNodeChange事件)
         zkWatch.getChildren(PARENT_PATH, true);

         // 更新数据
         zkWatch.writeData(PARENT_PATH, System.currentTimeMillis() + "");
         
         Thread.sleep(1000);
         // 创建子节点
         zkWatch.createPath(CHILDREN_PATH, System.currentTimeMillis() + "", true);
         
         
         //-----------------第三步: 建立子节点的触发 --------------//
//       zkWatch.createPath(CHILDREN_PATH + "/c1", System.currentTimeMillis() + "", true);
//       zkWatch.createPath(CHILDREN_PATH + "/c1/c2", System.currentTimeMillis() + "", true);
         
         //-----------------第四步: 更新子节点数据的触发 --------------//
         //在进行修改之前，我们需要watch一下这个节点：
         Thread.sleep(1000);
         zkWatch.readData(CHILDREN_PATH, true);
         zkWatch.writeData(CHILDREN_PATH, System.currentTimeMillis() + "");
         
      }
      
//    Thread.sleep(10000);
      // 清理节点
//    zkWatch.deleteAllTestPath(false);
      
      
      Thread.sleep(10000);
      zkWatch.releaseConnection();
      
   }

}
```

### 3.7、ACL（AUTH）

ACL（Access Control List），Zookeeper 作为一个分布式协调框架，其内部存储都是一些关乎分布式系统运行时状态的元数据，尤其是设计到一些分布式锁，其内部存储都是一些关乎分布式系统运行状态的元数据，尤其是设计到一些分布式锁、Master选举和协调等应用场景。我们需要有效的保障 Zookeeper 中的数据安全，Zookeeper ZK 提供了三种模式。权限模式、授权模式、权限

+ 权限模式：scheme，发开人员最多使用的如下四种权限模式：

     + IP：ip 模式通过 ip 地址粒度来进行权限控制，例如配置了：ip 192.168.1.107 既表示权限控制都是针对这个ip地址的，同时也支持按网断分配，例如 192.168.1.*
     + Digest：是最常用的权限管理模式，也更符合我们队权限控制的认识，其类似于 “username：password“ 形式的权限标识进行权限配置。ZK 会对形成的权限标识先后进行两次编码处理，分别是 SHA-1 加密算法、BASE64 编码。
     + world：是一直最开放的权限控制模式，这种模式可以看作为特殊的 Digest，他仅仅是一个标识而已
     + super：超级用户模式，在超级用户模式下可以对 ZK 任意进行操作，权限对象：指的是权限赋予用户或者一个指定的实体，例如 ip 地址或机器等。在不同的模式下，授权对象是不同的。这种模式和权限对象一一对应，权限：是指那些通过检测后可以被允许的操作，在ZK中，对数据的操作权限分为以下五大类：
          + create、delete、read、write、admin


## 4、实际应用场景

​		我们希望 zookeeper 对分布式系统的配置文件进行管理，也就是说多个服务器进行 watcher，zookeeper 节点发生变化，则我们时时更新配置文件，我们要完成多个应用服务器注册wacher，然后去实时观察数据变化，然后反馈给服务器变更的数据信息，观察zookeeper 的节点

