### 部署

确保 `spark-env.sh` 

+ HADOOP_CONF_DIR
+ YARN_CONF_DIR



### 连接到Yarn中

```sh
$SPARK_HOME/bin/pyspark --master yarn --deploy-mode client|cluster
# --deploy-mode 选项是指定部署模式, 默认是 客户端模式
# client就是客户端模式
# cluster就是集群模式
# --deploy-mode 仅可以用在YARN模式下
```

```sh
[xiang@hadoop01 spark]$ bin/pyspark --master yarn
```

这个启动会有点慢

![image-20231012174947198](images/2%E3%80%81%E9%83%A8%E7%BD%B2%20Spark%20On%20Yarn/image-20231012174947198.png)



Yarn 方式提交服务

```sh
./spark-submit --master yarn /usr/local/spark/examples/src/main/python/pi.py  100
```



### Spark On Yarn部署模式

两种模式运行方式

+ Cluster 集群模式
+ Client 客户端模式 pyspark-submit 提交运行

|                 | Cluster 模式       | Client 模式        |
| --------------- | ------------------ | ------------------ |
| Server 运行位置 | Yarn容器内         | 客户端进程内       |
| 通讯效率        | 高                 | 低于 Cluster 模式  |
| 日志查看        | 容器内，不方便查看 | 在客户端中输出     |
| 生产可用性      | 推荐               | 不推荐             |
| 稳定性          | 稳定               | 收客户端服务器影响 |



客户端模式提交

```sh
bin/spark-submit --master yarn \
	--deploy-mode client \
	--driver-memory 512m \
	--executor-memory 512m \
	--num-executors 3 \
	--total-executor-cores 3 \
	/usr/local/spark/examples/src/main/python/pi.py 100
```

集群模式提交

```sh
bin/spark-submit --master yarn \
	--deploy-mode cluster \
	--driver-memory 512m \
	--executor-memory 512m \
	--num-executors 3 \
	--total-executor-cores 3 \
	/usr/local/spark/examples/src/main/python/pi.py 100
```



### Yarn Client 本地提交流程图

![image-20231013103140637](images/2%E3%80%81%E9%83%A8%E7%BD%B2%20Spark%20On%20Yarn/image-20231013103140637.png)



