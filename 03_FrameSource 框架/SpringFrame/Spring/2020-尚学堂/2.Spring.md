[toc]

## 1、AOP

1. 中文名称：面向切面编程

2. 英文名称：Aspect Oriented Programming 

3. 正常程序执行流程都是纵向执行流程

     1. 又叫面向切面编程，在原有纵向执行流程中添加横切面

     2. 不需要修改原有程序代码

          1. 高扩展性
          2. 原有功能相当于 释放了部分逻辑，让职责更加明确

          ![image-20200714143644424](images/AOP%20%E5%88%87%E9%9D%A2.png)

4. 面向切面编程是什么？

     1. 在程序原有纵向执行流程中，针对某一个或某一些方法添加通知，形成横切面就叫面向切面编程。

5. 常用概念

     1. 原有功能：切点  pointcut
     2. 前置通知：切点之前执行的功能  before advice
     3. 后置通知：切点之后执行的功能  afer advice
     4. 如果切点执行过程中出现异常，会触发异常通知   throws  advice
     5. 所有功能总称叫切面
     6. 织入：把切面嵌入到原有功能的过程叫做织入

6. Spring 提供了  2  种 AOP 实现方式

     1. ==Schema-based==
          1. 每个通知都需要实现接口或类
          2. 配置 spring 配置文件在 < aop:config > 配置
     2. ==AspectJ==
          1. 每个通知不需要实现接口
          2. 配置 Spring 配置文件是 在  <  aop:config >子标签 < aop:aspect> 中配置

## 2、Schema-based 实现步骤

1. 导入 jar 包

     1. aopalliance.jar (AspectJ 依赖包)
     2. aspectjweaver.jar (AspectJ 依赖包)
     3. commons-logging 
     4. spring-aop-xx.jar
     5. spring-aspects-xx.jar
     6. spring-beans-xx.jar
     7. spring-context-xx.jar
     8. spring-core-xx.jar
     9. spring-expression-xx.jar
     10. spring-tx-xx.jar

2. 新建通知类

     1. 新建前置通知类

          1. method ：切点方法对象  Method 对象  method.getName() 可以获取到方法名
          2. objects：切点方法参数，判断是否为空后，遍历输出
          3. o：起点在哪个对象中

          ```java
          public class MyBeforeAdvice implements MethodBeforeAdvice {
              @Override
              public void before(Method method, Object[] objects, Object o) throws Throwable {
                  System.out.println("执行前置通知");
              }
          }
          ```

     2. 新建后置通知类

          1. o：切点方法返回值
          2. method：切点方法对象
          3. objects：切点方法参数
          4. o1：起点方法所在的类的对象

          ```java
          public class MyAfterAdvice implements AfterReturningAdvice {
              @Override
              public void afterReturning(Object o, Method method, Object[] objects, Object o1) throws Throwable {
                  System.out.println("执行后置通知");
              }
          }
          ```

     3. 配置 spring 配置文件

          1. 引入  aop  命名空间

          2. 配置通知类 < bean >

          3. 配置切面

          4. ​    ` *`      通配符，匹配任意方法名，任意类名，任意一级包名  

               > ` * com.bjsxt.test.Demo.*() `

          5. 如果希望匹配任意方法参数  (..)

               > ` * com.bjsxt.test.Demo.*(..)`

          6. 如果希望配置全局

               > ` * *..*.*(..) `

          7. 如果希望在全局的 service.impl 包下配置

               > ` * *..service.impl.*(..) `

          ```xml
          <?xml version="1.0" encoding="UTF-8"?>
          <beans xmlns="http://www.springframework.org/schema/beans"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:aop="http://www.springframework.org/schema/aop"
                xsi:schemaLocation="http://www.springframework.org/schema/beans
                  http://www.springframework.org/schema/beans/spring-beans.xsd
                  http://www.springframework.org/schema/aop
                  http://www.springframework.org/schema/aop/spring-aop.xsd">
          
             <!-- 配置通知类通知，在切面中切入-->
             <bean id="before" class="com.bjsxt.advice.MyBeforeAdvice"/>
             <bean id="after" class="com.bjsxt.advice.MyAfterAdvice"/>
          
             <!-- 配置切面-->
             <aop:config>
                <!--配置切点 -->
                <aop:pointcut id="mypoint" expression="execution(* com.bjsxt.test.Demo.demo2())"/>
                <!-- 通知 -->
                <aop:advisor advice-ref="before" pointcut-ref="mypoint"/>
                <aop:advisor advice-ref="after" pointcut-ref="mypoint"/>
             </aop:config>
             <!-- 配置Demo类，测试使用 -->
             <bean id="demo" class="com.bjsxt.test.Demo"/>
          
          </beans>
          ```

     4. 编写测试代码

          ```java
          ClassPathXmlApplicationContext ca = new ClassPathXmlApplicationContext("applicationContext.xml");
          Demo demo = ca.getBean("demo", Demo.class);
          demo.demo1();
          demo.demo2();
          demo.demo3();
          ```

     5. 运行结果

          ![image-20200714163936577](images/aop%20%E8%BF%90%E8%A1%8C%E7%BB%93%E6%9E%9C.png)

