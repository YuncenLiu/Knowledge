

# GBase 8A 搭建



```sh
docker pull shihd/gbase8a:1.0
```



启动容器

```sh
docker run -itd --name gbase8a --privileged=true -p5258:5258 shihd/gbase8a:1.0
```



下载驱动：https://gitcode.com/open-source-toolkit/db3cd/blob/main/gbase-connector-java-8.3.81.53.rar













```sh
docker run -itd -p 9999:9088 --name gbase8s liaosnet/gbase8s:3.3.0_2csdk_amd64
```

