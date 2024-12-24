# yum 安装到本地



```sh
yum install --downloadonly --downloaddir=/root/yum  --setopt=keepcache=1 zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
```



yum 查看已经安装的工具

```sh
yum list installed | grep kube
```

