## 1、自动注入

1. 在 **Spring 配置文件中**（注解没用）对象名 和 ref=“id” id 名相同使用自动注入，可以不用配置 < property/>
2. 两种配置方法
     1. 在< bean >中通过 autowired = “”  配置，只对这个 < bean > 生效
          1. byName  根据set 字段名 和 bean 匹配
          2. byType   根据 类型和 bean 匹配
          3. constructor  和当前类的构造器中的参数  与 bean 匹配 （如果构造器有参数，不写 autowired = “” 的话，会报错)
     2. 在< beans > 中通过 default-autowire= “” 盆子，表当前文件中的所有 bean 都是全局配置内容

3. autowire = "" 可取值
     1. default：默认值，根据全局 default-autowire=“” 值，默认全局和局部都没有匹配情况，相当于 no：不自动注入
     2. byName ：通过名称自动注入，在Spring容器中找类的Id
     3. byType：根据类型注入
          1. spring 容器中不可以出现两个相同的类型 <bean>
     4. construcotr：根据构造方法注入
          1. 提供对参数的构造方法（构造方法参数中包括注入对象）
          2. 底层使用 byName，构造方法参数名和其他 < bean >的 id 相同

## 2、Spring中加载 properties 文件

1. 在 src 下新建 xxx.properties 文件

2. 在 spring 配置文件中引入 xmlns:context 在下面

     如果需要加载多个配置文件用逗号分隔开

     ```xml
     <context:property-placeholder location="classpath:db.properties"/>
     ```

3. 添加属性文件加载，并且在 < bean > 中开启自动注入的地方

     1. SqlSessionFacotryBean 的id  不能叫做  SqlSessionFactory
     2. 修改扫描器 把原来通过 ref 引用替换成 value 赋值，自动注入只会影响ref，不会影响value 影响

4. 在被 Spring 管理的类中通过  @Value("${key}") 取出 properties 中的内容

     1. key 和变量名可以不相同
     2. 变量类型任意，只要保证key 对应的 value 能

## 3、scope属性

1. < bean > 的属性
2. 作用：控制对象有效范围（单利，多例等）
     1. singleton：单例的（默认值）
     2. prototype：多例的
     3. request：作用于web应用的请求范围   每次请求重新实例化
     4. session：作用于web应用的会话范围   每次会话重新实例化
     5. global-session：作用于集群环境的会话范围（全局会话范围），当不是集群环境时，它就是session

## 4、单利设计模式

1. 作用 ：在应用程序中最多保证只有一个实

2. 好处

     1. 提示运行效率
     2. 实现数据共享 案例：application 对象 

3. 懒汉式

     1. 对象只有被调用时，才会被去创建

     2. 代码

          ```java
          public class SingleTon {
          
              // 由于对象需要被静态方法调用，我们要把方法设置为static
              // 由于对象是 static，必须设置访问权限为 private，如果是public可以直接掉对象了
              private static SingleTon singleTon;
          
              /**
               * 方法名和类名相同
               * 无返回值
               *
               * 对外提供访问入口
               *
               * @author Xiang想
               * @date 2020/7/16 14:33
               */
              private SingleTon(){
          
              }
              /**
               * 实例方法，实例方法必须通过对象调用
               *
               * 设置方法为静态方法
               * @author Xiang想
               * @date 2020/7/16 14:35
               */
              public static SingleTon getInstance(){
                  if (singleTon == null){
                      /*
                       * 多线程访问下，可能出现if同时成立的情况，添加锁
                       */
                      synchronized (SingleTon.class){
                          // 双重验证
                          if (singleTon == null){
                              singleTon = new SingleTon();
                          }
                      }
                  }
                  return singleTon;
              }
          }
          ```

     3. 由于添加了锁，才导致效率低

4. 饿汉式

     1. 解决了懒汉式的效率低问题

          ```java
          public class SingleTon2 {
          
              private static SingleTon2 singleTon2 = new SingleTon2();
              private SingleTon2(){
          
              }
              public static SingleTon2 getInstance(){
                  return singleTon2;
              }
          }
          ```

## 5、声明式事务

1. 编程式事务

     1. 由程序员编程事务控制代码
     2. OpenSessionView

2. 声明式事务

     1. 事务控制代码已经由sping写好，程序员只需要声明出那些方法需要进行事务控制，和如何进行事务控制

3. 声明式事务都针对于 ServiceImpl 类下方法的

4. 事务管理器基于通知（advice）的

