> 创建于 2021年11月8日
> 作者：想想

[toc]



## 环境准备

`已部署 Jenkins并成功访问管理页面`、`JDK`、`Git` 、`Maven`

```
jdk  /usr/local/java/jdk1.8.0_181
git  /usr/libexec/git-core/git
maven  /usr/local/maven/apache-maven-3.8.3
gitee   https://gitee.com/Array_Xiang/jenkins-test.git
```



## 一、配置环境

Manage Jenkins > Global Tool Configuration

![image-20211108132802365](images/image-20211108132802365.png)

### 1.1、配置JDK

![image-20211108132832447](images/image-20211108132832447.png)

### 1.2、配置Git

![image-20211108132850507](images/image-20211108132850507.png)

### 1.3、配置Maven

![image-20211108132904782](images/image-20211108132904782.png)

## 二、部署项目

我们部署一套 maven 项目，默认新建项目没有 maven 项目选项，我们需要去安装 `Maven Integration` 插件

==这里选两个 Config File Provider 和 Maven Integration==

Maven Integration 是方便构建 maven 项目用的

![image-20211108134236608](images/image-20211108134236608.png)

### 2.1、新建项目

输入项目名称

![image-20211108134356991](images/image-20211108134356991.png)

### 2.2、勾选丢弃旧的构建

选择是否备份被替换的旧包。我这里选择备份最近的10个

![image-20211108134601613](images/image-20211108134601613.png)

### 2.3、源码管理，配置Git相关信息

`https://gitee.com/Array_Xiang/jenkins-test.git`

![image-20211108134828107](images/image-20211108134828107.png)

### 2.4、勾选 `Add timestamps to the Console Output`

代码构建的过程中会将日志打印出来

![image-20211108134934880](images/image-20211108134934880.png)

### 2.5、在Build中输入打包前的mvn命令

```sh
clean install
```

![image-20211108142550031](images/image-20211108142550031.png)

### 2.6、Post Steps 

选择 Run only if build succeeds

选择 Excute Shell

![image-20211108142751523](images/image-20211108142751523.png)

```sh
sh /home/Xiang/jenkins/bin/stop.sh
BUILD_ID=dontKillMe nohup java -jar /home/Xiang/.jenkins/workspace/SpringBoot/target/jenkins_test-v1.jar > /home/Xiang/jenkins/logs/jenkins_test-v1.log 2>&1 &
```



stop.sh

```sh
#!/bin/bash
echo "Stop SpringBoot Application"
pid=`ps -ef | grep jenkins_test-v1 | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then 
 kill -9  $pid
fi
```

![image-20211109164527947](images/image-20211109164527947.png)

![image-20211109164543548](images/image-20211109164543548.png)

