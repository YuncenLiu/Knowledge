## Pod

[toc]



Pod 是 k8s 集群能调度的最小单元，pod 是容器的封装，他是一个或多个容器的组合，这些容器共享存储、网络和命名空间，以及如何运行规范，在 Pod 中，所有容器都被同一安排和调度，并运行在共享的上下文中，对于具体应用而言，pod 是它们的逻辑主机，pod 包含业务相关的多个应用容器。



#### 两大特点

##### 网络

每一个 pod 都会指派唯一一个 IP 地址，在 Pod 中每个容器共享网络命名空间，同一个 pod 可以使用 localhost 进行通信，当 pod 和 pod 之外的资源通信时，需要通过端口等共享网络资源。



##### 存储

pod 能够被指定共享存储卷集合，在 pod 中所有容器能够共享访问存储卷，允许这些容器共享数据，存储卷也允许在一个pod持久化数据，以防止其中的容器需要被启动。



#### Pod重启

通过配置文件 restartPolicy 控制重启策略

1. Always，只要退出就会重启
2. OnFailure，只有在失败退出时，才会重启
3. Never，只要退出，就不再重启

这里的重启是指在 pod 宿主 Node 上进行本地重启，而不是调度到其他 node 上



#### 资源限制

k8s 通过 cgroups 限制容器 cpu 和 内存等计算资源，包括 request 请求，调度器保证调度要资源充足的 node 上、上下限等。



查看pod

```sh
# 查看 default 命名空间 pods
kubectl get pods

# 查看 kube-system 命名空间下的 pods
kubectl get pods -n kube-system

# 查看所有 pods
kubectl get pods --all-namespaces
kubectl get pods -A
```





创建 pod

基础镜像：registry.cn-beijing.aliyuncs.com/yuncenliu/tomcat:9.0.20-jre8-alpine

```sh
kubectl run tomcat-test --image=registry.cn-beijing.aliyuncs.com/yuncenliu/tomcat:9.0.20-jre8-alpine --port=8080 --replicas=3
```

> 在 28 版本中的 k8s 已经不会再创建 deployment 了，需要手动通过写 yaml 的方式创建 deployment，

查看 pod 详细信息

```sh
kubectl get po -o wide
```

创建多个实例

```sh
kubectl scale --replicas=10 deployment tomcat-test
```

删除 pod

```sh
kubectl delete po tomcat-test
```





> 与 deployment 区别， deplyment 就像是大哥，指挥有多个 pod 小弟干活，如果 pod 不干了，没了，只要 deplyment 还在，就会继续招 pod



## Service

[K8s export 官网](https://kubernetes.io/zh-cn/docs/reference/kubectl/generated/kubectl_expose/_print/)

通过 deployment 创建 service

```sh
kubectl expose deployment tomcat-test --name tomcat-service --port=8888 --target-port=8080 --protocol=TCP --type=NodePort
```

-- port ，service 对集群内其他服务暴露的端口

-- type=NodePort ，会随机从 30000-32767 端口生成一个



查看服务

```sh
kubectl get service

NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP          172m
tomcat-service   NodePort    10.106.29.154   <none>        8888:30436/TCP   6s
```

外部访问用：http://192.168.58.170:30436/

内部访问用：http://10.106.29.154:8888/



查看详细服务

```sh
kubectl get service -o wide
```

