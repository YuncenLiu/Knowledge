> 2024-08-05

### Docker 容器分配固定IP

```
docker network create -d bridge --subnet 10.5.1.0/24 --gateway 10.5.1.1 yun-network
```

`--subnet` 尽可能躲开 192.128 这样的网段，这是各类路由器的网段

10.5.0.0/24，子网掩码是 255.255.255.0

10.5.0.0/16，子网掩码是 255.255.0.0



查看 网络情况 `docker network ls`

通过 `ip a` 也可以看到这个 docker 容器的网段地址



创建容器时，强行分配 IP 地址

```sh
docker run -itd --name nginx-10 -p 80:80 --net yun-network --ip 10.5.1.10 nginx:1.19.3-alpine
docker run -itd --name nginx-11  --net yun-network --ip 10.5.1.11 nginx:1.19.3-alpine
docker run -itd --name nginx-12  --net yun-network --ip 10.5.1.12 nginx:1.19.3-alpine
```

查看 docker 网络连接情况

```sh
docker network inspect yun-network
```



进入容器，查看各容器之间网络是否畅通

```sh
docker exec -it nginx-12 sh

ping 10.5.1.10
ping 10.5.1.11
ping 10.5.1.12
```



重启 容器后 查看网络连接情况，此时IP是不变更的



docker compose 编排

```sh
version: '3.8'  # 使用适合你 Docker 版本的 Compose 文件格式

networks:
  yun-network:
    driver: bridge
    ipam:
      config:
        - subnet: 10.5.1.0/24
          gateway: 10.5.1.1

services:
  nginx-10:
    image: nginx:1.19.3-alpine
    container_name: nginx-10
    networks:
      yun-network:
        ipv4_address: 10.5.1.10
    ports:
      - "80:80"

  nginx-11:
    image: nginx:1.19.3-alpine
    container_name: nginx-11
    networks:
      yun-network:
        ipv4_address: 10.5.1.11

  nginx-12:
    image: nginx:1.19.3-alpine
    container_name: nginx-12
    networks:
      yun-network:
        ipv4_address: 10.5.1.12
```

保存内容到 `docker-compose.yml`

```sh
docker-compose up -d
```







如果要删除 network

- **容器依赖性**：如果要删除的网络仍有容器连接到，必须先将这些容器从网络中断开，或者删除这些容器。否则，删除操作将会失败。

