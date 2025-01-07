# 控制器

[toc]

### Deployment

####　控制器类型



+ Deployment：声明式更新控制器，用于发布无状态应用
+ ReplicaSet：副本集控制器，对 pod 进行副本规模扩大、裁剪
+ StatefulSet：有状态副本集，用于发布有状态应用
+ DaemonSet：在 k8s 集群每个 node 上运行一个副本，用于发布监控或日志收集等应用
+ Job：运行一次性任务
+ CronJob：周期性运行任务



##### Deployment 控制器

具有上线部署，滚动升级，创建副本，回滚到某一个版本（成功/稳定）等功能

Deployment 包含 ReplicaSet，除非需要自定义升级或者根本不需要升级 Pod，否则还是建议使用 Deployment 而不直接使用 ReplicaSet



##### 删除 Deployement

```sh
kubectl delete -f xxxx.yaml
```



### Service

#### Service 类型

1. ClusterIP，默认 分配一个集群内部可以访问的虚拟IP
2. NodePort，在每一个 Node 上分配一个端口端口作为访问入口
3. LoadBalancer，工作在特定的 cloud provider上，例如 Google Cloud，AWS，Openstack
4. ExternalName，表示把集群外部的服务引入到集群内部中来，既实现了集群内部 pod 和集群外部的服务进行通信



#### Service参数

1. port 访问 service 使用端口
2. targetPort：pod 中容器端口
3. NodePort： 通过 node 实现外网用户访问 k8s 集群内 service（任意一个节点都可以访问到）