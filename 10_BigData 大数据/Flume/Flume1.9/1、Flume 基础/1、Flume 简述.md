## Flume

高可用、高可靠、分布式的海量日志采集、聚合传输系统。



### 基础架构

![image-20231019160232771](images/1%E3%80%81Flume%20%E7%AE%80%E8%BF%B0/image-20231019160232771.png)

1. Agent：JVM进程，由 Source、Channel、Sink 组成
	1. Source：负责接收 Flume Agent 组建，包括各种各样的日志数据
	2. Sink：不断轮询从 Channel 中处理数据
	3. Channel：缓冲区
		1. Memory
		2. File
	4. Event：传输单元



## 安装

（1）Flume 官网地址：http://flume.apache.org/

（2）文档查看地址：http://flume.apache.org/FlumeUserGuide.html

（3）下载地址：http://archive.apache.org/dist/flume/



将 `apache-flume-1.9.0-bin.tar.gz` 文件上传到 Hadoop01 服务器中

```sh
# 解压到 /usr/local 下
sudo tar -zxvf apache-flume-1.9.0-bin.tar.gz -C /usr/local/

# 打个快捷
sudo ln -s /usr/local/apache-flume-1.9.0-bin /usr/local/flume

# 授权 ...
# 删除 guava-11.0.2.jar 兼容 Hadoop3.x
rm -rf /usr/local/flume/lib/guava-11.0.2.jar
# 因为配置了 Hadoop 环境变量，他会去 Hadoop 里面找，不用担心没有
```



> 安装 nc 工具
>
> ```sh
> sudo yum install -y nc
> ```

#### 配置文件

```sh
cd /usr/local/flume
```

创建文件夹

```sh
mkdir job
cd job/
```

创建文件 `flume-netcat-logger.conf`

```properties
# example.conf: A single-node Flume configuration

# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Describe/configure the source
a1.sources.r1.type = netcat
a1.sources.r1.bind = localhost
a1.sources.r1.port = 44444

# Describe the sink
a1.sinks.k1.type = logger

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

注：配置文件来源于官方手册 http://flume.apache.org/FlumeUserGuide.html



### 启动

```sh
bin/flume-ng agent -n a1 -c conf/ -f job/flume-netcat-logger.conf  -Dflume.root.logger=INFO,console
```

成功状态

```
2023-10-19 17:18:13,504 (lifecycleSupervisor-1-0) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:155)] Source starting
2023-10-19 17:18:13,513 (lifecycleSupervisor-1-0) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:166)] Created serverSocket:sun.nio.ch.ServerSocketChannelImpl[/127.0.0.1:44444]
```

此时，再开通一个会话窗口 `nc localhost 44444` 输入内容，就会进行交互，服务也会对应输出日志



### 监控单个文件追加

检查环境变量

```sh
[xiang@hadoop01 job]$ echo $HADOOP_HOME
/usr/local/hadoop
[xiang@hadoop01 job]$ echo $JAVA_HOME
/usr/local/jdk
```

进入 `/usr/local/flume/job` 目录，创建 `flume-file-hdfs.conf` 文件

```properties
# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1
# Describe/configure the source
a1.sources.r1.type = exec
a1.sources.r1.command = tail -F /usr/local/hive/logs/hive.log

# Describe the sink
a1.sinks.k1.type = hdfs
a1.sinks.k1.hdfs.path = hdfs://hadoop01:9820/flume/%Y%m%d/%H

#上传文件的前缀
a1.sinks.k1.hdfs.filePrefix = logs-
#是否按照时间滚动文件夹
a1.sinks.k1.hdfs.round = true
#多少时间单位创建一个新的文件夹
a1.sinks.k1.hdfs.roundValue = 1
#重新定义时间单位
a1.sinks.k1.hdfs.roundUnit = hour
#是否使用本地时间戳
a1.sinks.k1.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a1.sinks.k1.hdfs.batchSize = 100
#设置文件类型，可支持压缩
a1.sinks.k1.hdfs.fileType = DataStream
#多久生成一个新的文件
a1.sinks.k1.hdfs.rollInterval = 60
#设置每个文件的滚动大小
a1.sinks.k1.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a1.sinks.k1.hdfs.rollCount = 0

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

执行之前，取保 Hive 运行中，否则 `tail -F /usr/local/hive/logs/hive.log`  无法滚动，其实找个别的方法代替也可以。

确保 `tail -F ` 日志滚动后，执行 

```sh
bin/flume-ng agent -n a1 -c conf/ -f job/flume-file-hdfs.conf
```

查看 HDFS 发现 `hdfs://hadoop01:9820/flume/20231019/17` 存在文件



> 这里存在一个问题，因为 tail 命令原因，不支持断点续传



### 监控多个文件

在 job 目录下创建 flume-dir-hdfs.conf

