# Mybatis 十八问

[toc]

## 1、MyBatis 的优缺点

优点：

1. 基于 SQL 的语句编程，灵活。支持动态 SQL 语句，并可重用。
2. 消除了JDBC大量冗余代码，不需要手动开关连接
3. 很好的与各种数据库兼容（JDBC支持的数据库，MyBatis都支持）
4. 提供标签映射，支持对象与数据库的ORM字段关系映射
5. 与Spring有很好的兼容性

缺点：

1. SQL 编写工作量大，当字段多、关联表多时需要写很多映射
2. SQL 语句依赖数据库，导致可移植性差，不能随意兼容数据库。（但是可以提前写好兼容性语句）



## 2、MyBatis 与 Hibernate 有哪些不同

1. MyBatis 不完全是一个 ORM 框架，因为 Mybatis 需要程序员自己编写SQL
2. Mybatis 直接编写原生 sql，可以严格控制 sql 执行性能，灵活度高。
3. Hibernate 对象关系映射能力强，数据无关性好，可以节省很多代码，提高效率



## 3、#{}和${} 的区别是什么

`#{}` 是预编译，`${}` 是字符替换，使用预编译可以有效防止 SQL 注入。



## 4、当实体类的属性和表中字段名不一样怎么办

1. 起别名，使别名与实体类属性名一致
2. 通过 `<resultMap>` 来映射字段



## 5、通过XML映射与Dao接口对应，请问Dao接口的工作原理是什么

​		Dao接口即 Mapper 接口，接口的全限名，就是映射文件中的 namespace 的值，接口的方法，就是映射文件中的 Mapper 的 Statement 的id，接口方法内的参数，就是传递sql的参数。

​		Mapper 接口是没有实现类的，当调用接口的方法时，接口全限定名+方法名拼接字符串作为 key 值，可唯一定位一个 MapperStatment，在 Mybatis 中，每一个 `<select>`、`<updae>`、`<insert>`、`<delete> ` 标签，都会被解析为一个 MapperStatment 对象。

​		Mapper 接口的工作原理是 JDK 动态代理，Mybatis运行时会使用 JDK 动态代码为 Mapper 接口生成代理对象 proxy，代理对象会拦截接口方法，转而执行 MapperStatment 所代表的 sql，然后将sql执行接口返回。



## 6、Mybatis 如何进行分页的

​		Mybatis 使用 RowBounds 对象进行分页，它是针对 ResultSet 结果集执行的内存分页，而非物理分页，可以在 sql 内直接书写物理分页的参数来完成物理分页功能，也可以使用分页插件来进行物理分页。



## 7、如何进行批量插入

首先创建一个简单的 insert 语句

```xml
<insert id="insertName">
insert into xiang(name) values (#{value})
</insert>
```

然后 Java 代码中这样写

```java
List<String> names = new ArraysList();
names.add("I");
names.add("am");
names.add("xiang");
names.add("xiang");

SqlSession sqlSession = SqlSessionFactory.openSession(executroType.bath);
try{
    NameMapper mapper = sqlSession.getMapper(nameMapper.class);
    for(String name::names){
        mapper.inserName(name);
    }
    sqlSession.commit();
}catch(executor e){
    ...
} finally {
    sqlSession.close();
}
```



## 8、在 Mapper 中如何传递多个参数

### 8.1、数字

```java
public User queryUser(String name,String sex);
```

对应的 xml,`#{0}` 代表第一个参数 name、`#{1}` 代表第二个参数 sex

```sql
select * from user where name = #{0} and sex = #{1}
select * from user where name = #{param0} and sex = #{param1}
```

### 8.2、@Param

```java
public User queryUser(@Param("name")String name,@Param("sex")String sex);
```

这是默认情况，不写 param 参数默认与变量名为 param值

```xml
select * from user where name = #{name} and sex = #{sex}
```

还有一种封装 Map 的办法。用的比较少



## 9、Myabtis 动态sql

Myabtis 动态sql可以在 xml 映射文件内，以标签形式编写sql，目前有 trim、set、foreach、if、choose、when、otherwise、bind



## 10、Xml 映射文件标签

​     除了常见的 select、insert、update、delete 之外，还有 resultMap、parameterMap、sql、include、selectKey，加上刚刚说到的 9个动态sql标签。



## 11、一对多怎么写

​		一对一太简单了，直接来一对多吧

