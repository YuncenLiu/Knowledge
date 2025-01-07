## Configmap

[toc]

保存配置文件，创建方式

1. 命令行创建， --from-literal
2. 指定文件， configmap --from-file = 文件
3. 指定目录创建，将一个目录下所有配置文件创建为 configmap
4. 写 yaml 文件，kubectl apply -f 创建



#### 命令行创建

```sh
kubectl create configmap xiang-map --from-literal=xiang.config=world

# 一次性创建多个
kubectl create configmap xiang-map1 \
	--from-literal=xiang.config1=world1 \
	--from-literal=xiang.config2=world2
```

查看 configmap

```sh
kubectl get configmap xiang-map -o go-template='{{.data}}'
```

查看详情

```sh
kubectl describe configmaps xiang-map
```



#### 配置文件方式

当前目录创建 jdbc.yaml

```sh
kubectl create configmap my-app --from-file=application.yml
```

创建配置文件，将一个目录下的都变成配置文件

```sh
kubectl create configmap my-app --from-file=/root/src/k8s-configmaps/
```



#### YAML方式创建



```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: yun-configmap-map
data:
  jdbc.driverclass: com.mysql.jdbc.Driver
  jdbc.url: jdbc:mysql://localhost:3306/test
  jdbc.username: root
  jdbc.password: admin
```



## mariadb 使用 configmap 案例

创建一个容器，用于获取 mariadb 初始化配置文件

```
docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=123456 -d  registry.cn-beijing.aliyuncs.com/yuncenliu/mariadb:10.5.2
```

将容器内配置文件拷贝出

```sh
mkdir -p container/mariadb
docker cp some-mariadb:/etc/mysql/my.cnf ~/container/mariadb/
```

将3306替换为3307

```sh
sed -i 's/3306/3307/g' ~/container/mariadb/my.cnf
```

k8s 将 my.conf 创建为 configmap

```sh
kubectl create configmap mariabd-config --from-file=/root/container/mariadb/my.cnf
```

反向生成 yaml 文件

```sh
kubectl get configmaps mariabd-config -o yaml>mariadb-configmap.yml
```



