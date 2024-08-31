解决分布式系统上存储的数据进行计算问题



​		在 Hadoop 2.x 引入的资源管理和作业调度，由应该 ResourceManager 和多个 NodeManager 构成 Yarn 资源管理框架。



## Yarn 配置

Yarn 属于 Hadoop 核心组件，不需要单独安装，只需要修改一些配置文件即可

`mapred-site.xml`

```xml
[root@hadoop-01 hadoop]# vim /usr/local/hadoop/etc/hadoop/mapred-site.xml
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
	<property>
		<name>yarn.app.mapreduce.am.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
    <property>
		<name>mapreduce.map.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
    <property>
		<name>mapreduce.reduce.env</name>
		<value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
	</property>
</configuration>
```

`yarn-site.xml`

```xml
<configuration>
    <!-- 设置 ResrouceManager -->
	<property>
		<name>yarn.resourcemanager.hostname</name>
		<value>hadoop01</value>
	</property>
    <!-- 设置 yarn的 shuffle 服务 -->
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>
</configuration>
```

`hadoop-env.sh`

```sh
# 添加如下
export YARN_RESOURCEMANAGER_USER=xiang
export YARN_NODEMANAGER_USER=xiang
```

#### 分发给其他节点

```sh
cd $HADOOP_HOME/etc
scp -r hadoop hadoop02:$pwd
scp -r hadoop hadoop03:$pwd
```



#### 启动 Yarn

```sh
start-yarn.sh
```

#### 验证

访问：[http://hadoop01:8088/cluster](http://hadoop01:8088/cluster)





> 2023年9月17日

配置 Yarn UI2

`vim $HADOOP_HOME/etc/hadoop/yarn-site.xml`

```
	<!-- 开启yarn.webapp.ui2 -->
	<property>
		<name>yarn.webapp.ui2.enable</name>
		<value>true</value>
	</property>
```



