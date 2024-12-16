		通过前面的学习，我们已经掌握了 Mybatis 中一对一，一对多，多对多的关系的配置及实现，可以实现对象的关联查询。实际开发过程中很多时候我们并不需要总是在加载用户信息时就一定要加载他的账户信息。此时就是我们所说的延迟加载。

知识点：

1、Mybatis 	中的延迟加载
​		什么是延迟加载
​		什么是立即记载

2、mybaits 	中的缓存
​		什么是缓存
​		为什么使用缓存
​		什么样的数据能使用缓存，什么样的数据不能使用
​		mybatis 	中的一级缓存和二级缓存

3、mybatis	中的注解开发
​		环境搭建
​		单标CRUD操作	（代理Dao方式）
​		缓存的配置

------

## 1、Mybaits的延迟加载 

项目：day04_eesy_01lazy

问题：在一对多中，当我们有一个用户，它有100个账户。
			在查询用户的时候，要不要把关联的账户查出来？
			在查询账户的时候，要不要把关联的用户查出来？

​			 在查询用户时，用户下的账户信息应该是，什么时候使用，什么时候查询
​			 在查询账户的时候，账户的所属用户信息应该是随着账户查询时一起查询出来。

什么是延迟加载：
			在真正使用数据时才发起查询，不用的时候不查询，按需加载（懒加载）

什么是立即加载：
			不管用不用，只要已调用方法，马上发起查询。

在对应的四种关系中：一对多、多对一、一对一、多对多
			一对多、多对多：通常情况下，我们都是采用   ==延迟加载==
			多对一、一对一：通常情况下，我们都是采用   ==立即加载==

​			

 一对一的方式实现延迟加载：

在   SqlMapConfig.xml	中配置

```xml
 <!-- 配置参数 -->
    <settings>
        <!-- 开启Mybatis支持延迟加载 -->
        <setting name="lazyLoadingEnabled" value="true"/>
        <!-- 可以不配 aggressiveLazyLoading 默认 false-->
        <setting name="aggressiveLazyLoading" value="false"/>
    </settings>
```

在测试类里面，我们不写输出语句，执行过程后，发现，他不会深入查询

 在一对多的情况下

IUserDao.xml 中

``` xml
<collection property="accounts" ofType="account" select="com.itheima.dao.IAccountDao.findAccountByUid" column="id"> </collection>

 <!-- 根据id查询用户 -->
    <select id="findById" parameterType="INT" resultType="user">
        select * from user where id = #{uid}
    </select>
```

测试时和上面的 一对一方法一样。



## 2、Mybatis 中的缓存

​	什么是缓存 ：存在于内存中的临时数据。

​	为什么使用缓存：减少和数据库的交互次数，提高执行效率

​	什么样的数据能使用缓存：经常查询的，并且不经常改变。数据的正确与否对最终结果影响不大的。

​							不使用于缓存：经常改变的数据，数据的正确与否最终对结果影响很大的。例如：商品库存，银行汇率...

​	Mybati 中的一级 缓存 和二级缓存：

​			一级缓存：
​					他指的是Mybatis中SqlSession对象的缓存
​					当我们执行查询之后，查询的结果会对同时存入到SqlSession为我们提供一块区域中。
​					该区域的结构是一个Map。当我们再次查询同样的数据，Mybatis 会先去 SqlSession 中查询是否有，有的话就直接拿出来用。
​					当SqlSession对象消失时，mybatis的一级缓存也就消失了

​					==一级缓存是 SqlSession 范围的缓存，当调用 SqlSession 的修改，添加，删除，commit(),close()等 方法时，就会清空一级缓存==

​			二级缓存：

​					他指的是Mybatis中SqlSrssion对象的缓存
​					由同一个SqlSessionFactory 对象创建的 SqlSession 共享其缓存。
​						二级缓存的使用步骤：
​								第一步：让  Mybatis   框架支持二级缓存  （在SqlMapConfig.xml 中配置）
​								第二步：让当前的映射文件支持二级缓存 （在 IUserDao.xml  中配置）
​								第三步：让当前的操作支持二级缓存 （在select 标签中 配置）

​					user1 ！= user2    原因：二级缓存存放的内容是数据，而不是对象
​					{“id":41,"username":"老王”,"address":"北京"}

## 3、Mybatis中的注解开发

项目 day04_eesy_03annotation

注意：注解和映射不能共同使用，包括存放在 别名下的其他xml文件，在执行的时候，都不会被解析，没有被调用就会报错，只有删除和放在其他地方才能解决这个问题。



解决实体类的名称和数据库字段不对应的方法：

```java
 @Select("select * from user")
    @Results(id = "userMap",value={
            @Result(id = true,column = "id",property = "userId"),
            @Result(column = "username",property = "userName"),
            @Result(column = "address",property = "userAddress"),
            @Result(column = "sex",property = "userSex"),
            @Result(column = "birthday",property = "userBirthday"),
    })
    List<User> findAll();
```

查询语句下面可以这样写，在映射方法里，cloum、property我们很熟悉了，column是数据库字段，property是实体类属性，另外，我们还可以在 Result里加一个id = “userMao"   属性，这样的话，别的查询方法，想要用到这个转换的时候，

```java
@ResultMap(value = {"userMap"})
```

就可以了，如果只有一个方法的话， value可以去掉，如只有一个属性的话，大括号也可以去掉





```java
@CacheNamespace(blocking = true)
```

开启二级缓存

测试：

```java
		SqlSession session = factory.openSession();
        IUserDao userDao = session.getMapper(IUserDao.class);
        User user = userDao.findById(51);
        System.out.println(user);

        session.close();//释放一级缓存

        SqlSession session1 = factory.openSession();//再次打开session
        IUserDao userDao1 = session1.getMapper(IUserDao.class);
        User user1 = userDao1.findById(51);
        System.out.println(user1);

        session1.close();
```

第二次不进行查询

