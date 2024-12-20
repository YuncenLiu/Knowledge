# docker-compose

官网地址：https://docs.docker.com/reference/compose-file/

概念

​		在实际生产环境中，一个应用往往由许多服务构成，而 docker 的最佳实现是一个容器运行一个进程，因此运行多个微服务需要多个容器，多个容器协同工作需要一个有效的工具来管理他们。compose 应运而生。

​		使用 YAML 文件来定义容器之间关系，` docker-compose up ` 就可以把完整的应用跑起来。容器之间用 link 关联。



compse、machine 和 swarm 是 docker 原生提供的三大编排工具，简称 docker 三剑客

Docker Compose 能够在 Docker 节点上，以单引擎模式进行多容器应用和部署



背景

Docker Compose 前身是 Fig，Fig由 Orchard 公司开发的强有力工具，在当时进行多容器管理最佳方案。

Fig是基于 Docker 的 Python 工具，运行用户基于 YAML 文件定义多个容器，从而可以使用 fig 命令进行工具部署。

Fig 还可以对应用的全生命周期进行管理，内部实现上，Fig 会解析 YAML 文件，通过 Docker API 进行内部部署和管理

在2014年，Docker 收购了 Orchard 公司，并将 Fig 更名为 Docker Compose，命令行也从 fig 更名为 docker-compose，并自此成为绑定 docker 引擎之上的外部工具。

虽然从未完全集成到 Docker 引擎中，但是仍受广泛关注。

直至今日，Docker Compose 仍然需要在 Docker 主机上进行外部安装 Python 工具





##### 下载

https://github.com/docker/compose

```
https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64
```

下载，移动，授权即可使用

```sh
cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker-compose --version
```



#### yaml配置文件及常用指令（重要）

Docker Compose 使用 YAML 文件来定义多服务应用，YAML 是 JSON 的一个子集，因此也可以使用 JSON。

Docker Compose 默认使用文件名 docker-compose.yml。当然，也可以 -f 指定具体文件。

Docker Compose 的 YAML 文件包含 4 个一级key：version、services、network、volumnes

+ version 是必须指定的，并且总是位于文件第一行，定义了 compose 文件格式，主要是API版本，这里的 version 并非定义 Docker Compose 或 Docker 引擎的版本。
+ services 用于定义不同应用服务，上边的例子定义了两个服务，一个是 yun-mysql 数据库服务，以及一个 yun-eurake 微服务，Docker Compose 会将每个服务部署在各自容器里。
+ networks 用于指引 Docker 创建新的网络，默认情况下 Docker Compose 会创建 bridge 网络，这是一种单主机网络，之能够实现同一台主机容器连接，当然也可以使用 driver 属性指定不同网络类型
+ volumes 用于指引 Docker 创建的卷

```yml
version: '3'
services:
  yun-mysql:
    build:
      context: ./mysql
    environment:
      MYSQL_ROOT_PASSWORD: admin
    restart: always
    container_name: yun-mysql
    volumes:
    - /data/docker-compose/mysql:/var/lib/mysql
    images: registry.cn-beijing.aliyuncs.com/yuncenliu/mysql:5.7.44
    ports:
      - 3306:3306
    networks:
      yun-net:
  yun-eurake:
    build: 
      context: ./eureka-boot
    restart: always
    ports:
      - 8761:8761
    container_name: eureka-boot
    hostname: eureka-boot
    image: yun/eureka-boot:1.0
    depends_on:
      - yun-mysql
    networks:
      yun-net:
networks:
  yun-net:
volumes:
  yun-vol:
```





本地环境准备

```sh
docker run -itd --name nginx-01 -p 80:80 nginx:1.19.3-alpine
docker run -tid --name tomcat-01 -p 8080:8080 tomcat:9.0.20-jre8-alpine

docker cp tomcat-01:/usr/local/tomcat/webapps /data/tomcat1/webapps
docker cp nginx-01:/etc/nginx/conf.d /data/nginx/conf.d
docker cp nginx-01:/usr/share/nginx/html /data/nginx/html
```

Nginx 配置文件

```nginx
upstream yunNginx {
    server 192.168.58.160:8081;
    server 192.168.58.160:8082;
}

server {
    listen       80;
    server_name  192.168.58.160;
    autoindex on;
    index index.html index.htm index.jsp;
    location / {
        proxy_pass http://yunNginx;
        add_header Accept-Control-Allow-Origin *;
    }
}
```

编写 docker-compose 文件

```yaml
version: '3'
services:
  yun-nginx:
    image: nginx:1.19.3-alpine
    # 可以和 services 下面的不一样
    container_name: nginx-01
    ports:
      - 80:80
    volumes:
      - /data/nginx/conf.d:/etc/nginx/conf.d
  yun-tomcat-01:
    image: tomcat:9.0.20-jre8
    container_name: tomcat-01
    ports:
      - 8081:8080
    volumes:
      - /data/tomcat1/webapps:/usr/local/tomcat/webapps
    depends_on:
      - yun-nginx
  yun-tomcat-02:
    image: tomcat:9.0.20-jre8
    container_name: tomcat-02
    ports:
      - 8082:8080
    volumes:
      - /data/tomcat2/webapps:/usr/local/tomcat/webapps
    depends_on:
      - yun-nginx
```

启动服务

```sh
# 前台启动
docker-compose up

# 后台启动
docker-compose up -d
```



```
[+] Running 4/4
 ✔ Network data_default  Created  0.1s 
 ✔ Container nginx-01    Created  0.1s 
 ✔ Container tomcat-01   Created  0.0s 
 ✔ Container tomcat-02   Created
```

我们发现了启动了 data_default 网络，也可以通过 docker network insepct data_default 查看容器在Docker中IP分配情况。



### 命令汇总

> 前提必须在 docker-compose.yml 文件目录下执行如下文件，否则就要 -f 指定文件

查看： docker-compose ls

查看日志：docker-compose logs

构建或重新构建服务：docker-compose build

启动服务：docker-compose start

停止已运行的服务：docker-compose stop

重启：docker-compose restart



相关命令官网地址：https://docs.docker.com/reference/cli/docker/compose/build/

