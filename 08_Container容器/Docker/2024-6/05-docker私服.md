# Docker 私服



## registry 个人私服

官方私服：https://hub.docker.com/_/registry

| 主机           | 服务       |
| -------------- | ---------- |
| 192.168.58.160 | Docker服务 |
| 192.168.58.175 | Docker私服 |

在 `192.168.58.175` 上部署 

```sh
docker run -itd --name registry -p 5000:5000 registry.cn-beijing.aliyuncs.com/yuncenliu/registry:2.8.3
```

启动后访问：http://192.168.58.175:5000/v2/_catalog 



在 `192.168.58.160` 推送镜像

```sh
docker tag 4efb29ff172a 192.168.58.175:5000/nginx:1.19.3-alpine

docker push 192.168.58.175:5000/nginx:1.19.3-alpine
```

```sh
The push refers to repository [192.168.58.175:5000/nginx]
Get "https://192.168.58.175:5000/v2/": http: server gave HTTP response to HTTPS client
```

docker 官方不支持 http 推送，更改 daemon.json 文件

```json
vim /etc/docker/daemon.json


{
  "insecure-registries":[
    "192.168.58.175:5000"
  ]
}

systemctl daemon-reload
systemctl restart docker

# 查看 docker 信息是否添加
docker info


```

重新推送，就可以发现推送成功了，在  `192.168.58.175 `主机上 docker images 也可以发现推送过来的的 镜像

![image-20241220135502196](images/05-docker%E7%A7%81%E6%9C%8D/image-20241220135502196.png)

http://192.168.58.175:5000/v2/nginx/tags/list

![image-20241220140935482](images/05-docker%E7%A7%81%E6%9C%8D/image-20241220140935482.png)





## harbor 企业私服

> 公司的 Harbor 服务
>
> https://10.129.24.16:5443/harbor/logs
>
> admin/Harbor12345



官网：https://goharbor.io

离线安装：https://github.com/goharbor/harbor/releases/download/v2.11.2/harbor-offline-installer-v2.11.2.tgz



组件

| Component                 | Version |
| :------------------------ | :------ |
| Postgresql                | 14.10   |
| Redis                     | 7.2.2   |
| Beego                     | 2.0.6   |
| Distribution/Distribution | 2.8.3   |
| Helm                      | 2.9.1   |
| Swagger-ui                | 5.9.1   |



硬件要求

| 资源       | 最低限度 | 受到推崇的 |
| :--------- | :------- | :--------- |
| 中央处理器 | 2 CPU    | 4 CPU      |
| 内存       | 4GB      | 8 GB       |
| 磁盘       | 40 GB    | 160 GB     |

软件要求

| 软件        | 版本                                                         | 描述                                                         |
| :---------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Docker 引擎 | 版本 20.10.10-ce+ 或更高版本                                 | 有关安装说明，请参阅 [Docker Engine 文档](https://docs.docker.com/engine/installation/) |
| Docker 组成 | docker-compose（v1.18.0+）或 docker compose v2（docker-compose-plugin） | 有关安装说明，请参阅 [Docker Compose 文档](https://docs.docker.com/compose/install/) |
| OpenSSL     | 最新内容优先                                                 |                                                              |

网络权限

| 港口 | 协议  | 描述                                                         |
| :--- | :---- | :----------------------------------------------------------- |
| 443  | HTTPS | Harbor 门户和核心 API 在此端口接受 HTTPS 请求。您可以在配置文件中更改此端口。 |
| 4443 | HTTPS | 连接到 Harbor 的 Docker Content Trust 服务。您可以在配置文件中更改此端口。 |
| 80   | HTTP  | Harbor 门户和核心 API 在此端口接受 HTTP 请求。您可以在配置文件中更改此端口。 |



### 部署解压

```
/root/soft/
          └── harbor
              ├── common.sh
              ├── harbor.v2.11.2.tar.gz
              ├── harbor.yml.tmpl
              ├── install.sh
              ├── LICENSE
              └── prepare
```



harbor.yml  文件

```yaml
hostname: 192.168.58.175

http:
  port: 5000 # 默认 80 

# 把https注释掉

harbor_admin_password: Harbor12345
```

访问浏览器：http://192.168.58.175:5000/

![image-20241220142950715](images/05-docker%E7%A7%81%E6%9C%8D/image-20241220142950715.png)

```sh
admin/Harbor12345
```



![image-20241220143843437](images/05-docker%E7%A7%81%E6%9C%8D/image-20241220143843437.png)



### 上传镜像

项目中，创建 `yun` 私有项目

在 `192.168.58.160` 登录

```sh
docker login -u admin -p Harbor12345 192.168.58.175:5000

docker tag 4efb29ff172a 192.168.58.175:5000/yun/nginx:1.19.3-alpine
docker push 192.168.58.175:5000/yun/nginx:1.19.3-alpine

```