5. 在 spring 配置文件中，配置声明事务

     ```xml
     <context:property-placeholder location="classpath:db.properties"/>
     <!-- 数据源 -->
     <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="${jdbc.driver}"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.password}"/>
        <property name="password" value="${jdbc.username}"/>
     </bean>
     
     <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
     </bean>
     
     <!-- 配置声明式事务 -->
     <tx:advice id="txAdvice" transaction-manager="txManager">
        <tx:attributes>
           <!-- 那些方法需要有事务控制 -->
           <!-- 方法以ins 开头事务 -->
           <tx:method name="ins*"/>
           <tx:method name="del*"/>
           <tx:method name="upd*"/>
           <tx:method name="*"/>
        </tx:attributes>
     </tx:advice>
     <!-- 切点范围设置 -->
     <aop:config>
        <aop:pointcut id="mypoint" expression="execution(* com.bjsxt.service.impl.*(..))"/>
        <aop:advisor advice-ref="txAdvice" pointcut-ref="mypoint"/>
     </aop:config>
     ```

## 6、声明式事务中属性解释

1. ==name===“”  哪些方法需要有事务支持
     1. 支持 * 通配符
2. ==readonly===“boolean” 是否为只读事务
     1. 如果是  true ，告诉数据库此事务为只读事务。数据库优化会对影响有一定提升，所以只要是查询的方法，建议使用此属性
     2. 如果是 false，事务需要提交的事务，建议：增、删、改
3. ==propagation== 事务控制传播行为
     1. 当一个具有事务控制的方法被另一个有事务控制的方法调用后，需要如何管理事务（新建事务？在事务中执行？把事务挂起？报异常？）
     2. REQUIRED（默认值）：如果当前有事务，就在事务中执行，如果当前没有事务，就新建一个事务
     3. SUPPORTS：如果当前有事务，就在事务中执行，如果当前没有事务，就在非事务状态下执行。
     4. MANDATORY：必须在事务内部执行，如果当前有事务，就在事务中执行，如果没有事务，报错。 
     5. REQUIRES_NEW：必须在事务中执行，如果当前没有事务，新建事务，如果当前有事务，把当前事务挂起
     6. NOT_SUPPORTED：必须在非事务下执行，如果当前没有事务，正常执行，如果当前有事务，就把当前事务挂起
     7. NEVER：必须在非事务中下执行，如果当前没有事务，正常执行，如果有事务，报错
     8. NESTED：必须在事务中执行，如果没有事务，就新建事务，如果当前有事务，就创建一个嵌套事务
4. ==isolation===“” 事务隔离级别
     1. 在多线程或并发访问下，如何保证访问到的数据具有完整性。
     2. 脏读
          1. 一个事务（A）读取到另一个事务（B）中未提交的数据，另一个事务中数据可能进行了改变，此时A事务读取的数据可能和数据库中数据是不一致的，此时认为数据是脏数据，读取脏数据的过程叫脏读
     3. 不可重复读
          1. 主要针对的是某行数据（或行中某列）
          2. 主要针对的操作是修改操作
          3. 两次读取在同一个事务内
          4. 当事务（A）第一次读取事务后，事务（B）对事务（A）读取的数据进行修改，事务（A）中次读取的数据和之前读取的数据不一致，过程不可重复读取
     4. 幻读
          1. 主要针对的操作是新增或删除
          2. 两次事务的结果
          3. 事务 A 按特例条件查询出结果，事务 B 新增了一条符合条件的数据，事务 A 中查询的数据和数据库不一致，事务 A 好像出现了幻觉，这种情况称为幻读
     5. DEFAULT：默认值，由底层数据库自动判断应该使用什么隔离级别
     6. READ_UNCOMMITTED：可以读取到未提交数据，可能出现脏读，不重复读，幻读 （效率最高）
     7. READ_COMMITTED：只能读取其他事务已提交数据，可以防止脏读，可能出现不重复读和幻读
     8. REPEATABLE_READ：读取的数据被添加锁，防止其他事务修改此数据，可以防止不可重复读，脏读，可能出现幻读
     9. SERIALIZABLE：排队，对整个表添加锁，一个事务在操作数据时，另一个事务等待事务操作完成后才能操作这个表 （最安全的）
5. ==rollback-for==="异常类型全限定类名"
     1. 当出现什么异常时需要进行回滚
     2. 建议：给定该属性值
          1. 手动抛异常一定要给该属性值
6. ==no-rollback-for===“异常类型全限定类名”
     1. 当出现什么异常时不回滚事务

## 7、常用注解

1. ==**@Component**== 创建类对象，相当于配置  < bean />
2. **==@Service==** 与 **==@Component==** 功能相同
     1. 写在 ServiceImpl 类上（功能上没有任何区别）
3. **==@Repository==** 与 **==@Component==** 功能相同
     1. 写在数据访问层类上
     2. 在 SSM 上用不上，SSM 不需要在dao层写实现类，搭配 stutas 使用
4. **==@Controller==** 与 **==@Component==** 功能相同
     1. 写在控制层

> 上面都是之前提到过的

