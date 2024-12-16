## 1、Mybatis 实现多表联查

1. Mybatis 实现多表查询的方式
     1. 业务装配 对两个表编写单标查询语句，在业务(Service) 把查询的两个结果进行关联
     2. 使用 Auto Mapping 特性，在实现两表联合查询时，通过别名完成映射
     3. 使用 Mybatis 的 <resultMap> 标签进行实现
2. 在进行多表查询时，类中包含另一个类的对象的分类
     1. 单个对象
     2. 集合对象

## 2、< resultMap> 标签

1. <resultMap> 标签写在 mapper.xml  中，由程序员控制  SQL 查询结果与实体类的映射关系。
   
     1. 默认  Mybatis 使用 Auto Mapping 特效
2. 使用 <resultMap> 标签时，<select>  标签不写 resultType 属性，而是使用  resultMap 属性引用  <resultMap> 标签

3. 使用 <resultMap> 实现单标映

     1. 数据库设计

          ![image-20200709182259681](images/%E6%95%B0%E6%8D%AE%E5%BA%931.png)

     2. 实体类设计

          ```java
          public class Teacher {
              private int id1;
              private String name1;
          }
          ```

     3. mapper.xml 代码

          ```xml
          <resultMap type="teacher" id="mymap">
              <!-- 主键使用id配置映射关系 -->
              <id column="id" property="id1"/>
              <!-- 其他列使用result 标签来配置映射关系-->
              <result column="name" property="name1"/>
          </resultMap>
          
          <select id="selAll" resultMap="mymap" >
              select * from teacher
          </select>
          ```

     4. 使用 resultMap 实现关联单个对象（N+1方式)

          1. N+1 查询方式，先查询出某个表的全部信息，再根据这个表的信息查询另一个表的信息

          2. 与业务装配的区别：

               1. 在service里面写的代码，由 mybatis 完成装配

          3. 实现步骤：

               1. 在 `Student` 实体类中包含一个 `Teacher` 对象

                    ```java
                    public class Student {
                        private int id;
                        private String name;
                        private int age;
                        private int tid;
                        private Teacher teacher;
                    }
                    ```

               2. 在  `TeacherMapper` 中提供一个查询 

                    ```xml
                    <mapper namespace="com.bjsxt.mapper.TeacherMapper">
                            <select id="selById" resultType="teacher" parameterType="int">
                                select * from teacher where id =#{0};
                            </select>
                    </mapper>
                    ```

               3. 在 `StudentMapper` 中

                    1. `<association> ` 装配一个对象时使用
                    2. `property` 对象在类中的属性名
                    3. `select`  通过那个查询  查询出这个对象的信息
                    4. `colunm`  把当前表的哪个列的值作为参数传递给另一个查询
                    5. 大前提使用  N+1  方式，如果列名和属性名相同即可不配做，使用 Auto mapping 特效，但是 mybatis 默认只会给列装配一次

                    ```xml
                    <mapper namespace="com.bjsxt.mapper.StudentMapper">
                        <resultMap id="stuMap" type="student">
                            <!-- 特效5 -->
                            <!-- <id property="id" column="id"/> -->
                            <!-- <result property="name" column="name"/> -->
                            <!-- <result property="age" column="age"/> -->
                            <result property="tid" column="tid"/>
                            <!-- 如果要关联一个对象-->
                            <association property="teacher" select="com.bjsxt.mapper.TeacherMapper.selById" column="tid"></association>
                        </resultMap>
                        <select id="selAll" resultMap="stuMap">
                            select * from student
                        </select>
                    </mapper>
                    ```

     5. 使用 `reusltMap`  实现关联单个对象（联合查询方式）

          1. 只需要编写一个 SQL，在 StudentMapper 中添加下面效果

               1. <associaton/>  只要专配一个对象就用这个标签
               2. 此时把 <association/>  小的  <resultMap>  看待
               3. javaType  属性：<association/>  专配完后返回一个什么类型的对象，取值是一个类（或类的别名）

               ```xml
               <resultMap type="Student" id="stuMap1"> 
                   <id column="sid" property="id"/> 
                   <result column="sname" property="name"/> 
                   <result column="age" property="age"/> 
                   <result column="tid" property="tid"/> 
                	<association property="teacher"javaType="Teacher" >
                       <id column="tid" property="id"/> 
                       <result column="tname" property="name"/> 
                   </association>
               </resultMap> 
               <select id="selAll1" resultMap="stuMap1"> 
                   select s.id sid,s.name sname,age age,t.id tid,t.name tname FROM student s left outer join teacher t on s.tid=t.id </select>
               ```

     6. N+1 方式和联合查询方式对比

          1. N+1  需要不确定时
          2. 联合查询：需求中确定查询时两个表都一定要查询

     7. N+1 名由来

          1. 举栗子：学生中有3条数据
          2. 需求：查询所有学生信息教授老师的信息
          3. 需要执行的SQL 命令
               1. 查询完全学生信息 select * from 学生
               2. 执行3遍  select * from 老师 where id = 学生外键
          4. 使用多条 SQL 命令查询两表数据时，如果希望的数据都要查询出来，需要执行N+1条SQL 才能把所有数据库查询出来
          5. 确定：
               1. 效率低
          6. 优点：
               1. 如果有的时候，不需要查询学生是同时查询老师，只需要执行一个 select * from student;
          7. 适用场景：有的是还需要查询学生同时查询老师，有的时候，只需要查询学生
          8. 如何解决  N+1 查询带来的效率低的问题
               1. 默认带的前提，每次都是两个都查询
               2. 使用两表联合查询

