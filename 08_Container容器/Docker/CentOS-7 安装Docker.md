> 创建于 2022年3月31日
> 		来源：https://www.cnblogs.com/yufeng218/p/8370670.html


#yum更新

[toc]

### 更新 yum 源

```sh
sudo yum update
```

### 卸载旧版本

```sh
sudo yum remove docker  docker-common docker-selinux docker-engine
```

### 下载依赖

```sh
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

### 设置docker源

> 2024-06-30 无法使用了

```sh
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

也可以使用 阿里云的 镜像

```sh
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

#### 可以查看版本选择特点源

```sh
yum list docker-ce --showduplicates | sort -r
```

### 安装

如果没有什么别的特殊想法直接安装

```sh
sudo yum install docker-ce
```

### 启动

```sh
sudo systemctl start docker
# 以后开启自启
sudo systemctl enable docker
```

### 验证

```sh
docker version
```

