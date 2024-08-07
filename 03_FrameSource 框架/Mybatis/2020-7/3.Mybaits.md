## 一、Mybatis 接口绑定方案及多参数传递

1. 作用：实现创建了一个接口或把  mapper.xml   由   mybatis  生成接口的实现类，通过调用接口对象就可以获取  mapper.xml  中编写的 sql

2. 后面 mybatis 和 spring 整合时使用的这个方案

3. 实现步骤：

     1. 创建一个接口
          1. 接口包名和接口名与 mapper.xml  中  <mapper>namespace  相同
          2. 接口名方法名和 mapper.xml 标签的 id 属性相同
          3. 在 mybatis.xml  中使用  <pageage>  进行扫描接口和 mapper.xml

4. 代码实现步骤：

     1. 在 mybatis.xml 中 <mappers> 下使用 <package>

          ```xml
          <mappers>
              <package name="com.bjsxt.mapper"/>
          </mappers>
          ```

     2. 在 com.bjsxt.mapper 下新建接口 `LogMapper.java`

     3. 在 com.bjsxt.mapper 下新建 `LogMapper.xml`

          1. ==namespace  必须 和 接口 全限定路径（包名+类名）一致==

               ```java
               LogMapper logMapper = session.getMapper(LogMapper.class);
               List<Log> logs = logMapper.selAll();
               for (Log log : logs) {
                   System.out.println(log.toString());
               }
               session.close();
               ```

               ```java
               public interface LogMapper {
                   List<Log> selAll();
               }
               ```

               ```xml
               <mapper namespace="com.bjsxt.mapper.LogMapper">
                       <select id="selAll" resultType="log">
                               select * from log
                       </select>
               <mapper>
               ```

          2. id 必须和接口中方法名相同

          3. 如果接口方法为==多个参数==可以省略 parameterType接口实例化

     4. ==多个参数==实现办法

          1. 在接口中声明方法

               ```java
               List<Log> selByAccInAccout(String accin,String accout);
               ```

          2. 测试类：

          ```java
          //需要给接口一个实例化对象，使用的是JDK的动态代理模式，面向接口的代理设计模式（必须有接口）
          LogMapper logMapper = session.getMapper(LogMapper.class);
          List<Log> logs = logMapper.selByAccInAccout("3", "1");
          for (Log log : logs) {
          	System.out.println(log.toString());
          }
          ```

          3. 在mapper.xml 中添加

          ```xml
          <!-- 当多参数时，不需要写 parameterType -->
          <select id="selByAccInAccout" resultType="log">
                  select * from log where accin=#{0} and accout=#{1}
              	<!-- select * from log where accin=#{param1} and accout=#{param2} -->
          </select>
          ```
            > 想在 SQL 语句里  强行改成  accin 和 accout 的话，可以以下操作

            ```java
            List<Log> selByAccInAccout(@Param("accin")String accin,@Param("accout")String accout);
            ```

            ==myabtis 把参数换成了map了，其中@Param("key") 参数内容就是 map 的 value==





## 二、动态SQL

1. 根据不同的条件需要执行不同的 SQL 命令，称为动态的 SQL
2. MyBaits 中动态 SQL 在 mapper.xml 中添加逻辑判断等

### 2.1、`If`

```xml
<select id="selByAccinAccout" resultType="log">
    select * from log where 1=1
    <if test="accin != null and accin != ''">
        and accin = #{accin}
    </if>
    <if test="accout != null and accout != ''">
        and accout = #{accout}
    </if>
</select>
```

### 2.2、`where` 

1. 当编写  where  标签时，如果内容中第一个是 and  去掉第一个 and
2. 如果 <where>   中有内容会生成  where 关键字，如果没有内容不会生成 where  关键字

```xml
<select id="selByAccinAccout" resultType="log">
    select * from log
    <where>
        <if test="accin != null and accin != ''">
            and accin = #{accin}
        </if>
        <if test="accout != null and accout != ''">
            and accout = #{accout}
        </if>
    </where>
</select>
```

### 2.3、`choose`  `when`  `otherwise`

1. 只有有一个成立，其他都不执行

```xml
<select id="selByAccinAccout" resultType="log">
    select * from log
    <where>
        <choose>
            <when test="accin != null and accin != ''">
                and accin = #{accin}
            </when>
            <when test="accout != null and accout != ''">
                and accout = #{accout}
            </when>
        </choose>
    </where>
</select>
```

### 2.4、< set > 用在修改SQL 中 set 从句

