> 2022-06-03

SpringFrameWork 5新特性，整个框架的代码基于 Java8.0，运行时兼容 JDK9



## 日志

Spring5.0框架自带了通用的日志封装，Spring5已经移除了 Log4jConfigListioner，官方建议使用 Log4j2，Spring框架整合 Log4j2

```xml
				<dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.11.2</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
            <version>2.11.2</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-slf4j-impl</artifactId>
            <version>2.11.2</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.30</version>
        </dependency>
```

在 `resrouce` 中创建 `log4j2.xml` 文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--日志级别 OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!--Configuration后面的 status 用于设置 log4j2 自身内部的信息输出，可以不设置，当设置为 trace时，可以看到 log4j2 内部各种详细输出-->
<configuration status="INFO">
    <appenders>
        <console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5leavel %logger{36} -%msg%n"/>
        </console>
    </appenders>
    <!--    然后定义 logger，只有定义了 logger 并没有引入 appender，appender才会生效-->
    <!--    root：用于指定项目的根日志，如果没有单独指定 Logger，则会使用root作为默认的日志输出 -->
    <loggers>
        <root level="info">
            <appender-ref ref="Console"/>
        </root>
    </loggers>
</configuration>
```



## 核心容器

支持 `@Nullable` 注解，可以用在方法、属性、参数上，表示可以返回空

`GenericApplicationContext` 函数式注册对象

```java
        GenericApplicationContext context = new GenericApplicationContext();
        context.refresh();
        context.registerBean(User.class,()->new User());
        User u = (User)context.getBean("com.Spring5.entity.User");
```

## Junit4

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:bean_1.xml")
public class SpringTest {

    @Autowired
    private DictService dictService;


    @Test
    public void test(){
        User user = new User("1", "Gogo", "V");
        dictService.addUser(user);
    }
}
```

使用 `@ContextConfiguration("classpath:bean_1.xml")` 代替了 ApplicationContext 获取容器部分，但是需要 Junit4 且版本至少 `4.12` 