## 3、使用< resultMap>查询关联集合对象

1. 在 Teacher 中添加  List<Student>

     ```java
     public class Teacher {
         private int id;
         private String name;
         private List<Student> list;
     }
     ```

2. 在  StudentMpper.xml 中添加通过 id 查询 

     ```xml
     <mapper namespace="com.bjsxt.mapper.StudentMapper">
         <select id="selByTid" resultType="student" parameterType="int">
             select * from student where tid = #{0}
         </select>
     </mapper>
     ```

3. 在 TeacherMapper.xml  中添加查询全部

     1. < collection/> 当属性是集合

     ```xml
     <mapper namespace="com.bjsxt.mapper.TeacherMapper">
         <resultMap id="mymap" type="teacher">
             <id column="id" property="id"/>
             <result column="name" property="name"/>
             <collection property="list"  select="com.bjsxt.mapper.StudentMapper.selByTid" column="id"></collection>
         </resultMap>
     
         <select id="selAll" resultMap="mymap">
             select * from teacher
         </select>
     </mapper>
     ```

## 4、使用< resultMap> 实现加载集合数据（联合查询方式）

1. 在 teacherMapper.xml  中添加

     1. mybatis 可以通过主键判断对象是否被加载
          1. 我们不需要担心 teacher  被创建重复

     ```xml
     <mapper namespace="com.bjsxt.mapper.TeacherMapper">
         <resultMap id="mymap2" type="teacher">
             <id column="id" property="id"/>
             <result column="tname" property="name"/>
             <collection property="list" ofType="student">
                 <id column="sid" property="id"/>
                 <result column="sname" property="name"/>
                 <result column="age" property="age"/>
                 <result column="tid" property="tid"/>
             </collection>
         </resultMap>
         <select id="selAll1" resultMap="mymap2">
             select t.id tid,t.name tname,s.id sid,s.name sname,age,tid from teacher t LEFT JOIN student s on t.id=s.tid
         </select>
     </mapper>
     ```

## 5、使用Auto Mapping 结合别名实现多表查询

1.  只能使用多表联合查询

2. 要求：查询出的列名和属性名必须相同

3. 实现方式：

     1. 在 SQL 是关键字符，两个添加  反引号

     ```xml
     <mapper namespace="com.bjsxt.mapper.StudentMapper">
         <select id="selAll" resultType="student">
             select t.id `teacher.id`,t.name `teacher.name`,s.id id,s.name name,age,tid from teacher t LEFT JOIN student s on t.id=s.tid
         </select>
     </mapper>
     ```

## 6、Mybatis 注解

1. 注解：为了简化配置文件
2. Mybatis 的注解简化 mapper.xml 文件
     1. 如果动态 SQL 依然使用 mapper.xml 
