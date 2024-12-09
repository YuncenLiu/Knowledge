HDFS 采用主从结构

+ Client 客户端
  + HDFS 提供了各种 HDFS 接口
  + 与 NameNode 、DataNode 进行交互
+ Namenode 名称节点
  + 作为中心服务器（老大），负责管理文件系统命名空间，记录每个文件信息，在 NameSpace 内存中管理，客户端也是直接对 Namenode 进行对话
  + 一个 Hadoop 集群只有一个 （HA除外）
  + 管理 HDFS 命名空间，文件系统，大小，权限，时间，块大小，内存中管理，并以 fsimage 和 edits 进行持久化
  + 内存中维护数据映射信息
  + 实施副本冗余策略
  + 处理客户端的访问请求
+ Datanode 数据节点
  + 一般一个节点跑一个 Datanode，真正负责上传、下载是和 Datanode 中运行，数据是保存在 Datanode 的Linux本地磁盘中。按时向 Namenode发送心跳信息（3秒）。
  + 如果 Datanode 不发心跳了，Namenode 会认为这个节点宕机了，恢复分片数据、停止分配 I/O 请求...
+ SecondaryNameNode 
  + 帮助 NameNode 合并 fsimage 和 edits 文件
  + 不能实时同步，不能作为热备节点





NameNode 主要是内存进行管理，需要持久化，方法两种

+ 映射文件 fsimage

  每隔一段时间，将目录树结构保存起来。

+ 日志文件 edit

  记录上一次保存镜像后，每一步执行的日志

fsimage 为大节点，edit log 为小步骤。一大一小，保证断电可靠性