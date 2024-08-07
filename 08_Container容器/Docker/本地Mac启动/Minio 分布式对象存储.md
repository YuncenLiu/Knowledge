> 创建于 2021年12月24日
> 	   作者：想想

[toc]

### 前言

感觉比腾讯 COS 对象好用



## docker 部署运行

官网：[https://docs.min.io/](https://docs.min.io/)

执行脚本：

```sh
mkdir -p /root/docker/minio/data
```

```sh
docker run \
  -p 19000:9000 \
  -p 19001:9001 \
  --name minio \
  -v /root/docker/minio/data:/data \
  -e "MINIO_ROOT_USER=root" \
  -e "MINIO_ROOT_PASSWORD=11111111" \
  quay.io/minio/minio server /data --console-address ":9001"
```

⚠️注意：密码至少八位

完整命令

```sh
docker run -p 19000:9000 -p 19001:9001 --name minio -v /root/docker/minio/data:/data -e "MINIO_ROOT_USER=root" -e "MINIO_ROOT_PASSWORD=11111111" quay.io/minio/minio server /data --console-address ":9001"
```



本地客户端永久保留文件

Super 服务器中

mc文件在 `/root/docker` 路径下

```sh
./mc config host add minio http://101.201.81.193:19000 root 11111111
```

```sh
./mc policy get minio/red-pavilion
```

```sh
./mc policy set download minio/red-pavilion
```







## 带 Https 的Minio

```sh
docker run 
	-p 11900:9000 
	-p 11901:9001 
	--name minio-https 
	-e "MINIO_ACCESS_KEY=admin" 
	-e "MINIO_SECRET_KEY=admin123456" 
	-v /root/docker/minio/data:/data 
	-v /root/docker/minio/conf:/root/.minio 
  quay.io/minio/minio server /data 
	--console-address ":9001"
```

完整命令

```sh
docker run \
	-p 11900:9000 \
	-p 11901:9001 \
	--name minio-https \
	-e "MINIO_ACCESS_KEY=admin" \
	-e "MINIO_SECRET_KEY=admin123" \
	-v /root/docker/minio/data:/data \
	-v /root/docker/minio/conf:/root/.minio \
  quay.io/minio/minio server /data \
	--console-address ":9001"
	--address ":9000"
```



```sh
docker run \
	-p 11900:9000 \
	-p 11901:9001 \
	--name minio-https \
	-e "MINIO_ACCESS_KEY=admin" \
	-e "MINIO_SECRET_KEY=admin123" \
	-v /root/docker/minio/data:/data \
	-v /root/docker/minio/conf:/root/.minio \
  quay.io/minio/minio server /data \
	--console-address ":9001"
	--address "liuyuncen.com:9000"
```

```sh
docker run \
	-p 11900:9000 \
	-p 11901:9001 \
	--name minio-https \
	-e "MINIO_ACCESS_KEY=admin" \
	-e "MINIO_SECRET_KEY=admin123" \
	-v /root/docker/minio/data:/data \
	-v /root/docker/minio/conf:/root/.minio \
  quay.io/minio/minio server /data \
	--console-address ":9001"
	--address "172.17.0.2:9000"
```

```sh
docker run \
	--network=host \
	-p 11900:9000 \
	-p 11901:9001 \
	--name minio-https \
	-e "MINIO_ACCESS_KEY=admin" \
	-e "MINIO_SECRET_KEY=admin123" \
	-v /root/docker/minio/data:/data \
	-v /root/docker/minio/conf:/root/.minio \
  quay.io/minio/minio server /data \
	--console-address ":9001"
	--address "liuyuncen.com:9000"
```

