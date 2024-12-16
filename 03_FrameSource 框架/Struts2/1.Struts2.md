## 1、回顾

1. web 开发的进程有两种模式：Model1 开发模式 和 Model2 开发模式

2. Model1 开发模式

     ![image-20200730123311953](images/model1%E6%A8%A1%E5%BC%8F.png)

     ​	优点：执行效率高，开发效率比较高，适合小型项目

     ​	缺点：逻辑比较混乱，页面混乱，维护困难，扩展不容易。

3. Model2 开发模式

     ![image-20200730123200695](images/model2%E6%A8%A1%E5%BC%8F.png)

     ​		优点：将视图和业务分离；结构清晰，分工明确，专注一块功能，维护方便，适合中大型项目。

     ​		缺点：执行效率相对低。代码量大，重复代码比较多。

     ​		Model2 又称为 MVC 设计模式 M：Model模式、V：View视图、C：Controller控制层

4. 使用Servlet的MVC存在一些问题，有重复代码

     1. 通过 MVC 框架来解决这个问题

5. Servlet 解决了什么问题

     1. 将 url 映射到一个 java 类的处理方法上。
     2. 接收请求的数据
     3. 如何将控制结果展示到页面
     4. 如何进入页面跳转



## 2、框架

1. 学习曲线：
     + 基本语法 --》 方法（代码重用）--》类（代码重用）--》jar包（多个类封装成jar，代码重用）--》框架（一个或多个jar，代码重用）
2. 为什么要使用框架
     1. 提高开发效率，降低学习难度
3. 如何学习框架
     1. 框架是别人提供的，那么要使用框架时，要遵守框架提供的规则
     2. 学习框架就是学习框架的规则
     3. 框架由两部分组成，可变的部分和不可变的部分
4. 常见框架：Spring，Hibernate，Mybatis，Struts2，Shior，Solr，JFinal



## 3、Struts2 入门

1.  Struts2 是一个开源，免费，轻量级的mvc框架
2. 轻量级：如果一个框架没有侵入性，就说该框架是轻量级的。
3. 侵入性：如果使用一个框架，必须实现框架提供的接口，或者继承框架提供的类。
4. 在Struts2之前是 Struts1，Struts1出现很早，市场占有率比较高，所以不支持一些新的视图展示技术，逐渐被淘汰。Struts2 = Struts1+webWork，是基于请求的 MVC 框架。

### 3.1、Struts2案例

1. 准备jar包

     + asm-3.3.jar

     + asm-commons-3.3.jar

     + asm-tree-3.3.jar

     + commons-fileupload-1.2.2.jar

     + commons-io-2.0.1.jar

     + commons-lang3-3.1.jar

     + freemarker-2.3.19.jar

     + javassist-3.11.0.GA.jar

     + ognl-3.0.5.jar

     + struts2-core-2.3.4.jar

     + xwork-core-2.3.4.jar

          ```xml
          <dependency>
            <groupId>org.apache.struts</groupId>
            <artifactId>struts2-core</artifactId>
            <version>2.3.4</version>
          </dependency>
          ```

2. 创建 web 项目

3. 配置 web.xml 

     ```xml
     <!-- 配置  Struts2 的前端控制器 -->
     <filter>
       <filter-name>struts2</filter-name>
       <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
     </filter>
     <filter-mapping>
       <filter-name>struts2</filter-name>
       <url-pattern>*.action</url-pattern>
     </filter-mapping>
     ```

4. 编写业务处理类，新建类

     ```java
     public class HelloAction {
     
         /**
          * 在 Struts2 中，所有业务方法都是public
          * 返回值都是  String 类型，所有方法业务都没有参数
          * 方法名可以自定义，默认为 execute
          * @return java.lang.String
          * @author Xiang想
          * @date 2020/7/30 14:29
          */
         public String execute(){
             System.out.println("hello struts2");
             return "success";
         }
     }
     ```

5. 在src 下配置 sturts2 的配置文件，名称为 struts.xml 该配置文件名不能被更改，并且配置

     ```xml
     <!DOCTYPE struts PUBLIC
             "-//Apache Software Foundation//DTD Struts Configuration 2.3//EN"
             "http://struts.apache.org/dtds/struts-2.3.dtd">
     <struts>
     
         <package name="default" namespace="/" extends="struts-default">
             <!--配置 action 配置 url 和处理类的方法进行映射-->
             <action name="hello" class="com.sxt.action.HelloAction">
                 <result>/hello.jsp</result>
             </action>
         </package>
     </struts>
     ```

6. 新建 hello.jsp 页面

7. 发布项目，测试

     ```
     http://localhost:9999/hello.action
     ```

## 4、Struts 配置

1. Web.xml

     ```xml
     <!-- 配置  Struts2 的前端控制器 -->
     <filter>
       <filter-name>struts2</filter-name>
       <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
     </filter>
     <filter-mapping>
       <filter-name>struts2</filter-name>
       <url-pattern>*.action</url-pattern>
     </filter-mapping>
     ```

     这里相当于  Sturts 的入口

