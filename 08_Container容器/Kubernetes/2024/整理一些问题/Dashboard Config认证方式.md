

# Dashboard Config 认证方式



## Dashboard

官网地址

下载配置文件：https://github.com/kubernetes/dashboard/blob/v2.7.0/aio/deploy/recommended.yaml

对配置文件如下修改







在 kube-system 创建 sa

```sh
kubectl create serviceaccount dashboard-admin -n kube-system
```





> 2024-12-30 无法创建 ，没有结论
