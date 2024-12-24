[toc]

### K8s-ConfigMap

作用：存储不加密的数据到 etcd，让Pod 以变量或挂载的方式使用

场景：配置文件



#### 1、创建配置文件

```
redis.host=127.0.0.1
redis.port=6379
redis.password=123456
```

#### 2、创建 Configmap

```sh
kubectl create configmap redis-config --from-file=redis.properties
```

查看 configmap

```sh
[root@master-01 configmap]# kubectl get configmap
NAME           DATA   AGE
redis-config   1      66s
[root@master-01 configmap]# kubectl get cm
NAME           DATA   AGE
redis-config   1      77s
```



```sh
[root@master-01 configmap]# kubectl describe cm redis-config
Name:         redis-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
redis.properties:
----
redis.host=127.0.0.1
redis.port=6379
redis.password=123456

Events:  <none>
```



#### 3、以 volume 挂载到 Pod 容器中

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: busybox
      image: busybox
      command: [ "/bin/sh","-c","cat /etc/config/redis.properties" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: redis-config
  restartPolicy: Never
```

创建完成之后，就 exec 进不去了，但是可以查看 logs



#### 4、以变量变量挂载

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
  namespace: default
data:
  special.level: info
  special.type: hello
```

执行： `kubectl apply -f myconfig.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: busybox
      image: busybox
      command: [ "/bin/sh","-c","echo $(LEVEL) $(TYPE)" ]
      env:
        - name: LEVEL
          valueFrom:
            configMapKeyRef:
              name: myconfig
              key: special.level
        - name: TYPE
          valueFrom:
            configMapKeyRef:
              name: myconfig
              key: special.type
  restartPolicy: Never
```

