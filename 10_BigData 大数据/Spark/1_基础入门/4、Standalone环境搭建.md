## Standalone 环境安装

### 集群规划

课程中 使用三台Linux虚拟机来组成集群环境, 非别是:

+ Hadoop01运行: Spark的Master进程  和 1个Worker进程
+ Hadoop02运行: spark的1个worker进程
+ Hadoop03运行: spark的1个worker进程


整个集群提供: 1个master进程 和 3个worker进程



#### 分配文件

```sh
scp /home/xiang/package/Anaconda3-2021.05-Linux-x86_64.sh hadoop02:`pwd`/Anaconda3-2021.05-Linux-x86_64.sh
scp /home/xiang/package/Anaconda3-2021.05-Linux-x86_64.sh hadoop03:`pwd`/Anaconda3-2021.05-Linux-x86_64.sh
```

#### 给 Hadoop02、03 安装 anaconda 环境

#### 修改Spark配置文件

```sh
cd $SPARK_HOME/conf
```

配置 workers 文件  `mv workers.template  workers`

```sh
hadoop01
hadoop02
hadoop03
```

配置spark-env.sh文件 `mv spark-env.sh.template spark-env.sh`

```properties
## 设置JAVA安装目录
JAVA_HOME=/usr/local/jdk/

## HADOOP软件配置文件目录，读取HDFS上文件和运行YARN集群
HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
YARN_CONF_DIR=/usr/local/hadoop/etc/hadoop

## 指定spark老大Master的IP和提交任务的通信端口
# 告知Spark的master运行在哪个机器上
export SPARK_MASTER_HOST=hadoop01
# 告知sparkmaster的通讯端口
export SPARK_MASTER_PORT=7077
# 告知spark master的 webui端口
SPARK_MASTER_WEBUI_PORT=4000

# worker cpu可用核数
SPARK_WORKER_CORES=1
# worker可用内存
SPARK_WORKER_MEMORY=1g
# worker的工作通讯地址
SPARK_WORKER_PORT=7078
# worker的 webui地址
SPARK_WORKER_WEBUI_PORT=4001

## 设置历史服务器
# 配置的意思是  将spark程序运行的历史日志 存到hdfs的/sparklog文件夹中
SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=hdfs://hadoop01:9820/sparklog/ -Dspark.history.fs.cleaner.enabled=true"
```

hdfs 创建文件夹用于存放日志

```sh
hadoop fs -mkdir /sparklog
```

配置spark-defaults.conf文件

> 在粘贴的时候，容易全注释了
>
> vim 之后，`:set paste` 就不会了

```properties
# 开启spark的日期记录功能
spark.eventLog.enabled 	true
# 设置spark日志记录的路径
spark.eventLog.dir	 hdfs://hadoop01:9820/sparklog/ 
# 设置spark日志是否启动压缩
spark.eventLog.compress 	true
```

配置log4j.properties 文件 [可选配置]

```sh
# 1. 改名
mv log4j.properties.template log4j.properties
```

Spark 日志非常话唠，修改第 19行

```properties
log4j.rootCategory=WARN, console
```

#### 分发授权

```sh
sudo scp -r /usr/local/spark hadoop02:/usr/local/spark
sudo scp -r /usr/local/spark hadoop03:/usr/local/spark

# 在另外两台服务器上执行
sudo chown -R xiang:xiang /usr/local/spark
```



### 启动历史服务器

```
cd /usr/local/spark/sbin
./start-history-server.sh
```

查看状态

```
JobHistoryServer (Yarn 的历史服务)
HistoryServer (Spark 的历史服务)
```

#### 启动Master、Worker进程

```sh
# 启动全部master和worker
sbin/start-all.sh

# 或者可以一个个启动:
# 启动当前机器的master
sbin/start-master.sh
# 启动当前机器的worker
sbin/start-worker.sh

# 停止全部
sbin/stop-all.sh

# 停止当前机器的master
sbin/stop-master.sh

# 停止当前机器的worker
sbin/stop-worker.sh
```

访问地址：http://hadoop01:4000/

> 如果端口被占用，会顺延端口

![image-20231012153231330](images/4%E3%80%81Standalone%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA/image-20231012153231330.png)