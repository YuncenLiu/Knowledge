[TOC]

## 1、Centos 安装Docker

> 快速安装

查看当前系统版本：为 CentOS 8.3

```sh
[xiang@xiang ~]$ lsb_release -a
LSB Version:	:core-4.1-amd64:core-4.1-noarch
Distributor ID:	CentOS
Description:	CentOS Linux release 8.3.2011
Release:	8.3.2011
Codename:	n/a
```



采用默认安装方法：

> yum install -y docker-ce docker-ce-cli  containerd.io

```sh
[root@xiang ~]# yum install -y docker-ce docker-ce-cli  containerd.io
上次元数据过期检查：0:03:18 前，执行于 2021年04月25日 星期日 21时37分02秒。
错误：
 问题 1: problem with installed package podman-2.0.5-5.module_el8.3.0+512+b3b58dca.x86_64
  - package podman-2.0.5-5.module_el8.3.0+512+b3b58dca.x86_64 requires runc >= 1.0.0-57, but none of the providers can be installed
  - package podman-2.2.1-7.module_el8.3.0+699+d61d9c41.x86_64 requires runc >= 1.0.0-57, but none of the providers can be installed
  - package containerd.io-1.4.4-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - cannot install the best candidate for the job
  - package runc-1.0.0-64.rc10.module_el8.3.0+479+69e2ae26.x86_64 is filtered out by modular filtering
 问题 2: problem with installed package buildah-1.15.1-2.module_el8.3.0+475+c50ce30b.x86_64
  - package buildah-1.15.1-2.module_el8.3.0+475+c50ce30b.x86_64 requires runc >= 1.0.0-26, but none of the providers can be installed
  - package buildah-1.16.7-4.module_el8.3.0+699+d61d9c41.x86_64 requires runc >= 1.0.0-26, but none of the providers can be installed
  - package docker-ce-3:20.10.6-3.el8.x86_64 requires containerd.io >= 1.4.1, but none of the providers can be installed
  - package containerd.io-1.4.3-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.3-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.3-3.2.el8.x86_64 conflicts with runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.3-3.2.el8.x86_64 obsoletes runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-70.rc92.module_el8.3.0+699+d61d9c41.x86_64
  - cannot install the best candidate for the job
  - package containerd.io-1.4.3-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.3-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.3-3.2.el8.x86_64 conflicts with runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.3-3.2.el8.x86_64 obsoletes runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package containerd.io-1.4.4-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-68.rc92.module_el8.3.0+475+c50ce30b.x86_64
  - package runc-1.0.0-56.rc5.dev.git2abd837.module_el8.3.0+569+1bada2e4.x86_64 is filtered out by modular filtering
  - package runc-1.0.0-64.rc10.module_el8.3.0+479+69e2ae26.x86_64 is filtered out by modular filtering
(尝试在命令行中添加 '--allowerasing' 来替换冲突的软件包 或 '--skip-broken' 来跳过无法安装的软件包 或 '--nobest' 来不只使用最佳选择的软件包)

```

解决办法：删除依赖关系

> yum erase podman buildah

```sh
[root@xiang ~]# yum erase podman buildah
依赖关系解决。
==============================================================================================================================
 软件包                                架构                       版本                                                        
==============================================================================================================================
移除:
 buildah                               x86_64                     1.15.1-2.module_el8.3.0+475+c50ce30b                        
 podman                                x86_64                     2.0.5-5.module_el8.3.0+512+b3b58dca                         
移除依赖的软件包:
 cockpit-podman                        noarch                     18.1-2.module_el8.3.0+475+c50ce30b                          
清除未被使用的依赖关系:
 conmon                                x86_64                     2:2.0.20-2.module_el8.3.0+475+c50ce30b                      
 container-selinux                     noarch                     2:2.144.0-1.module_el8.3.0+475+c50ce30b                     
 containers-common                     x86_64                     1:1.1.1-3.module_el8.3.0+475+c50ce30b                       
 criu                                  x86_64                     3.14-2.module_el8.3.0+475+c50ce30b                          
 fuse-overlayfs                        x86_64                     1.1.2-3.module_el8.3.0+507+aa0970ae                         
 fuse3-libs                            x86_64                     3.2.1-12.el8                                                
 libnet                                x86_64                     1.1.6-15.el8                                                
 libslirp                              x86_64                     4.3.1-1.module_el8.3.0+475+c50ce30b                         
 libvarlink                            x86_64                     18-3.el8                                                    
 podman-catatonit                      x86_64                     2.0.5-5.module_el8.3.0+512+b3b58dca                         
 protobuf-c                            x86_64                     1.3.0-4.el8                                                 
 runc                                  x86_64                     1.0.0-68.rc92.module_el8.3.0+475+c50ce30b                   
 slirp4netns                           x86_64                     1.1.4-2.module_el8.3.0+475+c50ce30b                         

事务概要
==============================================================================================================================
移除  16 软件包

将会释放空间：100 M
确定吗？[y/N]： y
```

再次执行时， 安装成功！

> 安装 docker 引擎
>
> yum install docker-ce docker-ce-cli containerd.io

```sh
[root@xiang ~]# docker --version
Docker version 20.10.6, build 370c289

[root@xiang default]# docker version
Client: Docker Engine - Community
 Version:           20.10.6
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        370c289
 Built:             Fri Apr  9 22:44:36 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

```

启动 docker

```sh
systemctl start docker
```

测试

> docker version

```sh
[root@xiang default]# docker version
Client: Docker Engine - Community
 Version:           20.10.6
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        370c289
 Built:             Fri Apr  9 22:44:36 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.6
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       8728dd2
  Built:            Fri Apr  9 22:43:02 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.4
  GitCommit:        05f951a3781f4f2c1911b05e61c160e9c30eaa8e
 runc:
  Version:          1.0.0-rc93
  GitCommit:        12644e614e25b05da6fd08a38ffa0cfe1903fdec
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```



