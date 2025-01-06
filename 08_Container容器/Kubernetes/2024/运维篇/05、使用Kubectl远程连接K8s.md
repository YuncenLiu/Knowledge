# 使用 Kubectl 远程连接 K8s

Mac 可以使用命令补全，Windows 不可以



> 2025-01-03

参考 [CSDN](https://blog.csdn.net/m0_51510236/article/details/133710224)

从集群中执行   `kubectl version`  获取版本 v1.28.0 ，从官网下载

```
https://cdn.dl.k8s.io/release/v1.28.0/bin/darwin/amd64/kubectl

https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe
```



因为我本地有 Docker 应用，所以自动帮我下载了一个 kubectl 工具在 

```sh
/Applications/Docker.app/Contents/Resources/bin/kubectl
```

替换原本文件，授可执行命令 chmod +x 



将服务器中 admin.conf 文件获取到

```sh
/etc/kubernetes/admin.conf 
```

放在本地目录下

```sh
/Users/xiang/xiang/tools/kubectl/admin.conf
```



配置Mac 的环境变量

```sh
# Kubernet 远程链接
export KUBECONFIG=/Users/xiang/xiang/tools/kubectl/admin.conf
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

export PATH=$GRADLE_USER_HOME:$GRADLE_HOME/bin:$PATH:$MYSQL_HOME:$JAVA_HOME/bin:$KUBECONFIG.
```

![image-20250103120944990](images/05%E3%80%81%E4%BD%BF%E7%94%A8Kubectl%E8%BF%9C%E7%A8%8B%E8%BF%9E%E6%8E%A5K8s/image-20250103120944990.png)



![image-20250103121016776](images/05%E3%80%81%E4%BD%BF%E7%94%A8Kubectl%E8%BF%9C%E7%A8%8B%E8%BF%9E%E6%8E%A5K8s/image-20250103121016776.png)

