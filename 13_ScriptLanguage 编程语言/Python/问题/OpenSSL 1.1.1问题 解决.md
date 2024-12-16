> 抄自：
> 1. https://blog.csdn.net/2401_83739472/article/details/138969764
> 2. https://blog.csdn.net/2401_84009065/article/details/137691108

首先需要解决 `perl`，这是一种高级语言，`make test` 的执行时间会很长

```sh
wget https://www.cpan.org/src/5.0/perl-5.30.1.tar.gz
tar -xzf perl-5.30.1.tar.gz
cd perl-5.30.1
./Configure -des -Dprefix=/usr/loca/perl-5.30.1
make
make test
make install
```

下载 

```sh
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1.tar.gz

tar -zxvf openssl-1.1.1.tar.gz

cd openssl-1.1.1/

./config --prefix=/usr/local/openssl-1.1.1
# 这一步会提示安装 perl5，需要完成上面的操作，不报错，再往下走

make
make install
```

替换默认的 opensll

```sh
#　查看版本
openssl version

# 备份
mv /usr/bin/openssl /usr/bin/oldopenssl
ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl-1.1.1/lib/libssl.so.1.1 /usr/lib64/
ln -s /usr/local/openssl-1.1.1/lib/libcrypto.so.1.1  /usr/lib64/
```

在 ~ 路径下执行 `openssl version` 查看版本

再安装python