## 3、配置异常通知步骤 （AspectJ 方式）

1. 只有当切点报异常才能触发

2. 在 Spring 中有  AspectJ  方法提供了异常通知的办法

     1. 如果希望通过 schema-base 实现需要按照特点的要求自己编写方法

3. 实现步骤：

     1. 新建类，在类写任意名称和方法

     ```java
     public class MyThrowAdvice  {
     
         public void myexception(Exception e){
             System.out.println("执行异常通知,异常信息："e.getMessage());
         }
     }
     ```

     2. 在spring 配置文件中配置

          1.  < aop:aspect > 的 ref 属性方法：方法在哪个类中
          2. < aop:xxxx />  表示什么通知
          3. method ：放触发这个通知时，调用哪个方法
          4. throwing：异常对象名，必须和通知中方法参数名相同（可以不再通知中声明异常对象）

          ```xml
          <bean id="demo" class="com.bjsxt.test.Demo"/>
          <bean id="mythrow" class="com.bjsxt.advice.MyThrowAdvice"/>
          
          <aop:config>
              <aop:aspect ref="mythrow">
                  <aop:pointcut id="mypoint" expression="execution(* com.bjsxt.test.Demo.*(..))"/>
                  <aop:after-throwing method="myexception" pointcut-ref="mypoint" throwing="e"/>
              </aop:aspect>
          </aop:config>
          ```

## 4、异常通知（Schema-base 方法）

1. 新建一个类实现 throwsAdvice 接口

     1. 必须自己写方法，且必须叫  afterThrowing
     2. 有两种参数
          1. 必须是 1 个 或 4个
     3. 异常类型要与切点报的异常类型一致

     ```java
     public class MyThrow implements ThrowsAdvice {
     
         public void afterReturning(Object o, Method method, Object[] objects, Object o1) throws Throwable {
             System.out.println("执行一次通知");
         }
     }
     ```

2. 在applicationContext.xml 中配置

     ```xml
     <bean id="myThrow" class="com.bjsxt.advice.MyThrow"/>
     <aop:config>
        <aop:pointcut id="mypoint" expression="execution(* *..*.*(..))"/>
        <aop:advisor advice-ref="myThrow" pointcut-ref="mypoint"/>
     </aop:config>
     <bean id="demo" class="com.bjsxt.test.Demo"/>
     ```

## 5、环绕通知（Schema-based方法）

1. 把前置通知和后置通知都写到一个通知中，组成了环绕 通知

2. 实现步骤

     1. 新建一个类   实现 MethodInterceptor （拦截器）

          ```java
          public class MyArround implements MethodInterceptor {
          
              @Override
              public Object invoke(MethodInvocation methodInvocation) throws Throwable {
                  System.out.println("环绕-前置");
                  // 放心，调动切点方式
                  Object result = methodInvocation.proceed();
                  System.out.println("环绕-后置");
                  return result;
              }
          }
          ```

     2. 配置 applicationContext.xml 

          ```xml
          <bean id="demo" class="com.bjsxt.test.Demo"/>
          
          <bean id="myarround" class="com.bjsxt.advice.MyArround"/>
          
          <aop:config>
             <aop:pointcut id="mypoint" expression="execution(* *..*.*(..))"/>
             <aop:advisor advice-ref="myarround" pointcut-ref="mypoint"/>
          </aop:config>
          ```

## 6、使用  AspectJ 方法实现

