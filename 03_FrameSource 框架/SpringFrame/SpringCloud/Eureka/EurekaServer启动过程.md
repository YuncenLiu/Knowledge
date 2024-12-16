> 2023年6月27日

在 **org.springframework.cloud:spring-cloud-netfix-erueka-server:2.1.0.RELEASE** 包中，我们可以发现有 `spring.factories` 文件 这是SpringBoot 特性

自动装配了 **EurekaServerAutoConfiguration** 类

```java
@Import(EurekaServerInitializerConfiguration.class)
@ConditionalOnBean(EurekaServerMarkerConfiguration.Marker.class)
@EnableConfigurationProperties({ EurekaDashboardProperties.class,InstanceRegistryProperties.class })
@PropertySource("classpath:/eureka/server.properties")
public class EurekaServerAutoConfiguration extends WebMvcConfigurerAdapter {...}
```

1. EurekaServerMarkerConfiguration.Marker bean 哪里来的
2. EurekaServerAutoConfiguration 做了什么
3. 为什么导入 EurekaServerInitializerConfiguration 这个配置类

带着三个问题，往下走

### 1、为什么需要 Marker bean

在 SpringBoot 启动类中，一般我们会写 `@EnableEurekaServer` 注解表示这是 Eureka 的服务端

点进这个注解，我们最终会发现这样代码

![image-20230627141448204](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627141448204.png)

所以前提条件，就是需要有一个 Marker Bean 才能装配 Eureka Server，Marker bean 是由  `@EnableEurekaServer`  注解决定的。只有存在这个注解，才会有后续操作！

### 2、EurekaServerAutoConfiguration 做了什么

#### 2.1、仪表盘

```yml
eureka:
  dashboard:
    enabled: false # 默认为true
```

![image-20230627141955233](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627141955233.png)

#### 2.2、对等节点注册器

![image-20230627142207760](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627142207760.png)

集群模式下注册服务使用到的注册器。注意：**EurekaServer 集群中各个节点是对等的，没有主从之分**

#### 2.3、对等节点操作

![image-20230627142403104](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627142403104.png)

注入 PeerEurekaNodes ，辅助封装对等节点相关信息和操作，比如更新集群中的对等，在 PeerEureakNodes 中存在一个线程池

![image-20230627142723659](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627142723659.png)

而 EurekaServerContext 执行了 start 方法

![image-20230627144120206](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627144120206.png)

### 3、EurekaServerInitializerConfiguration 干了什么

这个类第71行代码，执行了 

![image-20230627150636172](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627150636172.png)

在 context 细节中，为 Ioc 容器提供 serverContext 对象接口，更新实例状态为 UP并对外提供服务。

![image-20230627150918425](images/EurekaServer%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B/image-20230627150918425.png)

再下面就不细讲了... 大致做了连接重试功能，获取其他 server 注册信息，把远程注册信息同步到自己的注册表中，这里的注册表是一个 

```java
private final ConcurrentHashMap<String, Map<String, Lease<InstanceInfo>>> registry = new ConcurrentHashMap();
```

各种判断，启动UP状态，剔除失效任务。