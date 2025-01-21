## Kubetnetes 部署 Hadoo 集群

> 2025-01-21，[Bilibiili](https://www.bilibili.com/video/BV12z4y177DE)

[toc]



已知环境

```sh
# kubectl version
K8s Client Version: v1.28.0
# rpm -q centos-release
centos-release-7-9.2009.2
# uname -r
6.9.7-1.el7.elrepo.x86_64
# docker images | grep calico
v3.25.1
```

安装版本

```sh
helm - 3.26.1
buildkit - 0.11.6
hadoop - 3.3.6
```

### 污点 Taint

查看 master 节点污点情况

```sh
kubectl describe nodes k8s-master-01 | grep Taint
```

![image-20250121145936716](images/10%E3%80%81%E9%83%A8%E7%BD%B2%20Hadoop/image-20250121145936716.png)

取消污点，允许 master 节点运行 pod

```sh
kubectl taint nodes k8s-master-01 node-role.kubernetes.io/control-plane:NoSchedule-
```

### 安装 shelm 工具

官网：https://helm.sh/

```sh
wget https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz

mkdir -p /root/Documents/helm

tar -zxvf helm-v3.12.0-linux-amd64.tar.gz -C /root/Documents/helm/

# 添加环境变量
# Helm-v3.12.0
export HELM=/root/Documents/helm/linux-amd64
export PATH=$HELM:$PATH.
```

```sh
# 查看版本
helm version
```

![image-20250121152739691](images/10%E3%80%81%E9%83%A8%E7%BD%B2%20Hadoop/image-20250121152739691.png)

### 安装 buildkit 工具

```sh
wget https://github.com/moby/buildkit/releases/download/v0.19.0/buildkit-v0.19.0.linux-amd64.tar.gz

# 复制到虚拟机
scp buildkit-v0.19.0.linux-amd64.tar.gz root@192.168.58.4:/data/package

mkdir -p /root/Documents/buildkit && tar -zxvf /data/package/buildkit-v0.19.0.linux-amd64.tar.gz -C /root/Documents/buildkit

# 添加环境变量
# buildkit-v0.19.0
export BUILDKIT=/root/Documents/buildkit
export PATH=$BUILDKIT/bin:$PATH.
```

```sh
# 查看版本
buildctl --version
```

![image-20250121155336235](images/10%E3%80%81%E9%83%A8%E7%BD%B2%20Hadoop/image-20250121155336235.png)

注册成服务，开机自启

```sh
cat <<EOF > /usr/lib/systemd/system/buildkitd.service
[unit]
Description=buildkitd
After=network.target

[Service]
ExecStart=/root/Documents/buildkit/bin/buildkitd

[Install]
WantedBy=multi-user.target
EOF
```

启动服务，配置开机自启

```sh
systemctl daemon-reload
systemctl start buildkitd
systemctl enable buildkitd
```


### VM虚拟机做快照

### 创建 Hadoop 集群

创建 hadoop 目录

```sh
mkdir -p /opt/hadoop && cd /opt/hadoop
```