2. sturts.xml

     ```xml
     <!DOCTYPE struts PUBLIC
             "-//Apache Software Foundation//DTD Struts Configuration 2.3//EN"
             "http://struts.apache.org/dtds/struts-2.3.dtd">
     <struts>
         <package name="default" namespace="/" extends="struts-default">
             <!--配置 action 配置 url 和处理类的方法进行映射-->
             <action name="hello" class="com.sxt.action.HelloAction" method="hello">
                 <result name="success" type="dispatcher  ">/hello.jsp</result>
             </action>
         </package>
     </struts>
     ```

     1. package 模块管理
          1. name 自定义，但是不能重复，在一个项目中唯一
          2. namespace 命名空间 和 url 请求路径直接相关
               1. 如：/   请求为：/hello.action
               2. 如：user/  请求为：/user/hello.action
          3. extends 继承，  `struts-default`  是底层一个 package  的 name 继承后才能实现
     2. action 配置 url 和处理类的方法进行映射
          1. name 为请求名 不加后缀
          2. class 处理类的 全限定类名  如果不配置，由默认类来处理（com.opensymphony.xwork2.ActionSupport）
          3. method  是class指定类的方法，默认指定 execute方法
     3. result 结果集配置
          1. name   结果集名称 和处理返回值匹配 默认为 success，可以自定义
               1. Sturts2 提供了5个返回集
                    + SUCCESS  执行成功，跳转到下一个视图
                    + NONE       执行成功，不需要视图显示
                    + ERROR      执行失败，显示失败页面
                    + INPUT       要执行该 Action 需要更多的条件
                    + LOGIN      需要登录后才能执行
          2. type 指定响应类型
               1. dispatcher  转发 默认
               2. redirect  重定向
               3. redirectAction  重定向到 Action
          3. 值：  为跳转页面  不加  /   为相对 namespace 路径 建议绝对路径

## 5、Struts2 执行流程

![image-20200730170733527](images/Struts%20%E6%B5%81%E7%A8%8B.png)

1. 客户端发送请求到 tomcat 服务器。服务器接受，将 HttpServletRequest 传进来
2. 请求经过一系列过滤器（如：ActionContextCleanUp、SimeMesh等）
3. FilterDispatcher被调用。FilterDispatcher 调用  ActionMppaer 来解决请求是否要调用某个 Action
4. ActionMapper 决定调用某个 ActionFilterDispatcher 吧请求交给 ActionProxy
5. ActionProxy 通过 Configuration Managr 查看 `strtus.xml` 从而找到对应的 Action类
6. ActionProxy 创建一个 ActionInvoication 对象
7. ActionInvocation 对象回调 Action 的 execute 方法
8. Action 执行完毕后，ActionInvocation 根据返回的字符串，找到对应的result，然后将 Result内容通过 HTTPServletResponse 返回给服务器

```sequence
Title: Struts2 执行流程
Browser->Server:1.发起请求
Server->StrutsPrepareAndExecuteFilter:2.将请求交给前端控制器
StrutsPrepareAndExecuteFilter->ActionMapping:3.查看对应请求的处理类(是否存在)
ActionMapping->ActionProxy:4.交给action代理类
ActionProxy->ActionProxy:5.执行
ActionProxy-->>StrutsPrepareAndExecuteFilter:6.响应结果
StrutsPrepareAndExecuteFilter->Server:7.将结果交给服务器处理
Server->Browser:8.response()

```

## 6、数据处理

在 Struts2 中，对于表单数据的处理有 3 种方式：属性驱动，对象驱动，模型去掉

1. 使用 Struts2 获取表单数据：只需表单域名称和 Action 处理类的属性名称一致，并且提供属性 set 方法，那么在Action 处理类中即可获得表单数据。

     1. 新建web项目

          1. 配置web.xml

               ```xml
               <filter>
                 <filter-name>struts2</filter-name>
                 <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
               </filter>
               <filter-mapping>
                 <filter-name>struts2</filter-name>
                 <url-pattern>*.action</url-pattern>
               </filter-mapping>
               ```

          2. 新建 struts.xml

               ```xml
               <!DOCTYPE struts PUBLIC
                       "-//Apache Software Foundation//DTD Struts Configuration 2.3//EN"
                       "http://struts.apache.org/dtds/struts-2.3.dtd">
               <struts>
                   <package name="default" namespace="/" extends="struts-default">
                       <action name="login" class="com.sxt.action.LoginAction" method="login">
                           <result>/index.jsp</result>
                       </action>
                   </package>
               </struts>
               ```

          3. Action类

               ```java
               public class LoginAction {
                   private String username;
                   private String password;
               
                   public void setUsername(String username) {
                       this.username = username;
                   }
               
                   public void setPassword(String password) {
                       this.password = password;
                   }
               
                   public String login(){
                       System.out.println("username="+username+"\t password="+username);
                       return Action.SUCCESS;
                   }
               }
               ```

          4. 前端

               ```html
               <form action="login.action" method="post">
                   username:<input type="text" name="username"/><br/>
                   password:<input type="password" name="password"/><br/>
                   <input type="submit" value="提交">
               </form>
               ```

          5. 部署测试

2. 如果数据需要显示到页面上，那么该数据可以作为处理类的属性，处理方法后该属性有值，并且有该属性的get方法。那么在页面上可以直接通过 el 表达式获取