1. 作用：去掉最后一个逗号
2. 作用：如果 < set > 里面有内容生成 set，没有就不生成
3. id=#{id} 目的是防止 < set >中没有内容，myabtis不生成 set 关键字，如果修改中没有  set 从句，是SQL 语法错误

```xml
<update id="upd" parameterType="log">
    update log
    <set>
        id=#{id},
        <if test="accIn!=null and accIn!=''">
            accin = #{accIn},
        </if>
        <if test="accOut!=null and accOut!=''">
            accout = #{accOut},
        </if>
    </set>
    where id = #{id}
</update>
```

### 2.5、`trim`

==prefix 前面加==
==prefixOverrides  前面减==

==suffix 后面加==
==suffixOverrides 后面减==

```xml
<update id="upd" parameterType="log">
    update log
    <trim prefix="set" suffixOverrides=",">
        a = a,
    </trim>
</update>
```

### 2.6、`bind`

替换字符串，在原内容上添加字符串

```xml
<select id="selByLog" resultType="log" parameterType="log">
    <bind name="money" value="'$'+money"/>
    #{money}
</select>
```

此方法可以实现  sql 中的模糊查询：

> <bind name="accin" value="'%'+ accin + '%'"/>

### 2.7、`foreach`

1. 循环参数内容，在内容前后添加内容，添加分隔符功能

2. 使用场景 ： in 查询中，批量新增 （foreach 比较低）

     1. 如果虚妄批量新增，SQL 命令

          ```SQL
          insert into log VALUES
          (default,1,2,3),(default,1,2,3),(default,1,2,3)
          ```

     2. oppenSession() 必须制定

          1. 底层  JDBC  的 PreparedStatement.addBatch();

          ```java
          factroy.openSession(ExecutorType.BATCH)
          ```

     3. 实例：

          1. collection = " "   要遍历的集合
          2. item  迭代变量  ，#{迭代变量名}  获取内容
          3. open  循环后左侧添加内容
          4. close 循环后右侧添加内容
          5. separator  每次循环时，元素之间的分隔符

          ```xml
          <insert id="ins" parameterType="list">
              insert into log values
              <trim suffixOverrides=",">
                  <foreach collection="list" item="log">
                      (default,#{log},2,2),
                  </foreach>
              </trim>
          </insert>
          ```

### 2.8、`sql`   `include`

1. 某些  SQL 片段如果希望重复使用，可以使用  < sql > 定义这个片段

     ```xml
     <select id="selAll" resultType="log">
         select <include refid="mysql"></include>
         from log
     </select>
     
     <sql id="mysql">
         id,accin,accout,money
     </sql>
     ```

2. 在 < select > 或 < delete > 或 < insert >  中使用  < include > 引用

## 三、ThreadLocal

1. 线程容器，可以给线程绑定一个   Object  内容，后只要线程不变，就可以随时取出

     1. 改变线程，无法取出内容

2. 语法示例：

     ```java
     public class Test {
         public static void main(String[] args) {
             ThreadLocal<String> threadLocal = new ThreadLocal<>();
             threadLocal.set("测试");
     
             new Thread() {
                 @Override
                 public void run() {
                     String result = threadLocal.get();
                     System.out.println("结果" + result);
                 }
             }.start();
         }
     }
     ```

#### 3.1 过滤器思想

> 我个人测试过后，会报一个 Cannot commit, transaction is already closed  错误，但是不影响程序的执行...  很变扭，如果取消 OpenSessionInView 类中的 sesson.cimmit() 方法，则不会报错。但是就不能提交了。导致错误的原因是多次经过过滤器引起的....    至今未解决..

#### 3.2、具体实现

1. `MybatisUtil` 帮助类：避免重复实例化工厂

     ```java
     public class MyBatisUtil {
         // factory 实例化的过程是一个比较耗费性能的过程
         private static SqlSessionFactory factory;
     
         private static ThreadLocal<SqlSession> tl = new ThreadLocal<>();
     
         static{
             try {
                 InputStream is = Resources.getResourceAsStream("mybatis.xml");
                 factory = new SqlSessionFactoryBuilder().build(is);
             } catch (IOException e) {
                 e.printStackTrace();
             }
         }
     
         // 获取 SqlSession
         public static SqlSession getSession(){
             SqlSession session = tl.get();
             if (session == null) {
                 tl.set(factory.openSession());
             }
             return tl.get();
         }
     
         public static void closeSession(){
             SqlSession session = tl.get();
             if (session!=null){
                 session.close();
             }
             tl.set(null);
         }
     }
     ```

