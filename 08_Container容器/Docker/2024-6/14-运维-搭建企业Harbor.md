# 企业级 Harbor



自定义域名

```sh
192.168.196.186 harbor.liuyuncen.com
```



离线安装：https://github.com/goharbor/harbor/releases/download/v2.11.2/harbor-offline-installer-v2.11.2.tgz

解压在 harbor 目录下创建 ssl 目录



#### 获得证书颁发机构

```sh
cd /root/soft/harbor/ssl

# 创建 CA 根证书
openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=TW/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor.liuyuncen.com" -key ca.key -out ca.crt
```



#### 获取服务器证书

证书通常包括 .crt文件和 .key 文件

```sh
openssl genrsa -out harbor.liuyuncen.com.key 4096

openssl req -sha512 -new -subj "/C=TW/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor.liuyuncen.com" -key harbor.liuyuncen.com.key -out harbor.liuyuncen.com.csr
```



#### 生成注册表主机证书

无论是使用域名还是IP地址链接到 Harbor 主机，都必须创建此文件，便于可以和 harbor 主机生成符合使用者替代名称 SAN 和 x509 v3 扩展要求的证书，替换 DNS 条目以反映 harbor 的域

```sh
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=harbor.liuyuncen.com
EOF
```



使用 v3.net 文件为 harbor 主机生成证书

```
openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in harbor.liuyuncen.com.csr -out harbor.liuyuncen.com.crt
```

![image-20241223150611169](images/14-%E8%BF%90%E7%BB%B4-%E6%90%AD%E5%BB%BA%E4%BC%81%E4%B8%9AHarbor/image-20241223150611169.png)



#### 为 docker 配置服务器证书，密钥和CA

生成 ca.crt、harbor.liuyuncen.com.crt、harbor.liuyuncen.com.key 文件后，必须将它们提供给 Harbor 和 docker ，并重新配置 harbor 以使用它们

将 yourdomain.com.crt 转化成 your domain.com.cert 供 docker 使用

docker 守护进程将 .crt 文件解释为 CA 证书，.cert 文件解释为 客户端证书

```sh
openssl x509 -inform PEM -in harbor.liuyuncen.com.crt -out harbor.liuyuncen.com.cert

mkdir -p /etc/docker/certs.d/harbor.liuyuncen.com/

cp harbor.liuyuncen.com.cert /etc/docker/certs.d/harbor.liuyuncen.com/
cp harbor.liuyuncen.com.key /etc/docker/certs.d/harbor.liuyuncen.com/
cp ca.crt /etc/docker/certs.d/harbor.liuyuncen.com/

# 重启docker服务：
systemctl daemon-reload
systemctl restart docker
```



> ```sh
> cp /data/nfs/ssl/harbor.liuyuncen.com.cert /etc/docker/certs.d/harbor.liuyuncen.com/
> cp /data/nfs/ssl/harbor.liuyuncen.com.key /etc/docker/certs.d/harbor.liuyuncen.com/
> cp /data/nfs/ssl/ca.crt /etc/docker/certs.d/harbor.liuyuncen.com/
> ```
>
> 用于 k8s 集群操作



修改 harbor.yml 文件

```yaml
hostname: harbor.liuyuncen.com
https:
  port: 443
  # 刚才生成一堆key、crt 宿主机路径
  certificate: /root/soft/harbor/ssl/harbor.liuyuncen.com.crt
  private_key: /root/soft/harbor/ssl/harbor.liuyuncen.com.key
```



安装 harbor

```sh
docker pull registry.cn-beijing.aliyuncs.com/yuncenliu/prepare:v2.11.2-goharbor
docker tag 74c41ed4e2a9 goharbor/prepare:v2.11.2
```

执行 ./prepare 文件

![image-20241223154605109](images/14-%E8%BF%90%E7%BB%B4-%E6%90%AD%E5%BB%BA%E4%BC%81%E4%B8%9AHarbor/image-20241223154605109.png)

最后执行 instal.sh 安装 harbor





#### linux 配置CA

```sh
cd /etc/pki/ca-trust/source/anchors/
# 上传 ca.crt

# 刷新CA
update-ca-trust

# 重启 docker
systemctl restart docker

# 如果没有成启动，进入 /root/soft/harbor 目录下
docker-compose stop
docker-compose start
```



#### Mac导入CA

双击  `harbor.liuyuncen.com.crt`  进入应用 `密码钥匙访问串` 全部信任，如果开启了 Clash 需要关闭

![image-20241223170853866](images/14-%E8%BF%90%E7%BB%B4-%E6%90%AD%E5%BB%BA%E4%BC%81%E4%B8%9AHarbor/image-20241223170853866.png)



docker 登录私服

```sh
docker login harbor.liuyuncen.com
admin
Harbor12345

docker login --username=admin -p Harbor12345 harbor.liuyuncen.com
```

![image-20241223170944261](images/14-%E8%BF%90%E7%BB%B4-%E6%90%AD%E5%BB%BA%E4%BC%81%E4%B8%9AHarbor/image-20241223170944261.png)



在  harbor 中创建 `yun` 项目

```sh
docker tag nginx:1.17.10-alpine harbor.liuyuncen.com/yun/nginx:1.17.10-alpine
docker push harbor.liuyuncen.com/yun/nginx:1.17.10-alpine
```





![image-20241223171232373](images/14-%E8%BF%90%E7%BB%B4-%E6%90%AD%E5%BB%BA%E4%BC%81%E4%B8%9AHarbor/image-20241223171232373.png)

