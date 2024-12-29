| IP              | host          | path      |
| --------------- | ------------- | --------- |
| 192.168.111.170 | k8s-matsrt-01 | /data/nfs |
| 192.168.111.171 | k8s-node-01   | /data/nfs |
| 192.168.111.172 | k8s-node-02   | /data/nfs |



### 安装工具

#### master 节点执行

```sh
 yum install -y nfs-utils
```

如果目录不存在，则创建目录

```sh
mkdir -p /data/nfs
```

配置挂载权限 `/etc/exports`

```
/data/nfs 192.168.111.171(rw,sync,no_subtree_check,no_root_squash)  192.168.111.172(rw,sync,no_subtree_check,no_root_squash)
```

- `rw`：允许读写。
- `sync`：同步写入，保证数据写入磁盘后才返回响应。
- `no_subtree_check`：避免对子目录进行检查，提升性能。
- `no_root_squash`：允许远程 `root` 用户访问共享目录时具有本地 `root` 用户的权限。

启动挂载服务

```sh
systemctl start nfs-server
```



#### node 节点执行

```sh
mkdir -p /data/nfs
```

挂载 NFS

```sh
mount 192.168.111.170:/data/nfs /data/nfs
```

编辑自动挂载，避免重启后丢失` /etc/fstab`

```sh
192.168.111.170:/data/nfs /data/nfs nfs defaults 0 0
```



子节点执行 df -h 查看挂载情况，等进行 读写相关测试验证

![image-20241229195841153](images/NFS挂载共享目录/image-20241229195841153.png)

