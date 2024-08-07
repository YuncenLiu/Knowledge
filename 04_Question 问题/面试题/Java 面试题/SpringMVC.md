---

---



[TOC]



## 1、SpringMVC 相关面试题

### 1.1、SpringMVC 常用注解及原理

#### 1.1.1、==@Controller==

​		在 SpringMVC 中，控制器 Controller 负责处理 DispathcherServlet 分发的请求，它把用户请求的数据经过业务处理层之后封装成一个 Model（ModelAndView)，然后再把这个 Model 返回给对应的 View 进行展示。此外 Controller 不会直接依赖于 HttpServletRequest 和 HttpServletResponse 等 HttpServlet 对象，它们可以通过 Controller 的方法参数灵活的获取到。

​		@Controller 标记在一个类上海不能真正意义上的说它就是 SpringMVC的一个控制器类，因为这个时候 Spring 还不认它，解决的办法有两种

1. 在 SpringMVC 的配置文件中定义 MyController 的 bean 对象

     ```xml
     <bean class="press.xiang.app.web.MyController "/>
     ```

2. 在 SpringMVC 的配置文件中告诉 Spring 该到哪里去找标记为 @Controller 的 Controller 控制器 (这种方式将会扫描配置多个 Controller)

     ```xml
     <context:component-scan base-package = "press.xiang.app.web"/>
     ```



#### 1.1.2、==@RequestMapping==

​		RequestMapping 是用来处理请求地址映射的注解，可用于类或方法上，用于类上，表示类中的响应请求方法都作为他的父路径、@ReuqestMapping 注解有6个属性，主要可分为三类

##### 1、value  method

value：指定请求的实际路径，执行的地址可以是 URL Template模式

method：指定请求的 method 类型，GET、POST、PUT、DELETE 等

##### 2、consumes，produces

consumers：指定处理请求的提交内容类型（Content-Type)，例如 application/json , text/html

produces：指定返回的内容类型，仅当requset 请求头中的 （Accept）类型中包含指定类型才返回

##### 3、params，headers

params：指定request中必须包含某参数值是xxx，才让该方法去处理

headers：请求 request 中必须包含指定的 header 值，才让改方法处理请求。



#### 1.1.3、@Resource 和 @Autowired

​		这两个注解都是 bean 在注入的时候使用，其中 @Resource 不是 Spring 的注解，它的包是 javax.annotaion.Resource 需要导入，但是 Spring 也支持该注解的注入

+ 共同点：

     两者读可以写在字段和 setter 方法上，两者如果都写在字段上，那么就不需要写 setter 方法

+ 不同点

     + ==@Autowired==

          @AutoWired 为 Spring提供的注解，需要导入 org.springframwork.beans.facotry.annotaion.Autowired;==只按 byType 注入==，默认情况下它要求依赖对象必须存在，如果允许为 null 值，可以设置它的 required 属性为 false，如果我想使用按照名称 （byName）来配置，可以结合 ==@Qualifier== 注解一起使用，

     + ==@Resource==

          默认按 ByName 自动注入，由J2EE提供，需要导入 javax.annotation.Resource ，它有两个重要属性，name 和 type，而 Spring 将 @Resource 注解的 name 属性解析为 bean 的名字，而 type 属性则解析为 bean 的类型。

> 注：最好是将 @Resource 放在 setter 方法上，因为这样更符合面向对象思想，通过 set get 去操作属性，而不是直接去操作属性
>
> 1. @Resource 装配顺序
> 2. 如果同时指定 name 和 type，则从 Spring 上下文中找到唯一匹配的 bean 进行装配，找不到就抛异常
> 3. 如果指定了name，则从上下文查找名称 id 匹配的 bean 进行装配，找不到则抛出异常
> 4. 如果指定了type，则从上下文找到类型匹配的唯一bean进行装配，找不到或
>
> // https://www.cnblogs.com/leskang/p/5445698.html