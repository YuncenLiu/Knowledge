# Kuberntes 集群IP地址发生变化

参考：[博客园](https://www.cnblogs.com/pr1s0n/p/17577821.html)



查看节点信息

```sh
kubectl get nodes

# 报错
The connection to the server 192.168.111.170:6443 was refused - did you specify the right host or port?
```



重置配置，所有节点都执行就完啦，就啥都没了

```sh
kubeadm reset --cri-socket /var/run/cri-dockerd.sock
```

