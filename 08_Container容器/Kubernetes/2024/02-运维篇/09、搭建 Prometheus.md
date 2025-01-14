# K8s 集群搭建 Prometheus

参考：[CSDN](https://blog.csdn.net/m0_51510236/article/details/132601350)

资源清单：[GitHub](https://github.com/YuncenLiu/code-example/tree/master/kubernetes/src/main/kube-prometheus-0.9.0)

镜像包：001-容器技术/001-kubernetes/001-镜像/prometheus.0.9.tar



## 0.13 版本无法启动

k8s-prometheus github 官网：https://github.com/prometheus-operator/kube-prometheus

参考版本，当 K8s-V1.28.0 对应最新 release-0.13

下载地址：

```sh
https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.13.0.tar.gz
```



解压后进入 manifests 目录，查询所有 image 镜像

```sh
grep -rn 'image: '
# 显示行号

grep -rh 'image: '
# 不显示文件名
```

![image-20250114215051561](images/09、搭建%20Prometheus/image-20250114215051561.png)



下载所有的镜像，去重之后又10个镜像

```sh
docker save -o prometheus.0.13.tar quay.io/prometheus/alertmanager:v0.26.0 \
quay.io/prometheus/blackbox-exporter:v0.24.0 \
jimmidyson/configmap-reload:v0.5.0 \
quay.io/brancz/kube-rbac-proxy:v0.14.2 \
grafana/grafana:9.5.3 \
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.9.2 \
quay.io/prometheus/node-exporter:v1.6.1 \
quay.io/prometheus/prometheus:v2.46.0 \
registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.1 \
quay.io/prometheus-operator/prometheus-operator:v0.67.1
```



百度网盘：001-容器技术/001-kubernetes/001-镜像/prometheus.0.13.tar





修改 kube-prometheus-0.13.0/manifests/alertmanager-service.yaml

![image-20250114222253256](images/09、搭建%20Prometheus/image-20250114222253256.png)



修改 kube-prometheus-0.13.0/manifests/grafana-service.yaml

![image-20250114222425956](images/09、搭建%20Prometheus/image-20250114222425956.png)



修改 kube-prometheus-0.13.0/manifests/prometheus-service.yaml

![image-20250114222520868](images/09、搭建%20Prometheus/image-20250114222520868.png)



进入 kube-prometheus-0.13.0 目录

```sh
kubectl apply --server-side -f manifests/setup

# 修改 namespace
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
	
# 全部运行
kubectl apply -f manifests/
```

查看运行情况

```sh
kubectl get all -n monitoring -o wide
```



![image-20250114222931047](images/09、搭建%20Prometheus/image-20250114222931047.png)





## 安装 0.9 版本正常启动



下载资源包

```sh
https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.9.0.tar.gz
```



替换镜像

```sh
# 查询镜像文件
grep -rn 'k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.1.1'
# 将查询到的文件，进行内容替换
grep -rl 'k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.1.1' . | xargs sed -i 's|k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.1.1|bitnami/kube-state-metrics:2.1.1|g'
# 查询替换后的文件
grep -rn 'bitnami/kube-state-metrics:2.1.1'

grep -rn 'k8s.gcr.io/prometheus-adapter/prometheus-adapter:v0.9.0'
grep -rl 'k8s.gcr.io/prometheus-adapter/prometheus-adapter:v0.9.0' . | xargs sed -i 's|k8s.gcr.io/prometheus-adapter/prometheus-adapter:v0.9.0|docker.io/willdockerhub/prometheus-adapter:v0.9.0|g'
grep -rn 'docker.io/willdockerhub/prometheus-adapter:v0.9.0'
```

安上述操作，可以实现



结论， 结合文档，无法安装 1.13 版本，安装 0.9 版本，虽然报错，但是依旧可以打开Granfa 

默认用户名密码为 admin/admin

![image-20250114231955260](images/09、搭建%20Prometheus/image-20250114231955260.png)

执行最后一步报错

![image-20250114232023101](images/09、搭建%20Prometheus/image-20250114232023101.png)





打开 Prometheus：http://192.168.126.4:30090/

打开 Grafana：http://192.168.126.4:30300/