1. **==Resource==**（不需要写对象 get  /  set）
     1. java中的注解
     2. 默认安装byName 注入，如果没有名次对象，按照 byType注入
          1. 建议把对象名称和 spring 容器中对象名相同
2. **==AutoWired==**（不需要写对象 get  /  set）
     1. spring中的注解
     2. 默认按照 byType 注入
3. **==@Value==**
     1. 获取 properties  文件中内容

> 上面是 spring 常用

1. **==@Pointcut==**
     1. 定义切点
2. **==@Aspect==**
     1. 定义切面类
3. **==@Before==**
     1. 前置通知
4. **==@After==**
     1. 后置通知
5. **==@AfterReturning==**
     1. 后置通知，必须切点正确执行
6. **==@AfterThrowing==**
     1. 异常通知
7. **==@Arround==**
     1. 环绕通知

> 上面是 AOP 常用

## 8、Ajax

1. 标准请求响应浏览器的动作（同步操作）

     1. 浏览器请求上面资源，跟随显示什么资源

2. ajax：异步请求：

     1. 局部刷新，通过异步请求，请求到服务器资源数据后，通过脚本修改页面中部分内容 

3. ajax 由 JavaScript 推出的

     1. 由 jqeury 对 js 中 ajax 代码进行封装，达到使用方便的效果。

4. jquery 中 ajax 分类

     1. 底层

          1. $.ajax({ 属性名：值，属性名：值}) 代码写起来相对最麻烦的

               1. 示例代码

                    ```javascript
                    $(function () {
                        $("a").click(function () {
                            $.ajax({
                                url:'demo',
                                data:{"name":"张三"},
                                dataType:'',
                                error:function () {
                                    alert('请求失败');
                                },
                                success:function (data) {
                                    alert('请求成功'+data);
                                },
                                type:'POST'
                            });
                        });
                    });
                    ```

     2. 第二层（简化 $.ajax)

          1. $.get(url，data，success，dataType)
          2. $.post(url，data，success，dataType)

     3. 第三层（简化 $.get())

          1. $.getJSON(url,data,success) 相当于设置 

               ​	$.get中 dataType="json"

          2. $.getScript(url,data,success)相当于 设置 

               ​    $.get中 dataType = “script”

5. 如果服务器返回数据是从表中取出，为了方便客户端操作返回的数据，服务器端返回的数据设置为json

     1. 客户端吧 json 当作对象或数组操作

6. json：数据格式

     1. JsonObject：json 对象 ，理解成java中对象
          1. {"key":value,"key1":value1}
     2. JsonArray：json 数组
          1. [{"key":value},{"key":value},{"key":value}]

7. 实例代码：

     1. 需要  jar 包
          1. jackson-annotaions-2.4.0.jar
          2. jackson-core-2.4.1.jar
          3. jackson-databind-2.4.1.jar
     
     ```jsp
     <%@ page contentType="text/html;charset=UTF-8" language="java" %>
     <html>
     <head>
         <title>Index</title>
     
         <script type="text/javascript" src="js/jquery-3.4.1.js"></script>
         <script type="text/javascript" >
             /*
                 url 请求服务器地址
                 data 请求参数
                 dataType 服务器返回的数据类型
                 error 请求出错执行的功能
                 success 请求成功执行的功能 function(data) data服务器返回的数据
                 type 请求方式
              */
             $(function () {
                 $("a").click(function () {
                     $.post("demo",{"name":"张三"},function (data) {
                         var result="";
                         for (var i=0;i<data.length;i++){
                             result+="<tr>";
                             result+="<td>"+data[i].name+"</td>";
                             result+="<td>"+data[i].age+"</td>";
                             result+="</tr>";
                         }
                         $("#mytbody").append(result);
                     });
                     return false;
                 });
             });
         </script>
     </head>
     <body>
         <a href="demo">跳转</a>
     <table border="1">
         <tr>
             <td>姓名</td>
             <td>年龄</td>
         </tr>
    <tbody id="mytbody"></tbody>
     </table>
     </body>
     </html>
    ```
    
     ```java
     @WebServlet("/demo")
     public class DemoServlet extends HttpServlet {
         @Override
         protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
             System.out.println("执行控制器");
             String name = req.getParameter("name");
             Users users = new Users();
             users.setName("张三");
             users.setAge(20);
     
             Users users1 = new Users();
             users1.setName("李四");
             users1.setAge(22);
     
             List<Users> list = new ArrayList<>();
             list.add(users);
             list.add(users1);
     
             ObjectMapper mapper = new ObjectMapper();
             String string = mapper.writeValueAsString(list);
     
     //        resp.setContentType("text/html;charset=utf-8");
             resp.setContentType("application/json;charset=utf-8");
             PrintWriter out = resp.getWriter();
             out.println(string);
             out.flush();
        out.close();
     
         }
     }
     ```
    
     

