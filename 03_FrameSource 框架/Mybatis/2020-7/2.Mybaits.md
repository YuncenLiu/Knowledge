## 1、Log4j

1. 由apach 退出的开源免费的日志处理的类库

2. 为什么需要日志

     1. 在项目中编写 System.out.print() 输出到控制台，当项目发布到tomcat 后，没有控制台（在命令行界面能看见） 不容易观察到输出结果
     2. log4j 作用，不仅能把内容输出到控制台，还能输出到文件中，便于观察结果

3. 使用步骤

     1. 导入 log4j-xxx.jar
     2. 在src下新建 log4j.properties（路径和名称都不允许改变）

     ```properties
     # Set root category priority to INFO and its only appender to CONSOLE.
     #log4j.rootCategory=INFO, CONSOLE            debug   info   warn error fatal
     log4j.rootCategory=debug, CONSOLE, LOGFILE
     
     # Set the enterprise logger category to FATAL and its only appender to CONSOLE.
     log4j.logger.org.apache.axis.enterprise=FATAL, CONSOLE
     
     # CONSOLE is set to be a ConsoleAppender using a PatternLayout.
     # 负责输出的类
     log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
     # 这个表达式进行输出
     log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
     # 表达式内容
     log4j.appender.CONSOLE.layout.ConversionPattern=-- %d{ISO8601} %-6r [%0.15t] %-5p %30.30c %x - %m%n
     # 参数为  %C  只显示包的信息
     # 参数为  %m%n  显示输出内容
     
     # LOGFILE is set to be a File appender using a PatternLayout.
     log4j.appender.LOGFILE=org.apache.log4j.FileAppender
     #log4j.appender.LOGFILE.File=  path
     log4j.appender.LOGFILE.File=F:/study/IDEA/尚学堂/高级框架/Mybatis/mybatis02/src/mybatis02.log
     # 如果是false 每次都会清空再输出
     log4j.appender.LOGFILE.Append=true
     log4j.appender.LOGFILE.layout=org.apache.log4j.PatternLayout
     log4j.appender.LOGFILE.layout.ConversionPattern=-- %d{ISO8601} %-6r [%0.15t] %-5p %30.30c %x - %m%n
     
     
     ```

