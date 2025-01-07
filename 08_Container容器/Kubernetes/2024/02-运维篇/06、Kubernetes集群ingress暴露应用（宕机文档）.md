# Kubernetes集群ingress暴露应用(有问题，容易导致K8s死机)

参考：[CSDN](https://blog.csdn.net/m0_51510236/article/details/132536519)



#### 为什么需要Ingress

LoadBalancer：当我们在使用LoadBalancer类型的Service暴露服务的时候，一般都需要占用一个公网或者是内网IP地址。使用ingress我们就可以通过一个IP地址暴露多个服务。Ingress会根据客户端输入的不同的域名来确定我们需要转发到哪个服务上面去，这样可以节省公网或内网IP地址，同时也能实现负载均衡效果。

NodePort：这种Kubernetes应用暴露方式会在每个节点服务器上暴露30000~32767之间的端口，我们每个Service都会占用这样的端口最少一个。有没有办法只占用一个端口暴露多个应用呢？答案是可以的。需要用到Ingress。





下载配置文件 与 Nginx、K8s 版本都有关联 https://github.com/kubernetes/ingress-nginx#changelog

![image-20250103164743370](images/06%E3%80%81Kubernetes%E9%9B%86%E7%BE%A4ingress%E6%9A%B4%E9%9C%B2%E5%BA%94%E7%94%A8/image-20250103164743370.png)



```sh
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml
```

里面修改了镜像和端口号

参考 Github：[docker-module/src/main/resources/k8s-ingress-nginx/deploy.yaml](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-ingress-nginx/deploy.yaml)

执行 `kubectl apply -f deploy.yaml `

查看资源状态

```sh
kubectl get all -o wide -n ingress-nginx
```

![image-20250103163443695](images/06%E3%80%81Kubernetes%E9%9B%86%E7%BE%A4ingress%E6%9A%B4%E9%9C%B2%E5%BA%94%E7%94%A8/image-20250103163443695.png)

> 我不太清楚，为什么一直是 Completed 状态

查看nginx 类型

```sh
kubectl get ingressclass
```

创建 Nginx 应用

参考 GitHub：[docker-module/src/main/resources/k8s-ingress-nginx/nginx-dep.yaml](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-ingress-nginx/nginx-dep.yaml)