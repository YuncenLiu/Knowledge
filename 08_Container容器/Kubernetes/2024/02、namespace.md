## NameSpace

[toc]

命名空间，是 k8s 集群中虚拟化集群，一个 k8s 集群中可以有多个 Namespace，他们在逻辑上彼此隔离，可以为你提供组织，安全甚至性能方面的帮助。



namespace 是对一组资源和对象的抽象集合，比如可以用来将系统内部对象划分为不同项目或用户组

常见概念： pod、services、replication controller 和 deployments 都属于某一个 namespace

默认为 default，而 node、persistentVolumes 等不属于任何 nameespace



+ default，资源默认被创建于此空间
+ kube-system，k8s 系统组件
+ kube-node-lease，k8s 集群节点续约状态，v1.13 加入
+ kube-public，公用资源



作用：并非物理隔离，属于逻辑隔离，属于管理边界，不属于网络边界，可以针对每个 namespace 做资源配额



查看 namespace

```sh
kubectl get namespace

# 简写
kubectl get ns
```



创建 namespace

```sh
kubectl create namespace xiang
kubectl create ns xiang
```

删除 namespace

```sh
kubectl delete namespace xiang
kubectl delete ns xiang
```