1. 新建个类，不用实现

     1. 类中方法名任意

          ```java
          public class MyAdvice {
              public void mybefore(String name,int age){
                  System.out.println("前置两个参数 mybefore "+name+"\t"+age);
              }
              public void mybefore1(String name){
                  System.out.println("前置一个参数 mybefore1 "+name);
              }
              public void myafter(){
                  System.out.println("后置 myafter");
              }
              public void myaftering(){
                  System.out.println("后置 myaftering");
              }
              public void mythorw(){
                  System.out.println("异常 mythorw");
              }
              public Object myarround(ProceedingJoinPoint p) throws Throwable {
                  System.out.println("执行环绕 myarround");
                  System.out.println("环绕 - 前置");
                  Object result = p.proceed();
                  System.out.println("环绕 - 后置");
                  return result;
              }
          }
          ```

     2. 配置 Spring 文件

          1. < aop:after /> 后置通知，是否出现异常都执行
          2. < aop:after-returing /> 后置通知，只要当切点正常执行，才会运行
          3. <aop:after /> 和 < aop:after-returing /> 和 < aop:after-throwing /> 执行顺序和配置顺序有关
          4.  execition （）括号不能扩上 args
               1. 中间使用 and 不能使用 && 由 Spring 把 and 解析成 && 
               2. args（名称） 名称自定义的顺序 和 demo1（参数，参数）对应
               3.  < aop:before /> arg-names ="名称"  名称来源于 execition 中的 args，名称必须一样
               4. args() 有几个参数，args-names 里面也必须有几个参数
               5. arg-name=“”  里面名称必须和通知方法参数名称对应

          ```xml
          <bean id="demo" class="com.bjsxt.test.Demo"/>
          
          <bean id="myadvice" class="com.bjsxt.advice.MyAdvice"/>
          
          <aop:config>
             <aop:aspect ref="myadvice">
                <aop:pointcut id="mypoint"  expression="execution(* com.bjsxt.test.Demo.demo1(String,int)) and args(name,age)"/>
                <aop:pointcut id="mypoint1" expression="execution(* com.bjsxt.test.Demo.demo2(String)) and args(name)"/>
          
                <aop:before method="mybefore" pointcut-ref="mypoint" arg-names="name,age"/>
                <!-- IDEA 这里报红 但是运行程序没有任何问题-->
                <aop:before method="mybefore1" pointcut-ref="mypoint1" arg-names="name"/>
          
          
                <!--<aop:after method="myafter" pointcut-ref="mypoint"/>-->
                <!--<aop:after-returning method="myaftering" pointcut-ref="mypoint"/>-->
                <!--<aop:after-throwing method="mythorw" pointcut-ref="mypoint"/>-->
                <!--<aop:around method="myarround" pointcut-ref="mypoint"/>-->
             </aop:aspect>
          </aop:config>
          ```

## 7、使用注解（基于 Aspect）

1. spring 不会自动寻找注解，必须要告诉 spring 那些包下面有注解

     1. 引入 xmlns:context

          ```xml
          xmlns:context="http://www.springframework.org/schema/context"
          http://www.springframework.org/schema/context
          http://www.springframework.org/schema/context/spring-context.xsd
          ```

2. ==**@Component**==

     1.  相当于 < bean /> 
     2. 如果没有参数，就把类名首字母变小写，相当于 < bean id=""  />
     3. @ Component ( " 自定义名称 " )

3. 实现步骤：

     1. 在 spring 配置文件中设置注解在哪些包中

     2. 开启 aop 切面

          ```xml
          <context:component-scan base-package="com.bjsxt.advice,com.bjsxt.test"/>
          <!--
             proxy-target-class
                true 使用 cglib 动态代理
                false 使用 jdk 动态代理
          -->
          <aop:aspectj-autoproxy proxy-target-class="true"/>
          ```

     3. 在Dmeo类中添加 ==@Component==

          1. **==@Pointcut==** 切点   规范为当前包名、类名、方法名

          ```java
          @Component
          public class Demo {
              @Pointcut("com.bjsxt.test.Demo.demo1()")
              public void demo1() throws Exception{
          //        int i=5/0;
                  System.out.println("demo01");
              }
          }
          ```

     4. 在通知类中配置

          1. ==**@Component**== 类被 spring 管理
          2. **==@Aspect==** 相当于 < aop:aspect /> 表示通知方法在当前类中
          3. **==@Before==**  前置
          4. **==@After==** 后置
          5. **==@AfterThrowing==** 异常
               1. throwing = “e ” 可以获取异常信息    >>>   e.getMessage()
          6. **==@Around==**  环绕

          ```java
          @Component
          @Aspect
          public class MyAdvice {
              @Before("execution(* com.bjsxt.test.Demo.demo1())")
              public void mybefore(){
                  System.out.println("前置");
              }
          
              @After("execution(* com.bjsxt.test.Demo.demo1())")
              public void myafter(){
                  System.out.println("后置");
              }
          
              @AfterThrowing(value = "execution(* com.bjsxt.test.Demo.demo1())",throwing = "e")
              public void mythrow(Exception e){
                  System.out.println("异常通知:"+e.getMessage());
              }
          
              @Around("execution(* com.bjsxt.test.Demo.demo1())")
              public Object myarround(ProceedingJoinPoint p)throws Throwable{
                  System.out.println("环绕-前置");
                  Object result = p.proceed();
                  System.out.println("环绕-后置");
                  return result;
              }
          }
          ```

