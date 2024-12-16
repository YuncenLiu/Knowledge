> 安装前提：
>
> + JDK 1.8
> + Hadoop 集群（HDFS、YARN）版本在3.x以上
> + 3台节点

# Local 本地安装

本质：启动应该 JVM Process 进程（一个进程里面多个线程）执行Task任务

+ Local模式可以限制模拟 Spark 集群环境的线程数量，即 Local[N] 或者 Local[*]
+ 其中 N 代表可以使用 N 个线程，每个线程拥有一个 cpu core，如果不指定N，则默认1个线程，通常CPU有几个Core，就指定几个线程，最大化利用计算能力
+ 如果是 Local[*] 则代表按Cpu最大线程数设置

本地单机模式下，任务层面没有 Executor 一说，而是由 Driver 自身管理执行





## 下载地址

https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz



#### 需要环境

+ Jdk 1.8
+ Python 推荐 3.8

