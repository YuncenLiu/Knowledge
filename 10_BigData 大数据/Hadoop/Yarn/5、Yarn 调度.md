## Yarn 三种调度器

Scheduler 调度器

#### FIFO 调度

安装先进先，策略简单，不适合集群，因为大应用会占用集群的所有资源，每个应用必须等待直到轮到自己。

**优点**：简单易懂，不需要任何配置

**缺点**：不适合集群，大的应用会占用集群中的所有资源。



#### 容量调度

允许多个组织共享一个 Hadoo 集群，一个独立的专门保证小作业一提交就可以完成

**优点**：小任务不会因为前面由大任务，而只能一直等待

**缺点**：这种策略是以集群利用率为代价，这意味着与使用FIFO调度相比，大作业执行时间长一些。



#### 公平调度

不需要预留资源，小任务提交时，它被分配到集群中，如果有大任务吃资源，会先拿出大任务的一些资源分给小任务执行



> 文章：https://blog.csdn.net/Yellow_python/article/details/116021592



## Yarn队列配置

修改配置文件 ` $HADOO_HOME/etc/hadoop/capacity-scheduler.xml`

```xml
<configuration>
	<!-- 不用改，最大调度数量 10000，我们用到10000那么多 -->
  <property>
    <name>yarn.scheduler.capacity.maximum-applications</name>
    <value>10000</value>
    <description>
      Maximum number of applications that can be pending and running.
    </description>
  </property>
  
  <!-- 不修改 application master 最多占集群的10% 
	如果把这个数改小，job 数量就会少，新的任务就会提交不进来
	-->
  <property>
    <name>yarn.scheduler.capacity.maximum-am-resource-percent</name>
    <value>0.1</value>
    <description> 集群中可用于运行主应用程序的最大资源百分比，即控制并发运行应用程序的数量。
    </description>
  </property>
  
  <!-- 不用改 job 使用的策略，这里使用默认策略 -->
  <property>
    <name>yarn.scheduler.capacity.resource-calculator</name>
    <value>org.apache.hadoop.yarn.util.resource.DefaultResourceCalculator</value>
    <description> 用于比较调度程序中的资源的ResourceCalculator实现。默认的，即DefaultResourceCalculator只使用内存，而DominantResourceCalculator使用支配资源来比较多维资源，如内存，CPU等。
    </description>
  </property>
  
  <!-- 需要改，调度器中添加一个 small 队列 用来跑小任务 -->
  <property>
    <name>yarn.scheduler.capacity.root.queues</name>
    <value>default,hive</value>
    <description>
      The queues at the this level (root is the root queue).
    </description>
  </property>
  
  <!-- 需要改，配置 default 队列容量大小，改为70 --> 
   <property>
    <name>yarn.scheduler.capacity.root.default.capacity</name>
    <value>70</value>
    <description>Default queue target capacity.</description>
  </property>
  
   <!-- 新增 small 队列，这里的值 + default 要等于 100 --> 
   <property>
    <name>yarn.scheduler.capacity.root.small.capacity</name>
    <value>30</value>
    <description>Default queue target capacity.</description>
  </property>

  <!-- 不修改，default 队列能使用的最大百分比 --> 
  <property>
    <name>yarn.scheduler.capacity.root.default.user-limit-factor</name>
    <value>1</value>
    <description>
      Default queue user limit a percentage from 0.0 to 1.0.
    </description>
  </property>
  
  <!-- 新增，small 队列能使用的最大百分比 --> 
  <property>
    <name>yarn.scheduler.capacity.root.small.user-limit-factor</name>
    <value>1</value>
    <description>
      Default queue user limit a percentage from 0.0 to 1.0.
    </description>
  </property>
  
  <!-- 不修改，default 队列能使用的最大百分比 -->
  <property>
    <name>yarn.scheduler.capacity.root.default.maximum-capacity</name>
    <value>100</value>
    <description>
      The maximum capacity of the default queue.
    </description>
  </property>
  
  <!-- 新增，small 队列能使用的最大百分比 -->
  <property>
    <name>yarn.scheduler.capacity.root.small.maximum-capacity</name>
    <value>100</value>
    <description>
      The maximum capacity of the default queue.
    </description>
  </property>
  
  <!-- 不修改，default 队列状态 -->
  <property>
    <name>yarn.scheduler.capacity.root.default.state</name>
    <value>RUNNING</value>
    <description>
      The state of the default queue. State can be one of RUNNING or STOPPED.
    </description>
  </property>
  
  <!-- 新增，small 队列状态 -->
  <property>
    <name>yarn.scheduler.capacity.root.small.state</name>
    <value>RUNNING</value>
    <description>
      The state of the default queue. State can be one of RUNNING or STOPPED.
    </description>
  </property>
  
  <!-- 不修改，限制用户对队列提交用户 -->
  <property>
    <name>yarn.scheduler.capacity.root.default.acl_submit_applications</name>
    <value>*</value>
    <description>
      The ACL of who can submit jobs to the default queue.
    </description>
  </property>
</configuration>
```

复制粘贴  `conf/capacity-scheduler` 文件就好

```sh
# 分发配置
scp capacity-scheduler.xml hadoop02:$PWD
scp capacity-scheduler.xml hadoop03:$PWD
```





## 使用调度

> ```sh
> yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar pi 1000 1000
> ```

在不指定队列的情况下，默认使用 default 队列，我们可以添加

`-Dmapreduce.job.queuename=hive` 指定队列

```sh
yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount -Dmapreduce.job.queuename=hive /input /output2
```

```sh
yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar pi -Dmapreduce.job.queuename=hive  1000 1000 
```



## 设置默认队列

`mapred-site.xml`

```xml
<!-- 设置默认提交队列 -->
<property>
  <name>mapreduce.job.queuename</name>
  <value>hive</value>
</property>
```

设置完成后，不需要重启，直接执行

```sh
yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount  /input /output3
```

