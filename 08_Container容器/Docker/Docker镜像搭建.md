

## 方案一：（无效）

### [Render](https://dashboard.render.com/)

Gihub 图文教程：[https://github.com/dqzboy/Docker-Proxy](https://github.com/dqzboy/Docker-Proxy)

![image-20240907174605679](images/Docker镜像搭建/image-20240907174605679.png)

[集成 Render 使用教程](https://github.com/dqzboy/Docker-Proxy/tree/main/Render#-%E9%83%A8%E7%BD%B2)

| 镜像                     | 平台       |
| ------------------------ | ---------- |
| mirhub/mirror-hub:latest | docker hub |



## 方案二：（有效）



老毛子的 [dockerhub.timeweb](https://dockerhub.timeweb.cloud/)

```sh
{ "registry-mirrors" : [ "https://dockerhub.timeweb.cloud" ] }
```



```sh
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
    ]
}
```





重启docker执行命令

```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```





### 方案三：搭建自己的镜像库



[Aliyun](https://cr.console.aliyun.com/repository/cn-beijing/yuncenliu/opengauss/details)

查看镜像内容

```sh
docker scout quickview registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss

docker scout cves registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss

docker scout recommendations registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss
```



