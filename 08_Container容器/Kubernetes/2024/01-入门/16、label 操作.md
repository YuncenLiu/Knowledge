# label 操作

[toc]

操作 label 语法

```sh
kubectl label nodes <node-name> <label-key>=<label-value>

kubectl label nodes k8s-node-01 mariadb=mariadb10.5.2

# 查看 node 节点 label 值
kubectl get nodes --show-labels

# 删除 node-01 节点 mariabd 标签
kubectl label nodes k8s-node-01 mariadb-
# 然后重新打
kubectl label nodes k8s-node-01 mariadb=mariadb
```

指定 pod 部署在某一个节点上，先将 node 打上 label 标签

在 Deolpoyement YAML 配置文件中

```sh
spec:
  # label 操作，
  nodeSelector:
    mariadb: mariadb
```

