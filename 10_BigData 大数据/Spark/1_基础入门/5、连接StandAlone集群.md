## 连接 StandAlone 集群

```sh
cd $SPARK_HOME/bin
./pyspark --master spark://hadoop01:7077
```

> Port：7077 ，是我们通过访问  http://hadoop01:4000/ 后，看到的地址

![image-20231012153423058](images/5%E3%80%81%E8%BF%9E%E6%8E%A5StandAlone%E9%9B%86%E7%BE%A4/image-20231012153423058.png)



Master：http://hadoop01:4000

Worker：http://hadoop01:4001、http://hadoop02:4001

History-log：http://hadoop01:18080

任务执行时：http://hadoop01:4040



#### Spark 程序运行层次

+ 4040：一个运行的 Application 过程中绑定的端口，在开启一个会顺延
+ 8080：默认是StandAlone下，Master角色Web端口
+ 18080：默认历史服务端口，4040被注销了，依旧可以在 18080 中查看





## 问题

1. StandAlone 运行原理

	Master 和 Worker 角色以独立进程的形式存在，并组成 Spark 运行时环境（集群），Driver 运行在 Master之内，并没有强制绑定。

2. Spark角色在 StandAlone 中分布

	Master 角色：Master 进程，Worker角色：Worker进程，Driver角色以线程运行在 Master中，Executor角色运行在 Worker中。

3. Standalone 如何提交 Spark 应用

	```
	bin/spark-submit --master spark://server:7077
	```

4. Job、state、task 关系

	一个Spark程序，会被分为多个 Job 运行，每一个Job 又会被分为多个 State（阶段）来运行，每一个 State 内会分出来多个 Task（线程）来执行具体任务