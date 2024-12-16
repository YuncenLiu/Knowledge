> 创建于2021年9月29日
> 作者：想想

[toc]



### 下拉镜像

```sh
docker pull jenkins/jenkins:lts-jdk11
# 本地环境下 jekins 镜像编码
# 619aabbe0502 

# Array 环境
# a94b49bb279b
```

### 启动镜像

#### Mac 环境

```sh
docker run -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home 
```

+ 8080 是 jenkins 网页访问端口
+ /Users/xiang/xiang/docker/jenkins

```http
https://testerhome.com/topics/5798
```

#### Windows 环境（Array）

```sh
docker run --name jenkins -it -d  -p 8090:8080 -p 50000:50000 -u 0 -v /usr/local/docker/jenkins:/var/jenkins_home  a94b49bb279b
```

+ 8080 是 jenkins 网页访问端口
+ /usr/local/docker/jenkins

##### 密码文件

```sh
/var/jenkins_home/secrets/initialAdminPassword
```

