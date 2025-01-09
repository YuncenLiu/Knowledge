# Kubernetes MetalLB + Ingress

[toc]

参考：[博客园](https://www.cnblogs.com/birkhoffxia/articles/17998192)

官网：https://github.com/kubernetes/ingress-nginx

### 部署 MetalLB

参考 07、Kuberntes LoadBalancer-MetalLBUntitled.md



### 部署 Ingress Controller

因为多次部署导致 K8s集群宕机，这里和文章部署版本保持一致

部署1.9.5版本 Ingress-controller

![image-20250107232109521](images/08、MetalLB + Ingress Controller/image-20250107232109521.png)



准备镜像包

```sh
registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20231011-8b53cabe0@sha256:a7943503b45d552785aa3b5e457f169a5661fb94d82b8a3373bcd9ebaf9aac80

registry.k8s.io/ingress-nginx/controller:v1.9.5@sha256:b3aba22b1da80e7acfc52b115cae1d4c687172cbf2b742d5b502419c25ff340e
```

```sh
docker load -i /data/images/ingress-controller.1.9.5.tar
```

执行后，并不会引起 宕机情况

![image-20250107235602236](images/08、MetalLB + Ingress Controller/image-20250107235602236.png)



nginx-ingress 创建了一个 EXTERNAL-IP：192.168.126.4 的 svc

浏览器直接访问

https://192.168.126.4/index.html

http://192.168.126.4/index.html

![image-20250107235757366](images/08、MetalLB + Ingress Controller/image-20250107235757366.png)



## 2、Ingress 类型

### 2.1、Simple fanout

在同一个 FQDN 下通过不同URI完成不同应用间流量分发

+ 基于虚拟主机接收多个应用流量
+ 常用于流量分发至同一个应用下的多个不同子应用
+ 不需要为每一个应用配置专用域名



命令：

```sh
kubectl create ingress NAME --rule=host/path=service:port[,tls[=secret]]
```

+ --annotation=[] 提供注解，格式：annotation=value
+ --rule=[]，代理规则，格式：host/path=service:port[,tls=secrename]
+ --class=''，该Ingress适配 Ingress Class



#### 2.1.1、simple fanout案例

第一组Nginx

simple-fanout-a-dep.yaml

```sh
kubectl create deployment simple-fanout-a-dep --image=ikubernetes/demoapp:v1.0 --replicas=3 -o yaml --dry-run=client > 02-simple-fanout/01-simple-fanout-a-dep.yaml
```

simple-fanout-a-svc.yaml

```sh
kubectl create service clusterip simple-fanout-a-dep --tcp=80:80 --dry-run=client -o yaml > 02-simple-fanout/02-simple-fanout-a-svc.yaml
```

第二组Nginx

```sh
kubectl create deployment simple-fanout-b-dep --image=ikubernetes/demoapp:v1.0 --replicas=2 -o yaml --dry-run=client > 02-simple-fanout/03-simple-fanout-b-dep.yaml
```

```sh
kubectl create service clusterip simple-fanout-b-dep --tcp=80:80 --dry-run=client -o yaml > 02-simple-fanout/04-simple-fanout-b-svc.yaml
```

运行当前节点

![image-20250109150733603](images/08%E3%80%81MetalLB%20+%20Ingress%20Controller/image-20250109150733603.png)



编写 loop 命令

```sh
#!/bin/bash

# 检查是否提供了命令
if [ $# -eq 0 ]; then
  echo "请提供要循环执行的命令"
  exit 1
fi

# 使用无限循环执行命令，每次循环之间间隔1秒
while true; do
  "$@"      # 执行传入的命令
  sleep 1   # 每次循环后暂停1秒
done
```



验证负载均衡

```sh
loop curl 10.97.17.245
```

![image-20250109150917871](images/08%E3%80%81MetalLB%20+%20Ingress%20Controller/image-20250109150917871.png)







#### 2.1.1、annotaion 案例

Ingress-Nginx 支持 annotation nginx.ingress.kubernetes.io/rewrite-target 注解进行

1. 
