### Mybatis SpringBoot 动态数据源

Spring 内置一个 **AbstractRoutingDataSource**，它可以把多个数据源配置成一个Map，然后根据不同的 key，返回不同的数据源，因为 **AbstractRoutingDataSource** 也是一个 DataSource 接口 ，因此，应用程序可以先设置好 key，访问数据库的代码就可以从 **AbstractRoutingDataSource** 拿到对应的一个真实数据源，从而访问指定数据库。

![这是 Spring 提供的类](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515131954037.png)

![关系依赖](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515132259057.png)

#### 分析成员变量

```java
	@Nullable
	// 存放多个数据源的 map 
	private Map<Object, Object> targetDataSources;

	@Nullable
	// 默认数据源
	private Object defaultTargetDataSource;

	private boolean lenientFallback = true;

	private DataSourceLookup dataSourceLookup = new JndiDataSourceLookup();

	@Nullable
	// 上面的 targetDataSources 也会在这里存一份
	// 区别就是 resolvedDataSources 是数据源解析后才会放到这个map里
	private Map<Object, DataSource> resolvedDataSources;

	@Nullable
	private DataSource resolvedDefaultDataSource;
```





### 案例

核心依赖

```xml
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.1.4</version>
        </dependency>
        <!-- oracle驱动 -->
        <dependency>
            <groupId>oracle.jdbc</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.4</version>
        </dependency>
        
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
```

因为 mybatis 和 oracle 并没有集成进 SpringBoot Starter 中，所以需要指定版本

这里忽略了  druid、springboot 等依赖。



```yaml
spring:
  druid:
    datasource:
      master:
        driver-class-name: com.mysql.cj.jdbc.Driver
        jdbc-url: jdbc:mysql://cloud:13388/test?useSSL=false&serverTimezone=UTC
        username: root
        password: root
      slave:
        driver-class-name: oracle.jdbc.OracleDriver
        jdbc-url: jdbc:oracle:thin:@cloud:11521:xe
        username: system
        password: oracle
```

编写两个数据源，同时存在 dept 表，创建 mapper、service、controller



#### 数据源读取配置

创建 MyDataSourceConfiguratioin 用于读取我们在 yaml 中配置的多数据源

```java
@Configuration
public class MyDataSourceConfiguratioin {

    @Bean("masterDataSource")
    @ConfigurationProperties(prefix = "spring.druid.datasource.master")
    DataSource masterDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean("slaveDataSource")
    @ConfigurationProperties(prefix = "spring.druid.datasource.slave")
    DataSource slaveDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @Primary
  	// 在Spring中，@Primary是一个注解，用于标记一个Bean作为优先选择的主要Bean。当多个相同类型的Bean被注册时，Spring框架会使用@Primary注解标记的那个Bean作为默认的Bean。这样就可以避免出现依赖注入歧义的问题
    DataSource primaryDataSource(
            @Autowired @Qualifier("masterDataSource") DataSource masterDataSource,
            @Autowired @Qualifier("slaveDataSource") DataSource slaveDataSource
    ) {
        Map<Object, Object> map = new HashMap<>();
        map.put("masterDataSource", masterDataSource);
        map.put("slaveDataSource", slaveDataSource);
        RoutingDataSource routing = new RoutingDataSource();
        routing.setTargetDataSources(map);
      	// 前面我们讲了 defaultTargetDataSource 是默认数据源
      	// targetDataSources 则是存放多个数据源的 map
        routing.setDefaultTargetDataSource(masterDataSource);
        return routing;
    }
}
```

创建 RoutingDataSource 实现 AbstractRoutingDataSource 来达到实现动态数据源功能

```java
public class RoutingDataSource extends AbstractRoutingDataSource {

    @Override
    protected Object determineCurrentLookupKey() {
        return RoutingDataSourceContext.getDataSourceRoutingKey();
    }
}
```

我们可以覆盖 determineCurrentLookupKey() 功能实现数据隔离。通过这个方法通过不同的key获取到不同的数据源。

```java
public class RoutingDataSourceContext  {

    // holds data source key in thread local:
    static final ThreadLocal<String> threadLocalDataSourceKey = new ThreadLocal<>();

  	// 如果没有，则默认使用 master 数据源，这样容错性高一点
    public static String getDataSourceRoutingKey() {
        String key = threadLocalDataSourceKey.get();
        return key == null ? "masterDataSource" : key;
    }

    public RoutingDataSourceContext(String key) {
        threadLocalDataSourceKey.set(key);
    }

    public void close() {
        threadLocalDataSourceKey.remove();
    }
}
```

> 这样我们就实现了数据源动态切换
>
> 当然还有最重要的一步！
>
> ```java
> @SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
> @MapperScan("com.liuyuncen.mapper")
> public class RoutingDatasourceApplication {
>  public static void main(String[] args) {
>      SpringApplication.run(RoutingDatasourceApplication.class,args);
>  }
> }
> ```
>
> 一定要排除 DataSourceAutoConfiguration 这个类，因为他会去获取默认的 DataSource 配置，因为我们已经改写了 yaml 配置（在里面添加了 master、slave 等，默认的 DataSource 不认识）
>
> 如果是 SpingCloud，也可以用下面这种情况
>
> ```java
> @EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class})
> @Configuration
> ```



测试Controller

```java
@GetMapping("/findAllProductM")
public String findAllProductM() {
  new RoutingDataSourceContext("masterDataSource");
  deptService.findAllProductM();
  return "success";
}
```

通过提前存储在 RoutingDataSource 中map，通过 key 获取到对应的数据源。这样mapper 接口中就会采用指定的数据源。



当然，如果不想通过 new RoutingDataSourceContext() 去获取，我们也可以优化成注解

#### 优化-采用注解方式

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RoutingWith {

    String value() default "master";
}

```

创建 RoutingWith 注解，默认使用 "master" 方式

使用动态代理，全局扫描 routingWith，在执行此方法前，通过 new RoutingDataSourceContext() 方式提前获取对应数据源

```java
@Aspect
@Component
public class RoutingAspect {

  @Around("@annotation(routingWith)")
  public Object routingWithDataSource(ProceedingJoinPoint joinPoint, RoutingWith routingWith) throws Throwable {
    String key = routingWith.value();
    RoutingDataSourceContext ctx = new RoutingDataSourceContext(key);
    return joinPoint.proceed();
  }
}
```



测试 Controller

```java
@RoutingWith("slaveDataSource")
@GetMapping("/findAllProductS")
public String findAllProductS() {
  deptService.findAllProductS();
  return "success";
}
```



给一张测试案例吧

![image-20230515164012497](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515164012497.png)



下面附上未展示的代码和代码结构

![实体层](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515164131507.png)

![dao层](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515164200358.png)

![Service层](images/2%E3%80%81SpringBoot%20%E5%8A%A8%E6%80%81%E6%95%B0%E6%8D%AE%E6%BA%90/image-20230515164227207.png)