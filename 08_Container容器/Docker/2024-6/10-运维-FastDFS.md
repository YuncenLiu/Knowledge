# 安装 FastDFS



条件：至少 2G内存以上

官网：https://github.com/happyfish100/fastdfs

帮助手册：https://github.com/happyfish100/fastdfs/wiki

下载地址：

1. https://github.com/happyfish100/fastdfs/archive/refs/tags/V6.06.tar.gz

2. https://github.com/happyfish100/fastdfs/archive/refs/tags/V6.06.zip



#### 问题1

解压完成之后，发现 fastdfs-6.06/docker/dockerfile_local/source 里面是空的，我们手动下载下面内容，放到 source 目录下

其他组件下载地址：

https://github.com/happyfish100/fastdfs-nginx-module/archive/refs/tags/V1.22.tar.gz

https://github.com/happyfish100/libfastcommon/archive/refs/tags/V1.0.45.tar.gz

http://nginx.org/download/nginx-1.16.1.tar.gz



#### 问题2

修改 dockerfile 文件

```dockefile
# 使用新版本的 操作系统
FROM registry.cn-beijing.aliyuncs.com/yuncenliu/centos:define-7.9.2009
...
# 原本的这个文件名对不上的，需要修改成我们上传的文件
ADD source/libfastcommon-1.0.45.tar.gz /usr/local/src/
ADD source/fastdfs-6.06.tar.gz /usr/local/src/
ADD source/fastdfs-nginx-module-1.22.tar.gz /usr/local/src/
ADD source/nginx-1.16.1.tar.gz /usr/local/src/

#　下面对应的文件也相对应修改
RUN yum install git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl-devel wget vim -y \
  &&  mkdir /home/dfs   \
  &&  cd /usr/local/src/  \
  &&  cd libfastcommon-1.0.45/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd fastdfs-6.06/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd nginx-1.16.1/  \
  &&  ./configure --add-module=/usr/local/src/fastdfs-nginx-module-1.22/src/   \
  &&  make && make install  \
  &&  chmod +x /home/fastdfs.sh
```



> 构建一个 阿里云镜像源的 centos 镜像，Github [Dockerfile](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/centos/Dockerfile)



运行容器，（讲师说有问题）

```sh
docker run -d -e FASTDFS_IPADDR=192.168.111.120 -p 8888:8888 -p 22122:22122 -p 23000:23000 -p 8011:80 --name fastDFS registry.cn-beijing.aliyuncs.com/yuncenliu/fastdfs:define-6.06
```

讲师推荐命令

```sh
docker run -d -e FASTDFS_IPADDR=192.168.111.120 --net=host --name fastDFS registry.cn-beijing.aliyuncs.com/yuncenliu/fastdfs:define-6.06
```

