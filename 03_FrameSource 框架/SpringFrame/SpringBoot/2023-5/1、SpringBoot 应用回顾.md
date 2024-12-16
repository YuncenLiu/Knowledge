> 2023年4月26日 拉钩教育

[toc]

# SpringBoot应用回顾

## 一、概念

### 1、约定优于配置思想

就像大家开发都创 maven 型目录结构，把 java 代码都放在 src 下

偏离配置：数据库表名 t_user 对象名 user



## 二、SpringBoot 案例实现

### 1、解决乱码问题

统一处理请求和响应的编码格式

```properties
spring.http.encoding.enabled=true
spring.http.encoding.charset=UTF-8
spring.http.encoding.force-response=true
```



### 2、热部署

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
        </dependency>
```

IDEA 中还需要设置，Eclipse 就不需要

![image-20230427112040338](images/1%E3%80%81SpringBoot%20%E5%BA%94%E7%94%A8%E5%9B%9E%E9%A1%BE/image-20230427112040338.png)

好像没有什么锤子用







