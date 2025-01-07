## Pod控制器

[toc]



### YAML总结

#### Replicas 副本数量

.spec.replicas 是可选字段，指定期望 pod 数量，默认是1

#### Selector 选择器

.spec.selector 是可选字段，用来指定 label.selector ，圈定 deployment 管理的 pod 范围，如果被指定，.sepc.selector 必须匹配 .spec.tamplate.metadata.labels，否则将被API拒绝，如果 .spec.selecotr 没有被指定 .spec.selector.matchLables 默认是 .spec.template.metadata.labels

Pod 的 template 和 .spec.template 不同，或者数量超过了 .spec.replicas  规定数量，deployment 会杀掉 label 和 selector 不同的 pod

#### Pod Template 模版

.spec.template 是 .spec 中唯一要求的字段



### 常见 pod 控制器含义

1. ReplicaSet 适合无状态的服务部署

	1. 用户创建指定数量的 pod 副本数保证 pod 副本数量符合预期状态，并且支持滚动式自动扩容和缩容功能，ReplicaSet主要三个组件构成
		1. 用户期望的pod副本数量
		2. 标签选择器，判断哪个pod归自己管
		3. 当现存 pod 数量不足时，会根据 pod 资源模版进行新建

2. depolyment：适合无状态的服务部署

	1. 工作在 ReplicaSet 之上，用于管理无状态应用，目前来说最好的控制器，支持滚动更新和回滚更新

3. StatefulSet：适合有状态的服务部署

4. DaemonSet：一次性部署，所有 node 节点都会部署，

	1. 运行集群 daemon，每个节点上运行 glusterd、ceph （这是啥？）
	2. 每个节点上收集日志
	3. 每个节点上运行监控

	用于确保几集群中的每个节点只运行特定的 pod 副本，通常用于实系统级后台任务，例如 ELK

5. Job 一次性执行

6. Cronjob，周期性任务



#### replicas 扩容

在 [YAML](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-controller/replicaset-demo.yaml) 文件中配置 pod 数量

```sh
spec:
  replicas: 1
```

通过 kubectl apply 创建完成之后，命令行方式进行修改 

```sh
kubectl scale replicaset replicaset-demo --replicas=3
```

使用 kubectl edit 进行编辑

```sh
kubectl edit deployments.apps replicaset-demo 
```



#### label 标签

查看 pod 的 label 标签

```sh
kubectl get pod --show-labels
```

![image-20241226132315871](images/12%E3%80%81Pod%E6%8E%A7%E5%88%B6%E5%99%A8/image-20241226132315871.png)

K8s 通过 labels 管理 pod，如果 labels 不一致则 deplpyment 无法管理到 这个 pod

强行修改一个 pod 的 labels.app 

```sh
kubectl label pod replicaset-demo-5bc9b8fd6c-4llcw app=yun  --overwrite=True
```

修改成功，原本 deployment 少了一个 pod ，deployment 认为他死了，就又创建了一个，其实只是改名了而已

![image-20241226133404944](images/12%E3%80%81Pod%E6%8E%A7%E5%88%B6%E5%99%A8/image-20241226133404944.png)



### Deployment 控制器

Deployment 是 k8s 1.2 引入的概念，用于更好的解决Pod 编排问题，为此，Deployment 在内部使用了 ReplicaSet 来实现目标，可以把 Deployment 理解为 ReplicaSet 的一次升级，两者的相似度超过 90%

使用场景

1. Deployment 对象来生成对应的 ReplicaSet 并完成 pod 创建
2. 检查 Deployment 的状态来看部署动作是否完成，pod 副本数量是否达到预期
3. 更新 Deployment 以创建新的 pod
4. 如果当前 Deployment 不稳定，可以回滚到早先一个版本
5. 暂停 deployment 以便一次性修改多个 PodTemplateSpec 配置项，之后再恢复 Deployment，进行新的发布
6. 扩展 Deployment 以应对高负载
7. 查看 Deployment 的状态，以此作为发布是否成功的纸币
8. 清理不在需要的旧版本 ReplicaSet



在已启动的 deployment 中，升级镜像

##### 方式一

kubectl set image  资源类型  deplyemnt名字  app=新版本镜像名

```sh
kubectl set image  deployment deployment-demo deployment-demo=registry.cn-beijing.aliyuncs.com/yuncenliu/nginx:1.18.0-alpine
```



