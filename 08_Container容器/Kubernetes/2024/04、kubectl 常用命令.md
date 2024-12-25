# Kubectl



### kubectl get

```sh
# 查看集群状态信息
kubectl cluster-info

# 查看集群状态
kubectl get cs

# 查看集群节点信息
kubectl get nodes

# 查看集群命名空间
kubectl get ns

# 查看指定命名空间的服务
kubectl get svc -n kube-system

# 以纯文本输出格式列出所有 pod ，default 空间 
kubectl get pods
kubectl get pods -A 
kubectl get pods -n kube-system

# 以纯文本输出格式列出所有 pod，并包含附加信息(如节点名)。
kubectl get pods -o wide

# 以纯文本输出格式列出具有指定名称的副本控制器。提示：您可以使用别名 'rc' 缩短和替换 'replicationcontroller' 资源类型。
kubectl get replicationcontroller <rc-name>

# 以纯文本输出格式列出所有副本控制器和服务。
kubectl get rc,services

# 以纯文本输出格式列出所有守护程序集，包括未初始化的守护程序集。
kubectl get ds --include-uninitialized

# 列出在节点 server01 上运行的所有 pod
kubectl get pods --field-selector=spec.nodeName=server01
```



进入容器

```sh
kubectl exec -it tomcat-test-5b54756b4d-ldpp7 sh
```

查看日志

```sh
kubectl logs -f tomcat-test-5b54756b4d-ldpp7
```

删除顽固pod

```sh
kubectl delete pod podname --force--grace-period=0
```

