## Docker网络命令汇总

#### 查看网络 docker network ls

作用：查看已经建立的网络，默认情况下只有三种， bridge、host、none

```sh
docker network ls

-- 显示完整的MD5
docker network ls --no-trunc

-- 只查询 host 网络
docker network ls -f 'driver=host'
```



#### 创建网络

docker network create

作用：创建新的网络对象

命令格式：Usage:  docker network create [OPTIONS] NETWORK

```sh
Options:
      --attachable           Enable manual container attachment #启用手动连接容器
      --aux-address map      Auxiliary IPv4 or IPv6 addresses used by Network driver (default map[]) # 网络驱动使用的辅助IPv4或IPv6地址（默认map[]）
      --config-from string   The network from which to copy the configuration #用于复制配置的网络
      --config-only          Create a configuration only network # 创建仅供配置的网络
 
  -d, --driver string        Driver to manage the Network (default "bridge") # 管理网络的驱动程序（默认为“网桥”）
      --gateway strings      IPv4 or IPv6 Gateway for the master subnet # 主子网的IPv4或IPv6网关
      --ingress              Create swarm routing-mesh network # 创建蜂群路由-mesh网络
      --internal             Restrict external access to the network # 限制外部访问网络
      --ip-range strings     Allocate container ip from a sub-range # 从子范围内分配容器ip
      --ipam-driver string   IP Address Management Driver (default "default") # IP地址管理驱动程序（默认“default”）
      --ipam-opt map         Set IPAM driver specific options (default map[]) # 设置IPAM驱动程序特定选项（默认map[]）
      --ipv6                 Enable IPv6 networking # 启用IPv6组网
      --label list           Set metadata on a network # 设置网络元数据
  -o, --opt map              Set driver specific options (default map[]) # 设置驱动程序特定选项（默认map[]）
      --scope string         Control the network's scope # 控制网络范围
      --subnet strings       Subnet in CIDR format that represents a network segment # CIDR格式的子网，表示一个网段
```

例子：

```sh
docker network create -d yun
```

 

#### 网络删除

```sh
docker network rm yun
```



#### 查看网络详细信息

```sh
docker network insepct yun
```





#### 使用网络

```sh
docker run/creatte --network yun
```

docker 创建容器时，默认会使用 bridge 网络







## 案例



固定网络IP和网关，注意要避开 192.168.x.x 网段

```sh
docker network create -d bridge --subnet=172.172.0.0/24 --gateway 172.172.0.1 yun-network
```



固定网络和IP启动容器

```sh
docker run -itd --name yun-nginx-03 --net yun-network --ip 172.172.0.10  nginx:1.19.3-alpine

--net yun-network：选择存在的网络
--ip 给容器分配固定IP地址
```

使用 `docker exec `  进入容器 `ip a` 可以发现 IP 已经固定