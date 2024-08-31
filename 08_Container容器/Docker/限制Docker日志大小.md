> 创建于2022年3月31日
> 来源 https://www.cnblogs.com/sxdcgaq8080/p/10689223.html

[toc]

### 设置docker容器日志文件大小

编辑 `vim /etc/docker/daemon.json` 文件

```sh
vim /etc/docker/daemon.json
```

内容如下

```json
{
  "log-driver":"json-file",
  "log-opts": {"max-size":"500m", "max-file":"3"}
}
```

max-size=500m，意味着一个容器日志大小上限是500M， 

max-file=3，意味着一个容器有三个日志，分别是id+.json、id+1.json、id+2.json。

### 重启

```sh
systemctl daemon-reload
systemctl restart docker
```

