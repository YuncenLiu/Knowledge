### 1、初始环境

CentOS 7.x

关闭防火墙

```sh
systemctl stop firewalld.service
systemctl disable firewalld.service

# 查看防火墙状态
firewall-cmd --state
```



### 2、单节点部署

> 下载 ElasticSearch
>
> 地址：https://www.elastic.co/cn/downloads/elasticsearch 
>
> 下载：https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.3.0-linux-x86_64.tar.gz

注意，这个版本需要 JDK 11

![image-20230412133104807](images/1%E3%80%81%E5%AE%89%E8%A3%85/image-20230412133104807.png)



配置 JAVA 环境  `vi /etc/profile`

```profile
export JAVA_HOME=/usr/local/jdk
export JRE_HOME=/usr/local/jdk/jre
export CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

生效

```
source /etc/profile
```



创建用户，因为 root 用户使用 ElasticSearch 有问题

```
useradd xiang
passwd xiang
```



把 elasticsearch 文件给到 xiang 用户

```
sudo chown -R xiang:xiang /usr/local/elasticsearch
```



### 3、配置 ElasticSearch

编辑 /usr/local/elasticsearch/config/elasticsearch.yml

```
node.name: node-1
network.host: 192.168.58.175
http.port: 9200
cluster.initial_master_nodes: ["node-1"]
```

编辑 /usr/local/elasticsearch/config/jvm.options

> 根据实际情况，不建议低于默认值，这里不改

```
-Xms1g
-Xmx1g
```

编辑 /etc/sysctl.conf 不加的话，启动会报错

```
vm.max_map_count=655360
```

让其生效

```
sysctl -p
```

编辑 /etc/security/limits.conf

```
*   soft    nofile  65536
*   hard    nofile  65536
*   soft    nproc   4096 
*   hard    nproc   4096
```



### 4、启动

切换到非root用户启动

```
/usr/local/elasticsearch/bin/elasticsearch
```

如果启动很慢，建议把Linux服务器内存调高一点

![image-20230412141325354](images/1%E3%80%81%E5%AE%89%E8%A3%85/image-20230412141325354.png)

这里表示启动成功了