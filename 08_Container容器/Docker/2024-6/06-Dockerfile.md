## Dockerfile

[toc]



Docker 如何创建镜像，主要方法有三种

1. 基于已有镜像创建
2. 基于 Dockerfile 创建
3. 基于本地模版导入





### 基于已有镜像创建

docker commit 从容器创建一个新镜像

```sh
docker commit [OPTTION] CONTAINER [REPOSITORY[:TAG]]
```

+ -a 提交镜像作者
+ -c 使用 Dockerfile 指令
+ -m 提交时候说明文字
+ -p 在 commit 时，将容器暂停



| 命令       | 说明                                                |
| ---------- | --------------------------------------------------- |
| FROM       | 基础镜像，必须作为第一个命令                        |
| MAINTAINER | 作者                                                |
| ENV        | 设置环境变量                                        |
| RUN        | 执行到命令                                          |
| CMD        | 容器启动时才运行到脚本                              |
| ENTRYPOINT | 覆盖CMD命令，多个 ENTRYPOINT 只会执行最后一个       |
| ADD        | tar类型文件自动解压（网络资源不会被解压），类似wget |
| COPY       | 类似 ADD，不会自动解压，不能访问网络资源            |
| WORKDIR    | 工作目录，类似 cd                                   |
| ARG        | 传递给构建运行时的变量                              |
| VOLUMN     | 持久化目录                                          |
| EXPOSE     | 外界交互端口                                        |
| USER       | 指定用户名或UID或GID组名                            |





## 案例

修改 MySQL 镜像，从 5.7.44 的市区从 UTC 修改为 Asia/Shanghai



创建 /data/mysql/Dockerfile

```dockerfile
FROM mysql:5.7.31
MAINTAINER mysql from data UTC by Asia/Shanghai "yuncenLiu@163.com"
ENV TZ Asia/Shanghai
```

执行

```sh
docker build --rm -t 192.168.58.175:5000/yun/mysql:5.7.31-Asia-Shanghai .
```



启动容器

```sh
docker run -itd --name mysql-shanghai -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 192.168.58.175:5000/yun/mysql:5.7.31_Asia_Shanghai
```

进入服务器验证时间

```sh
docker exec -it mysql-shanghai bash
root@d258445c84b0:/# date
```

查询 MySQL 数据库时间

```sql
SELECT NOW();            -- 返回当前日期和时间
SELECT CURDATE();        -- 返回当前日期
SELECT CURTIME();        -- 返回当前时间
SELECT UTC_TIMESTAMP();  -- 返回当前 UTC 时间
SELECT SYSDATE();        -- 返回当前日期和时间（函数执行时的时间）
```







## Cloud 微服务案例

在 xiang-cloud 用户下，使用 maven install 将 xiang-gateway.jar 构建到 Xiang-Cloud/xiang-common/target 目录

在 target 目录下执行

```sh
docker build --rm -t registry.cn-beijing.aliyuncs.com/yuncenliu/xiang-gateway:1.0.0 .
```

运行镜像









## lagou 微服务案例

MySQL、SpringBoot、Nginx 组件

使用 dockerfile 制作镜像



制作 mysql 镜像

1. 将 lagou.sql 放在 initsql/lagou.sql 目录下

2. 创建 Dockerfile文件

	```dockerfile
	FROM registry.cn-beijing.aliyuncs.com/yuncenliu/mysql:5.7.44
	MAINTAINER mysql from data UTC by Asia/Shanghai "yuncenLiu@163.com"
	ENV TZ Asia/Shanghai
	COPY initsql/lagou.sql /docker-entrypoint-initdb.d
	```

3. 执行 Dockerfile文件

	```sh
	docker build --rm -t registry.cn-beijing.aliyuncs.com/yuncenliu/lagou-mysql:5.7.44 .
	```

4. 服务器内拉取镜像，并运行

	```sh
	docker run -itd --name lagou-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v /data/lagou-mysql:/var/lib/mysql registry.cn-beijing.aliyuncs.com/yuncenliu/lagou-mysql:5.7.44 --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci
	```

验证，启动容器后，登录服务器数据库，可直接查询到 MySQL 数据库





制作 springboot 镜像

1. maven 将文件打包到 target 目录下

2. 创建 Dokcerfile 文件并将 xxx.jar 文件放到 Dockerfile 同一目录

   ```Dockerfile
   FROM registry.cn-beijing.aliyuncs.com/yuncenliu/openjdk:openjdk8-alpine3.9
   MAINTAINER yun docker springboot "yuncenliu@163.com"
   ## 修改源
   #RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
   #    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories
   ## 安装需要的软件，解决时区问题
   #RUN apk --update add curl bash tzdata && \
   #    rm -rf /var/cache/apk/*
   
   ENV TZ Asia/Shanghaidocker
   ARG JAR_FILE
   COPY ${JAR_FILE} app.jar
   EXPOSE 8082
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

3. 执行 dockerfile 文件

   ```sh
   docker build --rm -t registry.cn-beijing.aliyuncs.com/yuncenliu/lagou-app:1.3.0  --build-arg JAR_FILE=cloud-docker-module.jar .
   ```

4. 服务器运行容器

   ```sh
   docker run -itd --name lagou-app -p 8082:8082  registry.cn-beijing.aliyuncs.com/yuncenliu/lagou-app:1.4.0
   ```