```properties
a2.sources = r2
a2.sinks = k2
a2.channels = c2
# Describe/configure the source
a2.sources.r2.type = spooldir
a2.sources.r2.spoolDir = /usr/local/flume/upload
a2.sources.r2.fileSuffix = .COMPLETED
a2.sources.r2.fileHeader = true
#忽略所有以.tmp 结尾的文件，不上传
a2.sources.r2.ignorePattern = ([^ ]*\.tmp)

# Describe the sink
a2.sinks.k2.type = hdfs
a2.sinks.k2.hdfs.path = hdfs://hadoop01:9820/flume/upload/%Y%m%d/%H
#上传文件的前缀
a2.sinks.k2.hdfs.filePrefix = upload-
#是否按照时间滚动文件夹
a2.sinks.k2.hdfs.round = true
#多少时间单位创建一个新的文件夹
a2.sinks.k2.hdfs.roundValue = 1
#重新定义时间单位
a2.sinks.k2.hdfs.roundUnit = hour
#是否使用本地时间戳
a2.sinks.k2.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a2.sinks.k2.hdfs.batchSize = 100
#设置文件类型，可支持压缩
a2.sinks.k2.hdfs.fileType = DataStream
#多久生成一个新的文件
a2.sinks.k2.hdfs.rollInterval = 60
#设置每个文件的滚动大小大概是 128M
a2.sinks.k2.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a2.sinks.k2.hdfs.rollCount = 0
# Use a channel which buffers events in memory
a2.channels.c2.type = memory
a2.channels.c2.capacity = 1000
a2.channels.c2.transactionCapacity = 100
# Bind the source and sink to the channel
a2.sources.r2.channels = c2
a2.sinks.k2.channel = c2
```

启动

```sh
bin/flume-ng agent -n a2 -c conf/ -f job/flume-dir-hdfs.conf
```

> spooldir 总结：
>
> ​	只要我们往 /usr/local/flume/upload 里面上传除 .tmp 文件之外的文件，都会瞬间修改为 .COMPLETED 文件，并写入 HDFS



### 动态监控多个文件

创建 job 为 `flume-taildir-hdfs.conf`

```properties
a3.sources = r3
a3.sinks = k3
a3.channels = c3
# Describe/configure the source
a3.sources.r3.type = TAILDIR
a3.sources.r3.positionFile = /usr/local/apache-flume-1.9.0-bin/tail_dir.json

# 多目录形式
a3.sources.r3.filegroups = f1 f2
a3.sources.r3.filegroups.f1 = /usr/local/apache-flume-1.9.0-bin/files/.*file.*
a3.sources.r3.filegroups.f2 = /usr/local/apache-flume-1.9.0-bin/files2/.*log.*
# Describe the sink
a3.sinks.k3.type = hdfs
a3.sinks.k3.hdfs.path = hdfs://hadoop01:9820/flume/upload2/%Y%m%d/%H
#上传文件的前缀
a3.sinks.k3.hdfs.filePrefix = upload-
#是否按照时间滚动文件夹
a3.sinks.k3.hdfs.round = true
#多少时间单位创建一个新的文件夹
a3.sinks.k3.hdfs.roundValue = 1
#重新定义时间单位
a3.sinks.k3.hdfs.roundUnit = hour
#是否使用本地时间戳
a3.sinks.k3.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a3.sinks.k3.hdfs.batchSize = 100
#设置文件类型，可支持压缩
a3.sinks.k3.hdfs.fileType = DataStream
#多久生成一个新的文件
a3.sinks.k3.hdfs.rollInterval = 60
#设置每个文件的滚动大小大概是 128M
a3.sinks.k3.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a3.sinks.k3.hdfs.rollCount = 0
# Use a channel which buffers events in memory
a3.channels.c3.type = memory
a3.channels.c3.capacity = 1000
a3.channels.c3.transactionCapacity = 100
# Bind the source and sink to the channel
a3.sources.r3.channels = c3
a3.sinks.k3.channel = c3
```

启动

```
bin/flume-ng agent -c conf/ -n a3 -f job/flume-taildir-hdfs.conf
```



存在的问题：

我们打开 `/usr/local/apache-flume-1.9.0-bin/tail_dir.json` 文件可以看到以下内容

```json
{
    "inode":168037278,
    "pos":16,
    "file":"/usr/local/apache-flume-1.9.0-bin/files/1-file.txt"
}
```

+ inode 是Linux文件系统标识文件的唯一标识码
+ file 是文件名字
+ pos 则是 flume 管理的文件号

只有当 inode 和 file 两个任意一个发生修改后，才会从新上传 pos 文件，如果说更名之后，就会断掉了，如果想要让他更名后继续上传，改源代码。

> 如果你只想让他去判断 inode 就只能去改源码了
