前期准备工作：MHA 集群至少4台机器

1主、2从、1管理

+ 192.168.58.195  master 主库、可读可写
+ 192.168.58.196 salve-01 从库  只读
+ 192.168.58.197 salve-02 从库  只读
+ 192.168.58.198 manager 管理库



## 创建服务器

> 192.168.58.195

安装下载工具

```sh
yum install -y wget
```

下载 mysql

```sh
wget https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
```

移除 CentOS 自带 mariabd-lib 依赖，避免冲突

```sh
[root@centos ~]# rpm -qa|grep mariadb
mariadb-libs-5.5.68-1.el7.x86_64
[root@centos ~]# rpm -e mariadb-libs-5.5.68-1.el7.x86_64  --nodeps
```

> rpm 常用命令
>
> ```sh
> -i, --install 安装软件包
> -v, --verbose 可视化，提供更多的详细信息的输出
> -h, --hash 显示安装进度
> -U, --upgrade=<packagefile>+ 升级软件包
> -e, --erase=<package>+ 卸载软件包
> --nodeps 不验证软件包的依赖
> ```
>
> 组合可以得到以下命令
>
> ```sh
> 安装软件：rpm -ivh rpm包名
> 升级软件：rpm -Uvh rpm包名
> 卸载软件：rpm -e rpm包名
> 查看某个包是否被安装 rpm -qa | grep 软件名称
> ```
>
> 

## 安装MySQL

解压 tar包

```sh
tar xvf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
```

需要严格安装顺序执行

```sh
rpm -ivh mysql-community-common-5.7.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-compat-5.7.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-client-5.7.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-server-5.7.28-1.el7.x86_64.rpm
rpm -ivh mysql-community-devel-5.7.28-1.el7.x86_64.rpm
```

> 执行到第5步报错
>
> ```sh
> [root@centos ~]# rpm -ivh mysql-community-server-5.7.28-1.el7.x86_64.rpm
> 警告：mysql-community-server-5.7.28-1.el7.x86_64.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
> 错误：依赖检测失败：
>         /usr/bin/perl 被 mysql-community-server-5.7.28-1.el7.x86_64 需要
>         net-tools 被 mysql-community-server-5.7.28-1.el7.x86_64 需要
>         perl(Getopt::Long) 被 mysql-community-server-5.7.28-1.el7.x86_64 需要
>         perl(strict) 被 mysql-community-server-5.7.28-1.el7.x86_64 需要
> ```
>
> 处理方案：
>
> ```sh
> yum install -y perl-Module-Install.noarch
> yum install -y net-tools 
> ```

### 查看 MySQL服务

```sh
[root@centos ~]# systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
```

发现 MySQL 服务已经安装成功，但是没有启动

## 启动MySQL

初始化用户

```sh
mysqld --initialize --user=mysql
```

查看用户密码

```sh
[root@centos ~]# cat /var/log/mysqld.log | grep password
2023-08-11T03:36:39.052992Z 1 [Note] A temporary password is generated for root@localhost: e<du&o//-9,K
```

**启动服务**

```sh
systemctl start mysqld
```

设置开机自启

```sh
systemctl enable mysqld
```

再次验证

```sh
[root@centos ~]# systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since 五 2023-08-11 11:37:29 CST; 34s ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
 Main PID: 1519 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─1519 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

8月 11 11:37:28 centos systemd[1]: Starting MySQL Server...
8月 11 11:37:29 centos systemd[1]: Started MySQL Server.
```

MySQL 正常启动

### 修改默认密码

```sh
mysql -uroot -p
xxxxxx输入初始密码 (e<du&o//-9,K)
mysql> SET PASSWORD = PASSWORD('123456');
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

### 关闭防火墙

```sh
systemctl stop firewalld
```

开机关闭

```sh
systemctl disable firewalld
```

