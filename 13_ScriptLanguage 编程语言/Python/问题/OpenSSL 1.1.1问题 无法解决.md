
> 2024-06-24
> ImportError: urllib3 v2 only supports OpenSSL 1.1.1+, currently the 'ssl' module is compiled with 'OpenSSL 1.0.2k-fips 26 Jan 2017'. See: https://github.com/urllib3/urllib3/issues/2168


这个错误表明您的 `urllib3` 版本需要至少 OpenSSL 1.1.1，而目前您的 Python 环境使用的是 OpenSSL 1.0.2k。为了修复这个问题，您需要升级系统中的 OpenSSL 并确保 Python 使用新的 OpenSSL 版本。以下是具体步骤：

### 步骤 1: 升级 OpenSSL

首先，您需要安装 OpenSSL 1.1.1 或更高版本。由于 CentOS 7 默认存储库中的 OpenSSL 版本较旧，您可能需要启用 EPEL 和 IUS 存储库来安装更新的 OpenSSL。

#### 1.1. 安装 EPEL 和 IUS 存储库

bashCopy Code

```sh
yum install epel-release 
yum install https://repo.ius.io/ius-release-el7.rpm
```
`

#### 1.2. 安装 OpenSSL 1.1.1

bashCopy Code

`sudo yum install openssl11 openssl11-devel`

这会安装 OpenSSL 1.1.1 并将其放置在 `/usr/local/openssl11` 目录下。

### 步骤 2: 编译和安装 Python

您需要编译 Python，使其使用新安装的 OpenSSL 1.1.1。

#### 2.1. 安装编译 Python 所需的依赖包

```sh
sudo yum groupinstall "Development Tools" 
sudo yum install bzip2-devel libffi-devel zlib-devel
```

#### 2.2. 下载和解压 Python 源码

选择您需要的 Python 版本（以 Python 3.10 为例）：

```sh
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz 
tar -xvf Python-3.10.0.tgz 
cd Python-3.10.0
```

#### 2.3. 编译 Python

配置 Python 以使用新安装的 OpenSSL 1.1.1：

```sh
./configure --with-openssl=/root/package/openssl-1.1.1
make
make altinstall
```

注意：使用 `altinstall` 而不是 `install` 以避免覆盖系统默认的 Python 版本。

### 步骤 3: 验证新安装的 Python 和 OpenSSL

验证新安装的 Python 是否正确使用了 OpenSSL 1.1.1：

```sh
python3 -m ssl
```
您应该看到 OpenSSL 1.1.1 的相关信息。

### 步骤 4: 安装所需的 Python 包

您可以为新安装的 Python 设置虚拟环境，并在其中安装 `urllib3` 等包：

```sh
python3 -m venv datahub 
source datahub/bin/activate 
pip install urllib3
```