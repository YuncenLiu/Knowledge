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



#### 2.1.1、simple fanout案例1

```sh
kubectl create deployment simple-fanout-dep --image=registry.cn-beijing.aliyuncs.com/yuncenliu/nginx:1.27.3 --replicas=3 -o yaml --dry-run=client > test/simple-fanout-dep.yaml
```

创建 clusterip

```sh
kubectl create service clusterip simple-fanout-dep --tcp=80:80 --dry-run=client -o yaml > test/simple-fanout-svc.yaml
```

