# 安装 MetaILB负载均衡器

> 2025-01-03

参考：[CSDN](https://blog.csdn.net/m0_51510236/article/details/130842122)



[toc]

metallb是用于kubernetes的Service暴露LoadBalancer的负载均衡器，官网地址：https://metallb.universe.tf/installation/

查看 `configmaps` 配置文件

```sh
kubectl get configmaps -n kube-system 
```

修改 `configmaps`

```sh
kubectl edit configmap -n kube-system kube-proxy
```

![image-20250103150525854](images/%E5%AE%89%E8%A3%85MetaILB%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%99%A8/image-20250103150525854.png)

下载 资源清单

```sh
https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
```

提前下载镜像

```sh
docker pull quay.io/metallb/speaker:v0.13.9
docker pull quay.io/metallb/controller:v0.13.9
```

执行

```sh
kubectl apply -f ./
```

查看执行情况

```sh
watch kubectl get all -n metallb-system -o wide
```

![image-20250103151737585](images/%E5%AE%89%E8%A3%85MetaILB%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%99%A8/image-20250103151737585.png)



## 为MetalLB分配IP地址

新增 metallb-ip-pool.yaml

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  # 注意改为你自己为MetalLB分配的IP地址
  - 192.168.58.170-192.168.58.171

---

apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```



## 部署应用

创建一个 Nginx

```sh
kubectl create deployment nginx --image=registry.cn-beijing.aliyuncs.com/yuncenliu/nginx:1.19.2-alpine
```

查看 Nginx 部署情况

```sh
kubectl get deploy,pod -o wide
```

创建 LoadBalancer 给外网，将 nginx 暴露到外网

```sh
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

查看外网IP地址

```sh
 kubectl get svc,deployment,po
```

![image-20250103154622447](images/%E5%AE%89%E8%A3%85MetaILB%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%99%A8/image-20250103154622447.png)

访问 http://192.168.58.170/ 查看效果

