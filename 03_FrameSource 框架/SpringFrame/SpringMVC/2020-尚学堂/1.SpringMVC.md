## 1、SpringMVC 简介

1. SpringMVC中重要组件

     1. DispatcherServlet：前端控制器，接收所有请求（如果配置 / 不包含 JSP）
     2. HandlerMapping：判断请求格式的，判断希望要执行哪个具体的方法
     3. HandlerAdapter：负责调用具体的方法。
     4. ViewResovler：视图解析器，解析结果，准备跳转到具体的物理视图。

2. SpringMVC 运行原理

     ```mermaid
     graph LR
     A(用户)-->B[DsiptcherServlet]
     B-->C[HandlerMapping]
     C-->D[HandlerAdapter]
     D-->E(Controller)
     E-->F[ViewResovler]
     F-->A
     ```

3. Spring容器和 SpringMVC容器之间的关系

     1. 代码

     ![image-20200717130128935](images/SpringMVC%20%E5%92%8C%20Spring%20%E5%AE%B9%E5%99%A8.png)

     2. Spring 容器和 SpringMVC 容器是父子容器
          1. SpringMVC 容器中能调用 Spring 容器中所有内容
          2. ![image-20200717192759598](images/SpringMVC%20%E5%92%8C%20Spring%E5%AE%B9%E5%99%A8%E5%85%B3%E7%B3%BB%E5%9B%BE%E8%A7%A3.png)

## 2、环境搭建

1. 导入jar包

     1. commons-logging-1.1.3.jar
     2. spring-aop-4.1.6.jar
     3. spring-aspects-4.1.6.jar
     4. spring-bean-4.1.6.jar
     5. spring-context-4.1.6.jar
     6. spring-core-4.1.6.jar
     7. spring-expression-4.1.6.jar
     8. spring-jdbc--4.1.6.jar
     9. spring-tx-4.1.6.jar
     10. spring-web-4.1.6.jar
     11. spring-webmvc-4.1.6.jar (aop基础上 多了这个)

2. 在 web.xml 中配置前端控制器 DispatcherServlet

     1. >​	<init-param>
          >​        <param-name>contextConfigLocation</param-name>
          >​        <param-value>classpath:springmvc.xml</param-value>
          >​    </init-param>
          >
          >如果不配置  <init-param>  springmvc 会在  /WEB-INF/<servlet-name>-servlet.xml 中寻找 XML

     ```xml
     <!-- 配置前端控制器 -->
     <servlet>
         <servlet-name>jqk</servlet-name>
         <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
         <init-param>
             <param-name>contextConfigLocation</param-name>
             <param-value>classpath:springmvc.xml</param-value>
         </init-param>
         <load-on-startup>1</load-on-startup>
     </servlet>
     <servlet-mapping>
         <servlet-name>jqk</servlet-name>
         <url-pattern>/</url-pattern>
     </servlet-mapping>
     ```

3. 在src 下新建  springmvc.xml 

     1. 引入 xmlns:mvc 命名空间

          ```xml
          xmlns:mvc="http://www.springframework.org/schema/mvc"
          
          http://www.springframework.org/schema/mvc
          http://www.springframework.org/schema/mvc/spring-mvc.xsd
          ```

     2. 配置相关信息

          ```xml
          <!-- 注解扫描 -->
          <context:component-scan base-package="com.bjsxt.controller"/>
          
          <!-- 注解驱动 -->
          <mvc:annotation-driven/>
          
          <!-- 静态资源 mapping是url的路径  location是本地路径 -->
          <mvc:resources mapping="/js/**" location="/js/"/>
          <mvc:resources mapping="/images/**" location="/images/"/>
          <mvc:resources mapping="/css/**" location="/css/"/>
          ```

4. 编写控制器

     ```java
     @Controller
     public class DemoController {
     
         @RequestMapping("demo")
         public String demo(){
             System.out.println("执行demo");
             return "/main.jsp";
         }
     
         @RequestMapping("demo1")
         public String demo1(){
             System.out.println("执行demo1");
             return "/main1.jsp";
         }
     }
     ```

## 3、字符编码过滤器

1. 在 Web.xml 中配置 filter

     > 包括了前面的前端控控制器

     ```xml
     <!-- 配置前端控制器 -->
     <servlet>
         <servlet-name>jqk</servlet-name>
         <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
         <init-param>
             <param-name>contextConfigLocation</param-name>
             <param-value>classpath:springmvc.xml</param-value>
         </init-param>
         <load-on-startup>1</load-on-startup>
     </servlet>
     <servlet-mapping>
         <servlet-name>jqk</servlet-name>
         <url-pattern>/</url-pattern>
     </servlet-mapping>
     
     <!-- 字符编码过滤器 -->
     <filter>
         <filter-name>encoding</filter-name>
         <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
         <init-param>
             <param-name>encoding</param-name>
             <param-value>utf-8</param-value>
         </init-param>
     </filter>
     <filter-mapping>
         <filter-name>encoding</filter-name>
         <url-pattern>/*</url-pattern>
     </filter-mapping>
     ```

## 4、传参

1. 把内容写到方法（HandlerMethod）参数中，springmvc 只要有这个内容，就会注入内容

