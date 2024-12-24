[toc]



### K8s 集群安全机制

访问 K8s 集群的时候，要经过三步操作

+ 认证
+ 鉴权
+ 准入控制



传输安全：对外不暴露 8080 端口，对外使用 6443  

认证常用三种方式

+  基于 ca 证书的 https 认证
+ http token 认证
+ http 基本的 用户名 + 密码认证

鉴权 （RBAC）





#### 1、创建命名空间

```sh
kubectl create ns roledemo
```



#### 2、在新创建的命名空间创建 pod

```sh
[root@master-01 ~]# kubectl run nginx --image=nginx -n roledemo
pod/nginx created
```



#### 3、创建角色

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: roledemo
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get","watch","list"]
```

```sh
[root@master-01 rbac]# kubectl apply -f rbac-role.yaml 
role.rbac.authorization.k8s.io/pod-reader created
[root@master-01 rbac]# kubectl get role -n roledemo
NAME         CREATED AT
pod-reader   2022-12-20T01:44:49Z
```



#### 4、创建角色绑定

```yam
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: roledemo
subjects:
- kind: User
  name: Lucy
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```



```sh
[root@master-01 rbac]# kubectl get role,rolebinding -n roledemo
NAME                                        CREATED AT
role.rbac.authorization.k8s.io/pod-reader   2022-12-20T01:44:49Z

NAME                                              ROLE              AGE
rolebinding.rbac.authorization.k8s.io/read-pods   Role/pod-reader   30s
```

