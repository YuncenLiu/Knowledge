> 创建于 2022年4月3日
>
> 作者：想想

[toc]



### 查询Python版本

默认情况下，Linux都会自带Python，可以利用 `python --version` 查看版本信息

```sh
python --version
```

### 下载 Python 3.6.5

[Python3.6.5.tar](https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz)

下载地址：https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz

也可以登录https://www.python.org/downloads/source/，找到自己需要的版本

### 安装

解压

```sh
tar -zxvf Python-3.6.5.tgz
```

准备编译环境

```sh
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
```

编译安装

```sh
./configure --prefix=/usr/local/Python-3.8.2
# /usr/local/Python-Python-3.8.2    这个路径是Python 即将安装的位置
make
make install
```

删除原先的软连接

```sh
rm -rf /usr/bin/python
```

建立新的软连接

```sh
ln -s /usr/local/Python-3.8.2/bin/python3.8 /usr/bin/python3
ln -s /usr/local/Python-3.8.2/bin/pip3 /usr/bin/pip
```



### 测试

```sh
[root@super ~]# python --version
Python 3.8.2
```

