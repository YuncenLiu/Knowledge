> 创建于 2021年9月24日

[toc]



## 拉取 Redis

```sh
docker pull redis
```



启动容器前需要注意的事项：

1. 配置文件目录挂载本地磁盘

   ```sh
   -v /Users/xiang/xiang/docker/redis:/usr/local/etc/redis
   ```

2. 暴露端口

   ```sh
   -p 6379:6379
   ```

3. 最好是能用 redis-cli 直连

   ```sh
   docker run -it --network some-network --rm redis redis-cli -h some-redis
   docker run -it --rm redis redis-cli -h some-redis
   ```

   



最终运行：

```sh
docker run -p 6379:6379 -v /Users/xiang/xiang/docker/redis:/usr/local/etc/redis --name redis -d redis:latest redis-server
```

连接 redis

```sh
docker run -it --rm --link redis:redis redis redis-cli -h redis
```

