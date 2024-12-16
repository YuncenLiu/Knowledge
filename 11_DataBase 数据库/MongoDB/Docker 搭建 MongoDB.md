> 创建于2022年9月26日
>
> 标签：数据库 非关系型数据库
>
> 内容：初步探索 MongoDB

### 安装

学习第一步：安装

我比较喜欢 Docker 容器，每次学习一个新的技术或组件的时候，都会用 Docker 快速的搭建这个组件，节省了很多人在一开始搭建上的失败间接导致直接放弃了这个技术。

```sh
docker run -d
  --name mongodb
  --restart always
  --privileged
  -p 27017:27017
  -v /Users/xiang/xiang/docker/MongoDB/data:/data/db
  -e MONGO_INITDB_ROOT_USERNAME=admin
  -e MONGO_INITDB_ROOT_PASSWORD=admin123
  mongo:4.2.2 mongod --auth
```

dockerhub 的官网：https://hub.docker.com/_/mongo

先创建目录

```sh
mkdir -p /Users/xiang/xiang/docker/MongoDB
mkdir -p /Users/xiang/xiang/docker/MongoDB/initdb
mkdir -p /Users/xiang/xiang/docker/MongoDB/datadir
mkdir -p /Users/xiang/xiang/docker/MongoDB/configdb
```

