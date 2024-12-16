> 2024-06-11
>
> https://kaiwu.lagou.com/xunlianying/index.html?courseId=67

## Docker 网络

查看网络情况 `docker network ls`

```sh
NETWORK ID     NAME      DRIVER    SCOPE
8ef049cd7a78   bridge    bridge    local
728709a240c6   host      host      local
fe66f4cd930f   none      null      local
```



通过 `docker info` 查看网卡配置

```sh
Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null(none) overlay
```



通过 `ip a` 查看 docker 虚拟出的网卡

```sh
docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:a2:86:bd:fc brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```

 `172.17.0.1` docker网桥是宿主机虚拟出来的，并不是真实存在的网络设备，外部网络上无法寻址的，这也就意味着外部网络无法直接 Conatiner-IP 访问到容器。 只能通过创建容器时， `-p` 、`-P` 参数来启用





### bridge模式

默认的网络模式，该模式下容器没有公有IP，只有宿主机直接访问外部，外部主机是不可见的，但容器通过宿主机的NAT规则后可以访问外网



### host模式

和主机共用同一个IP地址，最大优势减少端口开销，缺点也一样，容易导致宿主机端口占用

需要在容器创建时指定 `-network=host`



### none模式

没有通信、网卡、IP

场景：密码加密，这个容器只允许宿主机访问，不允许其他人访问，封闭性网络提供很好的安全性 `-network=none` 



### overlay模式

docker集群模式，用的不咋多了，k8s 把活都给干完了。



### macvlan模式

没用过，不咋用。





## 核心原理

### bridge网络分析

#### 基础镜像拉取

> 2024-06-06
>
> Mac 192.168.58.10 虚拟机（可直接下拉）

```sh
docker pull nginx:1.19.3-alpine
```

查看bridge网络详情

```sh
docker network inspect bridge
```

![image-20240611171954510](images/01-Docker%E7%BD%91%E7%BB%9C/image-20240611171954510.png)

注意观察 `Containers` 内容

我们运行一个 Nginx 容器

```sh
docker run -itd --name lagou_nginx_01 nginx:1.19.3-alpine
```

再重新运行  `docker network inspect bridge`

```sh
docker network inspect bridge
```



```json
"Containers": {
  "7a94a77912e132c5306eb62aa0b60c4603b67a490fc0348f6dc73e0ce33074ec": {
    "Name": "lagou_nginx_01",
    "EndpointID": "0d30d6e59bb8b49b0d5c3896514bf7c805a14c983ce27e18cbafd49a2e0343b0",
    "MacAddress": "02:42:ac:11:00:02",
    "IPv4Address": "172.17.0.2/16",
    "IPv6Address": ""
  }
},
```

这里的 `IPv4Address` 就是从 `docker0` 网卡范围开始编排的，通过重新执行 ip a 查看网卡，发现多出来一块网卡

![image-20240611172301949](images/01-Docker%E7%BD%91%E7%BB%9C/image-20240611172301949.png)

通过执行 `docker exec -it lagou_nginx_01 ip a` 发现 docker nginx 容器内也有一个网卡，但此时无法验证两块网卡是否一致



安装 brctl

```sh
yum install -y bridge-utils
```

查看 bridge 

```sh
brctl show
```

![image-20240611172816055](images/01-Docker%E7%BD%91%E7%BB%9C/image-20240611172816055.png)

结论：说明本地 docker0 网卡与 docker创建Nginx容器后虚拟出的网卡是一一对应的。



Docker 容器是可以访问外网的，宿主机也可以通过 `docker0` 网卡的ip地址 ping 通docker





### 容器与容器之间

再创建一个容器

```sh
docker run -itd --name lagou_nginx_02 nginx:1.19.3-alpine
```

通过进入 `lagou_nginx_01` 容器，ping `172.17.0.2` 发现容器是可以被ping通的

但是无法通过 `lagou_nginx_02` 名称ping通



通过关停容器再反序启动容器，发现容器的IP是根据启动顺序决定的，先启动的先分配，后启动的后分配。





#### link容器

添加链接到另一个容器，生产环境还好IP不会太大变动，内部测试环境，IP地址会不断变动。用link 解决这个问题

```sh
docker run -itd --name lagou_nginx_02 --link lagou_nginx_01 nginx:1.19.3-alpine
```

此时，进入 `lagou_nginx_02` 容器，无论是通过 IP、还是域名，都可以ping通  `lagou_nginx_01` 容器

但反过来，`lagou_nginx_01` 无法ping通 `lagou_nginx_02`

结论： **link 是单向的**，另外，**不要使用ip地址去做容器间的通信，因为经常会变动。**

Docker 已经不推荐使用这个参数了





### 新建brdige网络

```sh
docker network create -d bridge lagou-bridge
```

查看新增的网络

```sh
docker network ls
```

发现多了一个  `ddd351d1073c   lagou-bridge   bridge    local`

详细查看新的网络

```sh
docker network inspect lagou-bridge 
```

发现它属于新的一个网段 `"Subnet": "172.18.0.0/16"`



![image-20240611175511456](images/01-Docker%E7%BD%91%E7%BB%9C/image-20240611175511456.png)

原先的 docker0 绑定的2个，新增的 lagou-brdige 没有绑定



通过指定网卡创建容器

```sh
docker run -itd --name lagou_nginx_03 --network lagou-bridge nginx:1.19.3-alpine
```



查看

```sh
docker network inspect lagou-bridge
```





