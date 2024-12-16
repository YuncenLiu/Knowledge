> 创建于2021年12月17日
> 		作者：想想
> 		来源：[Nacos官网](https://nacos.io/zh-cn/docs/what-is-nacos.html)

[toc]

### 前言

Nacos和微服务息息相关，昨天想搭建一个Nacos的集群环境，一个下午都没搭建成，今天特地去官网、全面性的学习nacos相关的属性和配置，特此记录

> 当前环境：Mac、JDK1.8、MySQL8.0+、Maven3.5、Nacos（下载新的）

# 什么是Nacos

## 1、概览

Nacos致力于帮助我们发现、配置和管理微服务。Nacos支持几乎所有主流类型的“服务”的发现、配置管理工作

### 1.1、服务发现和服务健康检测

Nacos支持基于DNS和基于RPC的服务发现，服务提供者使用原生 SDK、OpenAPI方式注册Service后，服务消费者可以使用DNS TODO或HTTP&API查找和发现服务

Nacos提供对服务的健康检测功能，阻止向不健康的主机或服务实例发送请求，Nacos支持传输层（PING或TCP）的应用层的健康检测。

### 1.2、动态配置服务

配置程序所需要的参数，管理所有环境内的应用配置和服务配置

### 1.3、动态DNS服务

动态DNS服务支持权重路由，更容易实现中间层负载均衡，动态DNS服务还能让您更容易地实现以DNS协议为基础的服务发现，以帮助您消除耦合到厂商私有服务发现API的风险

![https://nacos.io/img/nacosMap.jpg](images/nacosMap.jpg)

## 2、启动Nacos

官网地址：[https://github.com/alibaba/nacos/releases](https://github.com/alibaba/nacos/releases)下载任意版本，我这里下载了当前最新版本`V2.0.3`

```sh
tar -zxvf nacos-server-2.0.3.tar.gz
```

解压后，进入到`bin`目录，单机启动，不加参数默认以集群形式启动。

```sh
./start -m standalone
```

### 2.1、服务注册&发现和配置管理

### 服务注册

```
curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
```

### 服务发现

```
curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'
```

### 发布配置

```
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=HelloWorld"
```

### 获取配置

```
curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
```

![image-20211217102426406](images/image-20211217102426406.png)

我们也可以通过访问 `localhost:8848/nacos` 进行页面配置

