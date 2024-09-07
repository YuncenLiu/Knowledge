文章地址 [CSDN](https://blog.csdn.net/kft1314/article/details/138566485) 



## 镜像

个人镜像

```sh
 pull registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss
```



#### 启动

```sh
docker run --name OpenGauss \
--privileged=true -idt \
-u root \
-p 15432:5432 \
-e GS_PASSWORD=Abcd!234 \
registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss:latest
```



简写

```sh
docker run --name OpenGauss --privileged=true -idt -u root -p 15432:5432 -e GS_PASSWORD=Abcd!234 registry.cn-beijing.aliyuncs.com/yuncenliu/opengauss:latest
```



#### 修改配置文件

```sh
docker exec -it OpenGauss sh
```

