

### 使用 Ingress 对外暴露应用



#### 1、一般用法

创建 Nginx 应用

~~~sh
[root@master-01 ~]#  kubectl create deployment web --image=nginx
deployment.apps/web created
[root@master-01 ~]# kubectl get pod
NAME                   READY   STATUS              RESTARTS   AGE
web-5dcb957ccc-57b4z   0/1     ContainerCreating   0          5s
~~~



~~~sh
[root@master-01 ~]# kubectl expose deployment web --port=80 --target-port=80 --type=NodePort
service/web exposed
[root@master-01 ~]# kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        90d
web          NodePort    10.107.226.196   <none>        80:30198/TCP   10s
~~~



#### 2、使用 Ingress 创建