4. log4j 的输出级别

     1. fatal(致命错误) >  error (错误 )  > warm（警告）  >  info(普通信息)  > debug（调试信息）

   `log4j.rootCategory`  log4j 输出的地方 控制输出目的地 这里的话，只是把 info  和  console 输出到控制台还有文件里了

   `log4j.appender.CONSOLE.layout.ConversionPattern` [Log4j 输出格式控制](https://blog.csdn.net/guoquanyou/article/details/5689652)

5.  ConversionPattern 中常用几个表达式
     1. %d{YYYY-MM-dd HH:mm:ss}   时间
     2. %L  行号
     3. %m   信息
     4. %n  换行

## 2、< settings > 标签

1. 开启配置

```xml
<settings>
    <!-- Mybatis 开启了 log4j 的支持-->
    <setting name="logImpl" value="LOG4J"/>
</settings>
```

2. 在mybatis.xml 中 开启 log4j

     1. 必须保证有 log4j.jar
     2. 在src 下有 log4j.properties

3. log4j 中可以输出 指定内容的日志

     1. 命名空间（包级别）

          1. %C  包名+类名        													==<mapper> namespace 属性中除了最后一个类名==

               ```xml
               <mapper namespace="com.bjsxt.mapper">
                       <select id="selAll" resultType="com.bjsxt.pojo.People">
               ```

               1. 先在总体级别上调至成  ERROR 不输出无用信息
               2. 在设置某个指定位置级别为 DEBUG

               其中 com.bjsxt.mapper 就需要在 logrj.properties中

               ```properties
               log4j.rootCategory=ERROR, CONSOLE, LOGFILE
               log4j.logger.com.bjsxt.mapper=DEBUG
               ```

     2. 类级别

          1. namespace   属性值，namespace 类名

     3. 方法级别 

          1. 使用namespace 属性 + 标签 id 属性值

## 3、parameterType 属性

1. 在XXXMapper.xml 中的  < select > < delete >等标签中 parameterType 可以控制参数类型

     1. SqlSession 的 selectList() 和 selectOne()  的第二个参数 selectMap() 的第三个参数都有表示方法的参数

     ```java
     sqlSession.selectList("com.bjsxt.mapper.selById",1);
     ```

     2. 在Mapper.xml 中可以通过 #{} 获取参数

          1. parameterType 控制参数类型

          2. #{} 获取参数内容

               1. 使用索引，从0 开始，#{0} 表示第一个参数
               2. 也可以使用 #{baram1} 第一个参数
               3. 如果只有一个参数（只要是基本数据类型），mybaits 对#{} 里面内容没有要求，只要写内容即可
               4. 如果参数是对象#{属性名}
               5. 如果参数是map 写成  #{key}

               ```xml
               <select id="selById" resultType="com.bjsxt.pojo.People" parameterType="int">
                       select * from people where id=#{0}
               </select>
               ```

     3. #{} ${} 的区别

          1. #{} 获取参数的内容，支持索引，param1 获取指定位置参数，并且SQL 使用？占位符
          2. ${}  字符串拼接不使用？默认找 ￥{内容}  内容的 get/set 方法如果是数字，那就是一个数字 

     4. 如果在xml文件中出现“<",">",双引号 等特殊字符我们可以使用 XML 文件转义标签（XML自身）  ==（还是实现前面一样的效果）==

          1. <! [CDATA[内容]]>

     5. mybatis 中实现 mysql 分页写法

          ```java
          int pageSize = 2;
          int pageNumber = 2;
          Map<String,Object> map = new HashMap<String,Object>();
          map.put("pageSize",pageSize);
          map.put("pageStart",pageSize*(pageNumber-1));
          List<People> list = sqlSession.selectList("com.bjsxt.mapper.limit", map);
          ```
     
2. ==除了单参数和对象，需要加 ParameterType 属性，其他都不需要加 Parameter属性==

## 4、别名

1. 系统内置别名：把类型全小写

2. 给某个类起别名

     1. alias="自定义"

          ```xml
          <typeAliases>
              <typeAlias type="com.bjsxt.pojo.People" alias="peo"/>
          </typeAliases>
          ```

     2. mapper.xml 中 peo 引用People

          ```xml
          <select id="limit" resultType="peo" parameterType="map">
                  select * from people limit #{pageStart},#{pageSize}
          </select>
          ```

3. 直接给某个包下所有类起别名，别名为类名，区分大小写

     1. mybatis.xml  中配置

          ```xml
          <typeAliases>
              <package name="com.bjsxt.pojo"/>
          </typeAliases>
          ```

     2. mapper.xml 中通过类名引用

          ```xml
          <select id="limit" resultType="people" parameterType="map">
                  select * from people limit #{pageStart},#{pageSize}
          </select>
          ```

## 5、Mybatis实现新增

1. 概念复习
     1. 功能：从应用程序角度出发，软件具有哪些功能
     2. 业务：完成功能时的逻辑，对应 Service  中的一个方法
     3. 事务：从数据库角度出发，完成业务时需要执的SQL 集合，统称一个事务。
          1. 事务回滚：如果在一个事务中某个SQL 执行事务失败，希望回滚到事务的原点，保证数据数据的完整性
2. 在mybatis 中默认是关闭了 JDBC 自动提交功能
     1. 每一个 SqlSession 默认都不是自动提交事务
     2. session.commit（）  提交事务
     3. openSession(true)；自动提交 setAutoCommit(true);
3. mybatis 底层是对 JDBC 的封装
     1. JDBC 中 executeUpdate()  执行新增，删除，修改的  SQL  返回值 int，表示受影响的行数
     2. mybatis  中 <insert>   <delete>  <update> 标签没有 resultType 属性认为返回值都是int
4. 在openSession() 时 Mybaits 会创建 SqlSession 同时会创建一个 Transaction (事件)
     1. 如果出现异常，应该    session.rollback() 回滚事务



> 见 项目  bank