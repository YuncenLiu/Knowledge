> 创建于 2021 年7月 26日
>
> 作者：想想



[toc]



## 查看Linux 配置

### 1、CPU

​		查看物理CPU个数

```sh
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
```

​		查看 CPU 中的核数 CORE

```sh
cat /proc/cpuinfo| grep "cpu cores"| uniq
```

​		查看逻辑CPU个数

```sh
cat /proc/cpuinfo| grep "processor"| wc -l
```



## 查看Linux版本

查看centos版本

```sh
rpm -q centos-release
```