2. 基本数据类型

     > 注意，无论是直接传基本数据类型，还是传对象，pojo 类一定是提供无参构造器，最好是用默认构造器，也就是无参构造器。

     ```java
     @Controller
     public class DemoController {
     
         @RequestMapping("demo")
         public String demo(String name, int age){
             System.out.println("执行demo"+name+" "+age);
             return "main.jsp";
         }
     }
     ```

     1. 如果请求参数名和方法参数名不对应   可以使用**==@RequestParam()==** 注解

          ```java
          @Controller
          public class DemoController {
          
              @RequestMapping("demo")
              public String demo(@RequestParam("name1") String name,@RequestParam("age1") int age){
                  System.out.println("执行demo"+name+" "+age);
                  return "main.jsp";
              }
          }
          ```

     2. 如果属性和方法是基本数据类型（不是封装类 例如 Interger）可以通过  此注解设置默认值

          1. 防止没有参数 500

          ```java
          @RequestMapping("demo2")
          public String demo2(@RequestParam(defaultValue = "2") int pageSize,@RequestParam(defaultValue = "1")int pageNumber){
              System.out.println(pageSize+"   "+pageNumber);
              return "main.jsp";
          }
          ```

     3. 如果强制要求必须有某个参数

          ```java
          @RequestMapping("demo3")
          public String demo3(@RequestParam(required = true) String name){
              System.out.println("name是SQL 查询条件，必须要传递 name属性"+name);
              return "main.jsp";
          }
          ```

     4. HandleMethod 中参数是对象类型

          1. 请求参数名和对象中属性名对应（get  /  set方法）

          ```java
          @RequestMapping("demo5")
          public String demo5(People people){
              System.out.println(people);
              return "main.jsp";
          }
          ```

     5. 请求参数中包含多个同名参数的获取方式

          1. 复选框传递的参数有多个同名的参数

          ```java
          @RequestMapping("demo6")
          public String demo6(String name, int age,@RequestParam("hover") ArrayList<String> list){
              System.out.println(name+" "+age+" "+list);
              return "main.jsp";
          }
          ```

     6. 请求参数中对象  .  属性格式

          1. jsp 中代码

               ```html
               <input type="text" name="peo.name">
               <input type="text" name="peo.age">
               ```

          2. 新建个 pojo 类

               1. 要求对象和参数中前面的 点 名称对应

               ```java
               public class Demo {
                   private People peo;
                   // get / set 方法
               }
               ```

          3. 控制器

               ```java
               @RequestMapping("demo7")
               public String demo7(Demo demo){
                   System.out.println(demo);
                   return "main.jsp";
               }
               ```

     7. 在请求参数中传递集合对象类型参数

          1. jsp 中格式

               ```html
               <input type="text" name="peo[0].name">
               <input type="text" name="peo[0].age">
               <input type="text" name="peo[1].name">
               <input type="text" name="peo[1].age">
               ```

          2. 新建pojo类

               ```java
               public class Demo {
                   private List<People> peo;
                   // get / set 方法
               }
               ```

          3. 控制器和 第 6点一致

     8. restful 传值方式

          1. 简化 jsp 中参数编写格式

          2. 在 jsp 中设定特定的格式

               ```html
               <a href="demo9/'张三'/11">跳转</a>
               ```

          3. 在控制器中

               1. 在 **==@ReuquestMapping==**中一定要和请求格式对应
               2. { 名称} 中名称自定义名称
               3. **==@PathVariable==** 获取  **==@RequestMapping==**  中内容，默认按照方法参数名称去寻找

               ```java
               @RequestMapping("demo9/{name}/{age1}")
               public String demo9(@PathVariable("age1") int age,@PathVariable String name){
                   System.out.println(name+"   "+age);
                   return "/main.jsp";
               }
               ```

## 5、跳转方式

1. 默认跳转方式请求转发

2. 设置返回值字符串内容

     1. 添加  redirect：资源路径  重定向

          ```
          @RequestMapping("/demo10")
          public String demo10(){
              return "redirect:/main.jsp";
          }
          ```

     2. 添加   forward：资源路径   或省略 forward：转发（默认行为）



## 6、视图解析器

1. Spring  会提供默认视图解析器

2. 也可以自定义视图解析器

     ```xml
     <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
         <property name="prefix" value="/"/>
         <property name="suffix" value=".jsp"/>
     </bean>
     ```

3. 如果希望不执行自定义视图解析器，在方法返回值前添加 forward：或 redirect：

     ```java
     @RequestMapping("demo11")
     public String demo11(){
         return "forward:demo12";
     }
     
     @RequestMapping("demo12")
     public String demo12(){
         System.out.println("从demo 11 跳转 而来");
         return "main";
     }
     ```

## 7、==@ResponseBody==

1. 在方法上，只有 **==@ResponseBody==**  时，无论返回值是什么认为需要跳转的

2. 在方法上添加此注解，

     1. 如果返回值 满足 key-value 形式（对象或map）

          1. 把相应头设置为 applicaton/json;charset=utf-8
          2. 把转换后的内容输出流的形式响应给客户端

     2. 如果返回值不满足 key-value ，例如返回值为 String

          1. 把响应头设置为 text/html
          2. 把方法返回值以流的形式直接输出
          3. 如果返回值包含中文，出现中文乱码
               1. produces  表示响应头中  Context-Type 取值

          ```java
          @RequestMapping(value = "demo13",produces = "text/html;charset=utf-8")
          @ResponseBody
          public String demo13(){
              People p = new People();
              p.setName("张三");
              p.setAge(19);
              return "中文乱码";
          }
          ```

## 8、项目

![image-20200718200111969](images/%E7%AC%AC%E4%B8%80%E5%A4%A9%E9%A1%B9%E7%9B%AE%E6%95%B0%E6%8D%AE%E5%BA%93.png)

![image-20200718200619507](images/%E7%AC%AC%E4%B8%80%E5%A4%A9%E9%A1%B9%E7%9B%AE%E9%9C%80%E8%A6%81%E7%9A%84jar%E5%8C%85.png)