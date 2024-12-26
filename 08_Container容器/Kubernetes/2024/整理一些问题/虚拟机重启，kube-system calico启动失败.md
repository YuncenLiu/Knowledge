## 虚拟机重启导致 kube-system 下的 calico pod 启动失败



>```sh
># 操作系统版本
>Centos7:3.10.0-1160.119.1.el7.x86_64
># k8s 集群版本
>Client Version: v1.28.0
>Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
>Server Version: v1.28.0
># docker 版本
>Docker version 26.1.4
># calico 版本
>calico/kube-controllers:3.25.0
>```



执行 kubectl get pod -n kube-system

```sh
kube-system     calico-kube-controllers-658d97c59c-xtznk   0/1     Terminating             2        19h
kube-system     calico-kube-controllers-77bd7c5b-j7xrr     0/1     ContainerCreating       0        59s
kube-system     calico-node-2q45r                          0/1     Init:ImagePullBackOff   0        59s
kube-system     calico-node-j6fb9                          0/1     Init:ImagePullBackOff   0        59s
kube-system     calico-node-w2pxk                          0/1     Init:ImagePullBackOff   0        59s
```



使用 kubectl describe po xxxx -n kube-system 查看详细信息发现报错内容：

```sh
Readiness probe failed: calico/node is not ready: BIRD is not ready: Error querying BIRD: unable to connect to BIRDv4 socket: dial unix /var/run/calico/bird.ctl: connect: connection refused
```



参考方案：[CSDN](https://blog.csdn.net/hzwy23/article/details/130498534)、[简书](https://www.jianshu.com/p/53d4ca969a11) 

都尝试过了，没有发现什么作用，最终还是通过 

```sh
kubectl delete -f calico.yaml

kubectl apply -f calico.yaml
```