## 8、代理设计模式

1. 设计模式：前人总结的一套特定问题的代码。
2. 代理设计模式优点
     1. 保护真实对象
     2. 让真实对象职责更明确
     3. 扩展
3. 真对象实
     1. 真实对象 （马云）
     2. 代理对象 （秘书）
     3. 抽象代理 （抽象功能），谈小目标

![image-20200715005804789](images/%E4%BB%A3%E7%90%86%E6%A8%A1%E5%BC%8F.png)

![image-20200715010440859](images/%E4%BB%A3%E7%90%86%E6%A8%A1%E5%BC%8F%20%E4%BB%A3%E7%A0%81%E7%90%86%E8%A7%A3.png)

## 9、静态代理设计模式

1. 由代理对象代理所有真实对象的功能
     1. 自己编写代理类
     2. 每个代理的功能需要单独编写
2. 静态代理设计模式的缺点
     1. 当代理模式比较多时，代理类中方法需要写很多。

## 10、动态代理

1. 为了解决静态代理频繁编写代理功能缺点
2. 分类：
     1. JDK 提供的
     2. cglib 动态代理

## 1、JDK 动态代理

1. 和 cglib 动态代理对比，

     1. 优点：JDK 自带，不需要额外导入 jar
     2. 缺点：
          1. 真实对象必须实现接口
          2. 利用反射机制，效率不高

2. 使用 JDK  动态代理时可能出现下面异常

     1. 出现原因：希望把接口对象转换为具体真实对象

3. 代码实现：

     1.  定义接口

          ```java
          public interface GongNeng {
              void chifan();
              void mubiao();
          }
          ```

     2. 定义 Boss 真实对象 类

          ```java
          public class LaoZong implements GongNeng {
              @Override
              public void chifan() {
                  System.out.println("吃饭");
              }
              @Override
              public void mubiao() {
                  System.out.println("目标");
              }
          }
          ```

     3. 定义 秘书 代理类

          ```java
          public class MiShu implements InvocationHandler {
              private LaoZong laoZong = new LaoZong();
              
              @Override
              public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                  System.out.println("预约时间");
                  Object result = method.invoke(laoZong, args);
                  System.out.println("记录访问信息");
                  return result;
              }
          }
          ```

     4. 测试

          ```java
          public class Women {
              public static void main(String[] args) {
                  System.out.println(Women.class.getClassLoader()==LaoZong.class.getClassLoader());
                  MiShu miShu = new MiShu();
                  // 第一个参数：反射时使用的类加载器
                  // 第二个参数：Proxy需要实现什么借口
                  // 第三个参数：通过借口调用方法时，需要调用哪个类的 invoke 方法
                  GongNeng gongneng = (GongNeng) Proxy.newProxyInstance(Women.class.getClassLoader(), new Class[]{GongNeng.class}, miShu);
                  gongneng.chifan();
                  gongneng.mubiao();
              }
          }
          ```



## 12、cglib 动态代理类

1. cglib  优点：
     1. 基于字节码，生成真实对象代理的子类
          1. 运行效率高于  JDK 的效率
     2. 不需要实现接口
2. cglib 缺点：
   
1. 非 JDK 功能，需要额外导入 jar
   
3. 使用 spring aop 时， 只要出现Proxy 和真实对象转换异常

     ```xml
     <aop:aspectj-autoproxy proxy-target-class="true"/>
     ```

     1. 设置为 true 使用 cglib
     2. 设置为 false 使用 jdk（默认值）

4. 代码实现：

     1.  真实对象 Boss 类

          ```java
          public class LaoZong {
              public void chifan(){
                  System.out.println("吃饭");
              }
              public void mubiao(){
                  System.out.println("目标");
              }
          }
          ```

     2. 代理类 秘书类 

          ```java
          public class MiShu implements MethodInterceptor {
              private LaoZong laoZong = new LaoZong();
          
              @Override
              public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
                  System.out.println("预约");
                  Object result = methodProxy.invokeSuper(o, objects);
                  System.out.println("登记");
                  return result;
              }
          }
          ```

     3. 测试类

          ```java
          public class Women {
              public static void main(String[] args) {
                  Enhancer enhancer = new Enhancer();
                  enhancer.setSuperclass(LaoZong.class);
                  enhancer.setCallback(new MiShu());
          
                  LaoZong laoZong =  (LaoZong)enhancer.create();
                  laoZong.chifan();
              }
          }
          ```

