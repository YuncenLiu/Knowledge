提交到 Yarn 上的任务，日志会在

```
/usr/local/hadoop/logs/userlogs
```

中保存，但是如果重启了 Yarn 这里的日志会被清空

如果要保留这个，就需要开启历史服务





## mr-historyserver

为了避免再不同的节点中找 hadoop 日志，我们可以把日志上传到 Hadoop 中（日志聚合）

`mapred-site.xml`

```xml
        <property>
            	<name>MapReduce.jobhistory.address</name>
            	<value>hadoop01:10020</value>
        </property>
        <property>
            	<name>MapReduce.jobhistory.webapp.address</name>
            	<value>hadoop01:19888</value>
        </property>	
```

`yarn-site.xml`

开启日志聚合后，将会在各个 Container 的日志保存在 `yarn.nodemanager.remote-app-log-dir` 的位置

默认保存在 `/tmp/logs` 中

```xml
		<!-- 是否开启日志聚合 -->
		<property>
                <name>yarn.log-aggregation-enable</name>
                <value>true</value>
        </property>
		<!-- 历史日志再 HDFS保存的时间，单位是秒 -->
		<!-- 默认是01，表示永久保存 -->
        <property>
                <name>yarn.log-aggregation.retain-seconds</name>
                <value>604800</value>
        </property>
		<property>
                <name>yarn.log.server.url</name>
                <value>http://hadoop01:19888/jobhistory/logs</value>
        </property>
```

#### 分发配置

```sh
cd $HADOOP_HOME/etc/hadoop
scp mapred-site.xml yarn-site.xml hadoop02:$PWD
scp mapred-site.xml yarn-site.xml hadoop03:$PWD
```

#### 重启yarn

```sh
stop-yarn.sh
start-yarn.sh
```

#### 开启历史服务

```sh
mapred --daemon start historyserver
```

就可以看到历史服务打开了

```sh
[xiang@hadoop01 hadoop]$ jps-cluster.sh 
----------  hadoop01  ----------
4256 ResourceManager
4792 JobHistoryServer
...
```