```xml
<select id="selectBlog" resultMap="blogResult">
  select
  B.id as blog_id,
  B.title as blog_title,
  B.author_id as blog_author_id,
  P.id as post_id,
  P.subject as post_subject,
  P.body as post_body,
  from Blog B
  left outer join Post P on B.id = P.blog_id
  where B.id = #{id}
</select>
```

```xml
<resultMap id="blogResult" type="Blog">
  <id property="id" column="blog_id" />
  <result property="title" column="blog_title"/>
  <collection property="posts" ofType="Post">
    <id property="id" column="post_id"/>
    <result property="subject" column="post_subject"/>
    <result property="body" column="post_body"/>
  </collection>
</resultMap>
```



## 12、Mybatis 一对一具体怎么操作的，一对多呢？

​		有联合查询的嵌套语句，联合查询是几个表关联查询，只查询一次，通过 resultMap 里配置的 association 节点配置一对一的类就可以完成。嵌套查询是先查一个表，根据这个表的结果，外键id，再去查另一个表的数据，也是通过 association 配置，但是另表的查询通过 select 属性配置

​		一对多，逻辑差不多，一对一是 association配置，一对多是通过配置 collection。



## 13、关于延迟加载

​		Mybatis 仅支持 一对一、一对多关联对象的延迟加载，通过 lazyLoadingEnable = true、false 开闭。原理就是 CGLIB 创建目标对象的代理。当目标进入方法时，假设有 A 对象里面有个 B对象，要获取到 A里面的 B的名字，那方法大概是这样写的  a.getB().getName()，就会先去 getB() 拿到了B 字后，再去 getName()，理论上这样讲挑不出什么毛病来，但你实在不懂是咋回事 可以去看 https://blog.csdn.net/qq_41775769/article/details/120090159

​		不光是 Mybatis ，几乎所有包括 Hibernate，支持延迟加载的原理都是一样的。



## 14、Mybatis 的一级、二级缓存

​		讲到缓存，就应该简单说一说缓存是什么。

​		打个实际的例子，你总是很频繁的看手机，把手机拿出来看一眼，再放进口袋，没有缓存之前，你总是这样反反复复，开启缓存后，你看完手机，不放回去了，就放在手上，直到你下次要看手机，直接拿起来看就行。但是你又要掏钱包，你只能把手机放回去，再把钱包拿到手上。

​		例子举完....

1. 一级缓存基于 PerpetualCache 的 HashMap 本地缓存，其存储作用域为 Session、当Session flush或close之后，该 Session 中的所有 Cache就会清空，默认是开启一级缓存的。
2. 二级缓存和一级缓存机制一样，默认采用 PerpetualCache，HashMap 存储，不同是作用域为 Mapper（Namespace），并且可以自定义存储源，默认不开启，使用二级缓存属性类需要实现 Serializable 序列接口
3. 对于缓存数据更新机制，当某一个作用域（一级缓存 Session/二级缓存 NameSpace）的进行了 增删改操作后，默认该作用域所有的 select 缓存被清除



## 15、什么是Mybatis的接口绑定，有哪些实现？

​		接口绑定说白了，就是把 SQL语句 和 接口绑定到一起，这样方法就可以执行的了 SQL了，有2种方法

1. xml，指定xml映射文件里的 nameSpace 必须为接口的全路径名，对应到接口。
2. 注解，直接在方法上加，简单暴力有 @Select、@Update 等

说到这里，就不得不提一个大家都遵守的规范，一个工程里，要么都用注解要么都用xml，不要问我为什么知道，又一次这样干过，被同事们来了个爱的抱抱



## 16、Mybatis 的mapper 接口调用时有哪些要求？

1. Mapper 接口方法名和 mapper.xml 中定义的每个 SQL 的id相同
2. Mapper 接口方法的输入参数类型和 mapper.xm 中定义的每个 sql 的parameterType 类型相同
3. Mapper 接口方法的输出类型和 mapper.xml 中定义的每个 resultType 类型相同
4. mapper.xml 中 namespace 即是 mapper 接口的类路径



## 18、简述 Mybatis 的插件运行原理，以及如何编写一个插件

​		Mybatis 仅可以编写针对 ParameterHandler、ResultSetHandler、StatementHandler、Executor 这4种接口的插件，Mybatis 使用JDK 的动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这4种接口对象的方法时，就会进入拦截方法，具体就是 InvocationHanlder 的 invoke() 方法，当然，只会拦截那些你指定需要拦截的方法。

​		编写插件：实现 Mybatis 的Intercpetor 接口并复写 intercpet() 方法，然后在给插件编写注解，指定要拦截哪一个接口的方法即可，记住，别忘了在配置文件中配置你编写的插件。