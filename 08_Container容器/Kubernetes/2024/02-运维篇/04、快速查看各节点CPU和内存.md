## Kubectl 快速查看各节点CPU和内存

参考 [CSDN](https://blog.csdn.net/m0_51510236/article/details/142641660?spm=1001.2014.3001.5502)

> 2025-01-03

```sh
kubectl top node
```

默认执行结果返回：error: Metrics API not available



### 安装 metrics-server`，`metrics-server

Github地址：https://github.com/kubernetes-sigs/metrics-server

对应版本信息

![image-20250103095009834](images/04%E3%80%81%E5%BF%AB%E9%80%9F%E6%9F%A5%E7%9C%8B%E5%90%84%E8%8A%82%E7%82%B9CPU%E5%92%8C%E5%86%85%E5%AD%98/image-20250103095009834.png)



下载 YAML 文件

```sh
https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

在 metrics-server Deployment 中 spec.template.spec.containers.arg 中添加

```sh
--kubelet-insecure-tls
```

![image-20250103095240582](images/04%E3%80%81%E5%BF%AB%E9%80%9F%E6%9F%A5%E7%9C%8B%E5%90%84%E8%8A%82%E7%82%B9CPU%E5%92%8C%E5%86%85%E5%AD%98/image-20250103095240582.png)

镜像改成自己的镜像，记得添加  secrets

```
# 旧的
registry.k8s.io/metrics-server/metrics-server:v0.7.2

# 更好成自己的
registry.cn-beijing.aliyuncs.com/yuncenliu/metrics-server:v0.7.2
```

```yaml
imagePullSecrets:
  - name: aliyun-yuncen
```

将 metrics-server Deployment 中 spec.template.spec.containers.hostNetwork 中添加

```sh
hostNetwork: false
```

![image-20250103101040316](images/04%E3%80%81%E5%BF%AB%E9%80%9F%E6%9F%A5%E7%9C%8B%E5%90%84%E8%8A%82%E7%82%B9CPU%E5%92%8C%E5%86%85%E5%AD%98/image-20250103101040316.png)

提交至 [Github](https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-metrics-server/components.yaml) 

```sh
https://github.com/YuncenLiu/code-example/blob/master/docker-module/src/main/resources/k8s-metrics-server/components.yaml
```



```sh
kubectl create secret docker-registry aliyun-yuncen \
  --docker-server=registry.cn-beijing.aliyuncs.com \
  --docker-username=array_xiang \
  --docker-password=546820.0@lyc \
  --docker-email=array_xiangxiang@163.com \
  --namespace=kube-system
```

最后 kubectl apply -f  执行，等 pod 运行成功后

重新执行

```sh
kubectl top node
```

![image-20250103103053556](images/04%E3%80%81%E5%BF%AB%E9%80%9F%E6%9F%A5%E7%9C%8B%E5%90%84%E8%8A%82%E7%82%B9CPU%E5%92%8C%E5%86%85%E5%AD%98/image-20250103103053556.png)

