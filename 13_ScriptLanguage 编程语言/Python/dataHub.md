> 2024-06-30 Home 192.168.111.180


Home 登录 `xiang@192.168.111.180`
切换到 datahub 环境

```sh
source datahub/bin/activate
```

测试登录

```sh
(datahub) [xiang@centos ~]$ datahub version
DataHub CLI version: 0.13.3
Models: bundled
Python version: 3.8.2 (default, Jun 30 2024, 22:45:31) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]
```


## 安装步骤

[OpenSSL 1.1.1问题 解决](OpenSSL%201.1.1问题%20解决.md)

先安装 perl5，然后再安装 openssl1.1.1+，再安装 python3.8+

[安装Python环境](0.Linux环境安装Python3.7.md)

安装完成后，使用非 root 账号，创建虚拟环境，使用虚拟环境安装 datahub

```sh
python3 -m datahub myenv
source datahub/bin/activate
```

```sh
python3 -m pip install --upgrade pip wheel setuptools  
python3 -m pip install --upgrade acryl-datahub  
datahub version
```

### 启动

docker 镜像在 `百度网盘/安装资源/dataHub` 路径下，包括 `docker-compent.yml`

```sh
datahub docker quickstart
```

他会从 [github-docker-compent.yml](https://raw.githubusercontent.com/datahub-project/datahub/master/docker/quickstart/docker-compose-without-neo4j.quickstart.yml) 下载到这个路径，如果无网络状态，可用这样弄

```sh
/home/xiang/.datahub/quickstart/docker-compose.yml
```

![](Pasted%20image%2020240630235659.png)

启动的镜像
```sh
datahub-datahub-actions-1
datahub-datahub-frontend-react-1
datahub-datahub-gms-1
datahub-schema-registry-1
datahub-broker-1
datahub-mysql-1
datahub-elasticsearch-1
datahub-zookeeper-1
```

> (DataHub is now running) -> DataHub现在正在运行

登录： [http://192.168.111.180:9002](http://192.168.111.180:9002)

![datahub 搭建环境](Pasted%20image%2020240701000012.png)


### 停止服务

```sh
datahub docker quickstart --stop
```

重置

```sh
datahub docker nuke
```