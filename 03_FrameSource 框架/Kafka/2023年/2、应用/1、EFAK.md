## EFAK 搭建



## kafka-eagle



> 参考地址：https://blog.csdn.net/wngpenghao/article/details/128470697
>
> https://blog.csdn.net/weixin_43398645/article/details/131613727

**EFAK** 下载地址：[https://github.com/smartloli/kafka-eagle-bin/releases](https://link.zhihu.com/?target=https%3A//github.com/smartloli/kafka-eagle-bin/releases)

```properties
efak.zk.cluster.alias=cluster1
cluster1.zk.list=hadoop01:2181,hadoop02:2181,hadoop03:2181/kafka

efak.driver=com.mysql.cj.jdbc.Driver
efak.url=jdbc:mysql://mysql:3306/ke?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai&allowMultiQueries=true
efak.username=root
efak.password=123456
```

数据库建表语句参考：https://blog.csdn.net/wngpenghao/article/details/128470697

![image-20231102151637941](images/1%E3%80%81EFAK/image-20231102151637941.png)

