### 将已启动的容器设置自启动

```
docker update redis --restart=always
```


### 将已启动的容器设置不自启动

```
docker update redis --restart=no
```



查看容器的状态

```sh
docker inspect --format '{{.HostConfig.RestartPolicy.Name}}'  nginx
```

