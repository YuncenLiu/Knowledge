# Swarm 集群管理

compose、machine和 swarm 是 docker 原生提供的三大编排工具



服务器节点信息 Home 

| 主机名        | IP地址          | 说明              |
| ------------- | --------------- | ----------------- |
| K8s-master-01 | 192.168.111.135 | swarm-master 节点 |
| K8s-node-01   | 192.168.111.136 | swarm-work 01节点 |
| K8s-node-02   | 192.168.111.137 | swarm-work 02节点 |



官网：https://docs.docker.com/engine/swarm



创建 swarm 环境

```sh
docker swarm init --advertise-addr 192.168.111.135:2377 --listen-addr 192.168.111.135:2377
```

![image-20241223001649510](images/12-Swarm集群管理/image-20241223001649510.png)

创建完成后，会默认添加两个网络分别是

![image-20241223001824726](images/12-Swarm集群管理/image-20241223001824726.png)



查看docker 集群状态

```sh
docker node ls
```



获取添加一个 work 的 token，使用 node-01 和 node-02 添加

```sh
docker swarm join-token worker
```

```sh
docker swarm join --token SWMTKN-1-468701xtocisa2ag7ls689y2scyiwq44ozdwh23q9xvai2le5l-03r7rldar8f7bfntk295f590k 192.168.111.135:2377
# 24小时失效，需要重新获取
```



获取添加一个 work 的 manager

```sh
docker swarm join-token manager
```



将一个 work 节点升级为 manager 节点，变成 Reachable 状态，如果 leader 挂掉，则 node-02 成为 leader

```sh
docker node promote node-02
```



将 manager 节点降级为 work 节点

```sh
docker node demote node-02
```



退出集群，需要在当前节点中执行，不久后，使用  docker node ls 查看到状态为 Down

```sh
docker swarm leave
```

如果要彻底删除，在 leader 节点中执行

```sh
docker node rm node-02
```

![image-20241223002850755](images/12-Swarm集群管理/image-20241223002850755.png)



