**导论：**

Spark Standalone 集群是 Master-Slave 主从结构集群，普遍存在 Master 节点点单故障问题

**解决方案：**

1. 基于文件系统单点恢复（只适用于开发、测试环境）
2. 基于 Zookeeper 导 Standby Master



Zookeeper 提供的 Leader Election机制可以保证 Active Master 故障时，Standby Master 会被选举出来。



## Spark Standalone HA 搭建

> 前提确保 Zookeeper 和 HDFS 均已启动

先在 `spark-env.sh` 中，删除 `SPARK_MASTER_HOST=hadoop01`

原因：配置文件中固定 master 是谁，那么就无法用到 zk 的动态切换 master 功能了

在 `spark-env.sh` 中增加：

```properties
SPARK_DAEMON_JAVA_OPTS="-Dspark.deploy.recoveryMode=ZOOKEEPER -Dspark.deploy.zookeeper.url=hadoop01:2181,hadoop02:2181,hadoop03:2181 -Dspark.deploy.zookeeper.dir=/spark-ha"
# spark.deploy.recoveryMode 指定HA模式 基于Zookeeper实现
# 指定Zookeeper的连接地址
# 指定在Zookeeper中注册临时节点的路径
```

分发配置：`scp spark-env.sh hadoop02:$PWD`



#### 启动HA模式

先 ./stop-all.sh 关闭原有的服务

在 Hadoop01 中启动 ./start-all.sh ，这样会启动 hadoop01 的 master 服务，和所有节点的 workder 服务

然后我们再去 Hadoop02 中启动 ./start-master.sh 