2.  `OpenSerssionInView`使用过滤器，这里提供了两个方法，一个是使用注解的方式，第二个是取消注解，采用 web.xml 的方式 两者选其一即可，一起用也没问题

     ```java
     @WebFilter("/*")
     public class OpenSerssionInView implements Filter {
         @Override
         public void init(FilterConfig filterConfig) throws ServletException {
     
         }
     
         @Override
         public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
             SqlSession session = MyBatisUtil.getSession();
             try {
                 filterChain.doFilter(servletRequest,servletResponse);
                 session.commit();
             } catch (Exception e){
                 session.rollback();
                 e.printStackTrace();
             } finally {
                 MyBatisUtil.closeSession();
             }
         }
     
         @Override
         public void destroy() {
     
         }
     }
     ```

     > 因为我们是  servlet 层使用session 的，filter 正好是包裹住了service ，当程序从service 走到 servlet层时，就会经过过滤器，过滤器生效后，会在  service 的使用前后构建 session 和销毁 sesion ，达到简化代码的效果

     ```xml
     <filter>
         <filter-name>opensession</filter-name>
         <filter-class>com.bjsxt.filter.OpenSerssionInView</filter-class>
     </filter>
     
     <filter-mapping>
         <filter-name>opensession</filter-name>
         <url-pattern>/*</url-pattern>
     </filter-mapping>
     ```

     这样是 实现了  @WebFilter（“/"）的效果

3. `InsertServlet`  

     ```java
     @WebServlet("/insert")
     public class InsertServlet extends HttpServlet {
     
         private LogService logService = new LogServiceImpl();
     
         @Override
         protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
             req.setCharacterEncoding("utf-8");
             Log log = new Log();
             log.setAccIn(req.getParameter("accin"));
             log.setAccOut(req.getParameter("accout"));
             log.setMoney(Double.parseDouble(req.getParameter("money")));
     
             int index = logService.ins(log);
             if (index>0){
                 resp.sendRedirect("success.jsp");
             } else{
                 resp.sendRedirect("error.jsp");
             }
         }
     }
     ```

4. `LogService` 的实现类

     ```jade
     public class LogServiceImpl implements LogService {
         @Override
         public int ins(Log log) {
             SqlSession session = MyBatisUtil.getSession();
             LogMapper mapper = session.getMapper(LogMapper.class);
             return mapper.ins(log);
         }
     ```

5. `Mapper`  相关代码

     ```xml
     <mapper namespace="com.bjsxt.mapper.LogMapper">
         <insert id="ins" parameterType="log">
             insert into log values(default ,#{accOut},#{accIn},#{money})
         </insert>
     </mapper>
     ```

     ```java
     public interface LogMapper {
         int ins(Log log);
     }
     ```

## 四、缓存

1. 应用程序和数据库交互的过程是一个对比耗时的过程
2. 缓存存在的意义：让应用程序减少对数据库的访问，提升程序的运行
3. Mybatis 中默认  SqlSession 缓存开启
     1. 同一个 SqlSession 对象调用同一个 <select> 时，只有第一次访问数据库，第一次之后查询结果缓存到 SqlSession
     2. 缓存的是一个  statement 对象。
          1. 在 mybatis 时， 一个 <select>  标签就对应一个 statement对象
     3. 有效范围必须在 同一个session 之内
4. 缓存流程
     1. 先去缓冲区中找是否存在 statement
     2. 返回结果
     3. 如果没有缓存 statement 对象，去数据库获取数据
     4. 数据库返回查询结果
     5. 把查询结果放到对应的缓冲区

![image-20200709153520133](images/%E7%BC%93%E5%AD%98%E5%9B%BE%E8%A7%A3.png)

5. SqlSessionFactory 缓存 ==**（二级缓存**）==

     1. 有效范围：同一个 factory  内任意 SqlSession 都可以获取

     2. 什么时候使用二级缓存；

          1. 当数据被频繁使用，很少被修改

     3. 使用二级缓存的步骤

          1. 在  mappr.xml  中添加

               ```xml
               <cache readOnly="true"></cache>
               ```

          2. 如果不写 readyOnly=“true”  需要把实体类序列化

     4. 当SqlSesion 对象 close （） 时或 commit（） 时会把 SqlSession 缓存到数据刷（flush）到 SqlSesionFactory 缓存区中



> Student 项目 

![image-20200709175801991](images/student%20%E9%A1%B9%E7%9B%AE.png)