##### 方式二

```sh
kubectl edit deployments.apps deployment-demo
```

找到镜像位置，修改完成 wq 保存退出



deployment 扩容数量，实际对 pod 进行扩容

```sh
kubectl scale deployment  deployment-demo --replicas=10
```





### 滚动更新

1. 蓝绿部署，是不停老版本，部署新版本然后进行测试，确认OK，将流量切到新版本，然后老版本同时升级到新版本，蓝绿部署无需停机，风险较小
2. 滚动发布，一般取出一个或多个服务器停止服务，执行更新，并重新投入，周而复始，直到集群中所有实例都更新新版本，相对于蓝绿部署更节省资源，不需要运行两个集群，两倍的实例数，可以部分部署，每次只取20%进行升级
3. 灰度发布，指黑白之间，平滑的过度发布，AB test 就是灰度发布，让一部分用户用A，一部分用户用B，如果用户B没有反对意见，那就逐步扩大范围，把所有用户迁移到 B，灰度发布可以保证整体稳定，在初始灰度的时候就可以发现、调整问题，以保证其影响度，而我们说的金丝雀部署也是灰度发布的一种方式



##### 金丝雀发布

Deployment 控制器自定义控制更新过程中的滚动节奏，如 暂停 或 继续 更新操作，比如等待第一批新的 Pod 资源创建完成后立即暂停更新过程，此时，仅存在一部分新版本的应用，主体部分还是旧的版本，然后，再筛选一小部分的用户请求路由到新版本的 pod 应用，继续观察能否按期望方式运行，确定没有问题之后再继续完成余下的 pod 资源滚动更新，否则立即回滚更新操作。





更新 deployemnt 的 nginx:1.18.0-alpine 版本，并配置暂停 deployment

```sh
kubectl set image  deployment deployment-demo deployment-demo=registry.cn-beijing.aliyuncs.com/yuncenliu/nginx:1.18.0-alpine && kubectl rollout pause deployment deployment-demo
```

查看暂停状态

```sh
kubectl rollout status deployment deployment-demo
```

Waiting for deployment "deployment-demo" rollout to finish: 7 out of 15 new replicas have been updated...

![image-20241226171234790](images/12%E3%80%81Pod%E6%8E%A7%E5%88%B6%E5%99%A8/image-20241226171234790.png)

继续更新

```sh
kubectl rollout resume deployment deployment-demo 
```

rollout 常用命令

+ history 查看 rollout 操作历史
+ pause 将提供的资源设定为暂停状态
+ restart 重启某个资源
+ resume 将某资源从暂停状态恢复正常
+ sttatus 查看 rollout 操作状态
+ undo 回滚到前一个 rollout



##### history 查看历史版本

```sh
kubectl rollout history deployment deployment-demo
```

##### undo 回滚到前一个版本 

从更新后到 nginx:1.18.0-alpine  回滚到 nginx version: nginx/1.19.3

```sh
kubectl rollout undo deployment deployment-demo 
```



查看回滚策略，最大 25%

```sh
kubectl describe deployments.apps deployment-demo
```

![image-20241226171907378](images/12%E3%80%81Pod%E6%8E%A7%E5%88%B6%E5%99%A8/image-20241226171907378.png)



### DaemonSet 控制器

参考 Github：[daemonset.yaml](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-controller/daemonset.yaml)

除了 master 节点，有多少个 node 节点，就会创建多少个 pod

查看 dameons 

```sh
kubectl get daemonsets.apps
```

删除

```sh
kubectl delete daemonsets.apps daemon-set-demo 
```



#### Job 控制器

参考 GitHub：[job-demo.yaml](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-controller/job-demo.yaml)

```yaml
      containers:
        - name: job-demo
          image: registry.cn-beijing.aliyuncs.com/yuncenliu/perl:slim
          command: ['perl', '-Mbignum=bpi', '-wle', 'print bpi(6000)']
          imagePullPolicy: IfNotPresent
      # 重启策略必须是 spec.template.spec.restartPolicy: Required value: valid values: "OnFailure", "Never"
      restartPolicy: Never
      imagePullSecrets:
        - name: aliyun-yuncen
# 不能有 selector
#  selector:
#    matchLabels:
#      app: job-demo
```

计算圆周率 6000 位