3. mapper.xml  和注解可以共存
4. 使用注解时  mybatis.xml  中 <mappers> 使用
     1. <package/>
     2. <mapper class=""/>

### 6.1、实现查询

```java
@Select("select * from teacher")
List<Teacher> selAll();
```
### 6.1、实现新增

```java
@Insert("insert into teacher values(default,#{name})")
int insTeacher(Teacher teacher);
```
### 6.2、实现修改

```java
@Update("update teacher set name=#{name} where id=#{id}")
int updTeacher(Teacher teacher);
```
### 6.3、实现删除

```java
@Delete("delete from teacher where id=#{id}")
int delById(int id);
```
### 6.4、实现< resultMap>关联集合

1. @Result() 相当于 <resultMap>
2. @Result()  相当于<id/> 或 <result/>
     1. Result(id="true")相当于 <id/>
3. @  Many() 相当于 <association/>

```java
// com.bjsxt.mapper.TeacherMapper.class
@Results(value = {
        @Result(id=true,property = "id",column = "id"),
        @Result(property = "list",column = "id",many = @Many(select = "com.bjsxt.mapper.StudentMapper.selByTid"))
})
@Select("select * from teacher")
List<Teacher> selTeacher();
```
```java
// com.bjsxt.mapper.StudentMapper.class
@Select("select * from student where id = #{0}")
List<Student> selByTid(int id);
```



## 7、运行原理

1. 运行过程中涉及到的类

     1. Resources Mybatis 中  IO 流的工具类  ==（开始读取mybatis.xml）==

          1. 加载配置文件

     2. SqlSessionFactoryBuilder()  构建器

          1. 作用  ：创建 SqlSessionFactory 接口的实现类

     3. XMLConfigBuilder  Mybatis全局配置文件内容构建器类

          1. 作用负责读取流内容并转换为 java 代码

     4. Configuration  封装了全局配置文件所有的配置信息

          1. 全局配置文件内容存放在Configuration 

     5. DefaultSqlSessionFactory 是 SqlSessionFactory 接口的实现

          > 到此  factory  就构建出来了

     6. Transaction 事务类 ==（开始构建SqlSession）==

          1. 每一个 SqlSession 会带有一个 Transaction 对象

     7. Environment类，把Mybatis.xml 中 Environment中连接数据库相关的信息给加载进去

     8. TransactionFactory 事务工厂

          1. 负责生产 Transaction

     9. Executor  Mybatis 执行器

          1. 负责执行 SQL 命令
          2. 相当于  JDBC  中 statement 对象（或 PreparedStatement 或 CallableStatement）
          3. 默认的执行器  SimpleExcutor
          4. 批量操作 BatchExcutor
          5. 通过  openSession（参数控制）

     10. DefaultSqlSession 是 SqlSession 接口的实现类

     11. ExceptionFactory  Mybatis 中 异常工厂

     12. ErrorController  错误容器，出错往这里收集

2. 流程图

![image-20200711024722052](images/%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

3. 文字解析
     1. 在 MyBatis 运行开始时需要先通过  Resources、 加载全局配置文件，下面需要实例化 SqlSessionFactoryBuilder 构建器帮助 SqlSessionFactory 接口实现类 DefaultSqlSessionFactory
     2. 在实例化  DefaultSqlSessionFactory 之前需要先创建 XMLConfigBuilder 解析全局配置文件流，并把解析结果存放在 Configuration中，字后吧 Configuratin 传递给 DefaultSqlSessionFactory 到此 SqlSessionFactory 工厂创建成功
     3. 由SqlSessionFactory 工厂创建 SqlSession
     4. 每次创建SqlSession时，都需要  TransactionFactory 构建 Transaction 对象，同时还需要创建 SqlSession 的执行器 Excutor ，最后实例化  DefaultSqlSession，传递给SqlSession接口 
     5. 根据项目需求使用  SqlSession 接口中的 API 完成具体事务操作
     6. 如果事务执行失败，rollback回滚事务
     7. 如果事务执行成功提交给数据库
     8. 到此 就是MyBatis 的运行原理