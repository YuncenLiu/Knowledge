## Flume Agent 

### 内部原理图

![image-20231020212241317](images/1、Flume 事务/image-20231020212241317.png)



### 拓扑结构

1. 简单串联，需要通过 RPC 通信框架做支持

   ![image-20231020212505615](images/1、Flume 事务/image-20231020212505615.png)

2. 多路复用

   ![image-20231020212523064](images/1、Flume 事务/image-20231020212523064.png)

3. 负载均衡+故障转移

   ![image-20231020212539264](images/1、Flume 事务/image-20231020212539264.png)

4. 聚合

   ![image-20231020212601360](images/1、Flume 事务/image-20231020212601360.png)