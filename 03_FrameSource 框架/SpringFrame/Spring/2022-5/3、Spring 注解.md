> 2022年5月24日

[toc]

## Spring针对Bean管理创建对象

`@Component`

`@Service` 用在业务逻辑层

`@Controller` 用在控制层

`@Repository` 用在dao层

上面四个注解的功能都是一样的，都可以用来创建bean实例

需要引入 AOP 依赖，开启组件扫描

```xml
    <!-- 开启组件扫描 -->
    <context:component-scan base-package="com.liuyuncen.spring5"/>
```

`use-default-filters="false"` 加上这个后，需要自己配置规则

```xml
    <context:component-scan base-package="com.liuyuncen.spring5" use-default-filters="false">
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>
```

`include` 扫描包含以下内容，

`type="annotation" expression="org.springframework.stereotype.Controller"` 扫描带 Controller 的 注解

```xml
   <context:component-scan base-package="com.liuyuncen.spring5" >
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>
```

`context:exclude-filter`  设置以下内容不去扫描

## 基于注解方式实现属性注入

`@Autowired` 根据属性类型进行自动装配

`@Qualifier` 根据属性名称进行注入

`@Resource` 可根据类型注入，可根据名称注入，Java 原生的，`@Resource(name="")` 这样就可以根据名称注入，不写name就是默认类型注入

`@Value` 注入普通类型属性

## 完全注解开发

创建配置类，使用 `@Configuration`，可替代 xml 配置文件

```java
@Configuration
@CompoentScan(basePackages = {"com.liuyuncen"})
public class SpringConfig{
  
}
```

测试类这时候就用的是 `AnnotationConfigApplicationContext`

```java
        ApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);
```

