## 1、运行 JFinal 项目

> 新建一个 JAVAWEB 项目

1. 导入jar包

     1. jetty-server-8.1.8.jar
     2. final-2.0-bin.jar 	（核心jar）

2. 配置 web.xml 文件

     ```xml
     <filter>
         <filter-name>jfinal</filter-name>
         <filter-class>com.jfinal.core.JFinalFilter</filter-class>
         <init-param>
             <param-name>configClass</param-name>
             <param-value>demo.DemoConfig</param-value>
     	</init-param>
     </filter>
     <filter-mapping>
         <filter-name>jfinal</filter-name>
         <url-pattern>/*</url-pattern>
     </filter-mapping>
     ```

3. 创建类

     > ==注意==：上面的  <param-value>demo.DemoConfig</param-value>  标签，必须放这这个类的全限定类名

     ```java
     public class DemoConfig extends JFinalConfig {
         // 配置常量
         @Override
         public void configConstant(Constants constants) {
             // 设置开发模式
             constants.setDevMode(true);
         }
         @Override
         public void configRoute(Routes routes) {
              routes.add("/hello",HelloController.class);
         }
         @Override
         public void configPlugin(Plugins plugins) {    }
         @Override
         public void configInterceptor(Interceptors interceptors) {    }
         @Override
         public void configHandler(Handlers handlers) {    }
     }
     ```

     > ==注意==：上面 configRoute 方法里的 HelloController.class 必须和下面的类名一致

     ```java
     public class HelloController  extends Controller {
         public void index(){
             renderText("Hello JFinal World!");
         }
     }
     ```

4. 启动 Tomcat 浏览器 打开  本机地址/hello 显示： *Hello JFinal World!*

## 2、JFinalConfig

### 2.1、概述：

​		基于 JFinal 的 web 项目需要创建一个基础自  JFinalConfig 类的子类，该类用于对整个 web 项目进行配置

JFinalConfig 子类需要实现五个抽象方法

```java
public class DemoConfig extends JFinalConfig {
    public void configConstant(Constants constants) {    }
    public void configRoute(Routes routes) {    }
    public void configPlugin(Plugins plugins) {    }
    public void configInterceptor(Interceptors interceptors) {    }
    public void configHandler(Handlers handlers) {    }
}
```

### 2.2、ConfigConstatnt(Constants constants)

​	此方法用来配置 JFinal 常量值，如开发模式常量 devMode 的配置，默认视图类型 ViewType 的配置，下面默认配置 JSP

```java
public void configConstant(Constants constants) {  
	constants.setDevMode(true);
    constants.setViewType(ViewType.JSP);
}
```

一般支持 JSP、FreeMark、Velocity 三种常用视图

### 2.3、configRoute(Routes routes)

​		配置路由器，将  "/hello" 映射到 HelloController 控制器，==如果是访问 /hello/abc 则是找到  HelloController 这个类的 abc（） 这个方法，这个方法必须是public修饰==

```java
public void configRoute(Routes routes) {
    routes.add("/hello",HelloController.class);
}
```

​		第一个参数 controllerKey，唯一

|            url组成             |                     访问目标                      |
| :----------------------------: | :-----------------------------------------------: |
|         controllerKey          |              YourController.index()               |
|     controllerKey / method     |              YourController.method()              |
| controllerKey / method / v0-v1 | YourController.method()，所带 url 参数值为：v0-v1 |
|     controllerKey / v0-v1      | YourController.index()，所带 url 参数值为：v0-v1  |

​		JFinal 默认，使用减号 ” - “ 来分割多个值，可以通过 constatns 、setURLParaSeparator（String）设置分隔符，在 Controller 中可以通过 getPara（int index）分别取出这些值。controllerKey、method、urlPara 这三部分必须使用 ”/ " 分割

​		JFinal 在以上路由规则之外提供了  `ActionKey`  注解，打破原有规则

```java
public class UserController extends Controller{
    @ActionKey("/login")
    public void login(){
        render("login.html");
    }
}
```

​		如果，UserController 的 controllerK 的值设置了 ”/urse" 使用   @ActionKey("/login")  注解后，actionKey 本来是 " /user/login "  直接变成了 "/login " 该注解还可以让 actionKey 中使用减号或数字瞪符号，如 “ /user / 123-456" 

​		如果你还不爽，还可以使用 Handler 定制路由

## 3、Controller

​		Controller 是 JFinal 核心类之一，作为MVC 模式中的控制器，就是流批~  还有一个事，Controller 是线程安全的。一个Controller 可以包含多个 Action

### 3.1、Action

​		Controller 以及在其中定义了 public 无参方法称为 一个 Action。Action是请求的最小单位，Action必须在 Controller 中声明，该方法必须是 public 可见性且没有形参

```java
public class UserController extends Controller{
    public void login(){
        render("这是一个 苦逼的 Action");
    }
    public void test(){
        render("这是又一个 苦逼的 Action");
    }
}
```

### 3.2、getPara 

​		第一个参数为 String 类型的将获得表单或者 url 中间号挂参的域值。第一个参数为 int 或无参的将获取  urlPara 中的参数值

### 3.3、获取参数

​	设置第一路径

```java
public void configRoute(Routes routes) {
    routes.add("/user", UserController.class);
}
```

​	获取参数：

```java
public class UserController extends Controller {
    public void add(){
        String name = getPara("name");
        int age = getParaToInt("age");
        System.out.println("name："+name+"age："+age);
        setAttr("msg","添加成功");
        render("/success.jsp");
    }
}
```

setAttr 给 session 传递参数，简化了  sessio.setAttribute();

render 重定向 

session.jsp 中  <p>  ${msg}  </p>  即可取值

### 3.5、getFile

Controller 提供了 文件上传下载方法

