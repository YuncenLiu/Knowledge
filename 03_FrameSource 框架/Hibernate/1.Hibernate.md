

## 1、Hibernate优势

1. 优势：
     1. 简化开发，提高开发效率
     2. 更加面向对象设计
     3. 更好的性能
     4. 更好的移植性
2. 版本发展：
     1. Hibernate 3 是一个跨越，Hibernate 3以前的版本，用的人很少，也是一个非常成熟的框架，我们学的 3.2
3. 实际应用：
     1. 众多大型项目，金融、企业管理、政府管理、ERP等等

### ORM

Object（对象） - relational （ 关系型数据库） - mapping（对象关系映射）

基本思想：

1. 将关系数据库中的数据库转化为对象，这样，开发人员就可以以一种完全面向对象的方式来实现对数据的操作。
2. 我们以前讲 java 对象的数据存入数据库，需要通过 JDBC 进行繁琐的转换，反之亦然。ORM 框架，比如 Hibernate 就是我们这部分工作进行了封装，简化了我们的操作。

## 2、新建一个 Hibernate 程序

### 2.1、导入 Maven 坐标

```xml
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.0.12.Final</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.6</version>
</dependency>
```

### 2,2、Hibernate 配置文件

在src 根目录下，新建一个 `hibernate.cfg.xml` 配置文件

```xml
<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>

    <session-factory name="foo">
        <!-- 显示sql语句 -->
        <property name="show_sql">true</property>
        <property name="hbm2ddl.auto">create</property>

        <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
        <property name="connection.driver_class">com.mysql.jdbc.Driver</property>
        <property name="connection.url">jdbc:mysql:///ssm</property>
        <property name="connection.username">root</property>
        <property name="connection.password">root</property>

        <mapping resource="com/bjsxt/testhib/po/User.hbm.xml"/>
    </session-factory>
</hibernate-configuration>
```

+ create-drop 运行时，先创建，运行完，再删除
+ create：每次运行前，都会删除已有的。在删除。测试时可以使用 create
+ update：映射文件和表，如果不对应做个更新
+ validate：看映射文件和表是不是对应，如果不对应，他会报错，经常用它，保险一些。

### 2.3、实体类

```java
public class Users {
    private int id;
    private String username;
    private String password;
    // getter setter ...
}
```

### 2.4、XML文件

在实体类同级目录下，创建 `User.hbm.xml` 配置文件

```xml
<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">

<hibernate-mapping package="com.bjsxt.testhib.po">
    <class name="Users"
           table="_users"
           lazy="true">
        <comment>Users may bid for or sell auction itesm.</comment>

        <id name="id">
            <generator class="native"/>
        </id>

        <property name="username"
                  type="java.lang.String"
                  not-null="false"
                  length="20"/>
        <property name="password"
                  type="java.lang.String"
                  not-null="false"
                  length="20"/>
    </class>
</hibernate-mapping>
```

### 2.5、测试文件

```java
public class Test {
    public static void main(String[] args) {
        Configuration conf = new Configuration();
        conf.configure();

        SessionFactory factory = conf.buildSessionFactory();
        Session session = factory.openSession();

        Users users = new Users();
        users.setId(1);
        users.setUsername("张三");
        users.setPassword("ABC");

        session.save(users);
        session.close();
    }
}
```

### 2.6 输出：

```txt
Hibernate: drop table if exists _users
Hibernate: create table _users (id integer not null auto_increment, username varchar(20), password varchar(20), primary key (id)) comment='Users may bid for or sell auction itesm.'
Hibernate: insert into _users (username, password) values (?, ?)
```

创建了一个 _users 表，并插入了 users 实例类的参数

## 3、Hibernate 核心 API

### 3.1、Configuration

负责管理数据库的配置信息，数据库的配置信息包含 Hibernate 链接数据的一些基本信息（hibernate.cfg.xml），可以通过

```java
Configuration conf = new Configuration().configure();
```

如果更改了文件位置可以

```java
File file = new File("c:\\myhibernate.xml");
Configuraton config = new Configuraton().configure(file);
```

### 3.2、SessionFactory

针对耽搁数据库映射关系经过编译后的内存镜像，是线程安全的（不可变）。作为 session的工厂 和 ConnectionProvider  的客户。 SessionFactory 可以在进程或集群的级别上，为那些事务之间可以重用数据提供了二级缓存

SessionFactory 使用要点如下：

1. 负责创建 Session 对象，可以通过  Configuration 对象创建 SessionFactory 对象
2. SessionFactory 对象中保存了当前的数据配置信息和所有映射关系以及预定义的 SQL 语句
3. SessionFactory 还负责维护 Hibernate 的二级缓存
4. SessionFactory 对象的创建会有较大的开销，而且 SessionFactory 对象才去了线程安全的数据，因此在实际中  ，SessionFactory 对象可以尽量共享，在大多数情况下，一个应用真的一个数据可以共享一个  SessionFactory 实例

SessionFactory 创建代码如下：

```java
Configuration conf = new Configuration().configure();
SessionFactory factory = conf.buildSessionFactory();
```

### 3.3、Session

表示应用程序与持久缓存之间的交互操作的一个单线程对象，此对象生存期很短。其隐藏了 JDBC 链接，也是 Transaction 的工厂。它会有一个针对持久层对象的必选 （第一级）缓存，在遍历对象图或者根据持久化标识查询对象时会用到。

session 定义了添加、更新、删除、和查询等操作，是持久化操作的基础。Session 是设计是非线程安全的，因此 一个 session 对象只可以由一个线程使用

Session 对象可以由 SessionFactory 对象创建

```java
Configuration conf = new Configuration().configure();
SessionFactory factory = conf.buildSessionFactory();
Session session = factory.openSession();
```

### 3.4、Transaction

将应用代码从底层的事务现实中抽象出来，这可能是一个 JDBC 事务，使用 Hibernate 进行操作（增、删、改）必须现实的调用 Transaction （默认：autoCommit=false）

```java
Tansaction tx = session.beginTransaction();
```

## 4、标准的 Hibernate 代码

### 4.1、封装 HibUtil 类

SessionFactory 只能有一个（单利模式或者变为 static 属性），大家共享使用

```java
public class HibUtil {
    private static SessionFactory factory;

    private HibUtil(){}

    static {
        Configuration conf = new Configuration();
        conf.configure("hibernate.cfg.xml");
        conf.configure();
        factory = conf.buildSessionFactory();
    }
    public static SessionFactory getFactory(){
        return factory;
    }
    public static Session getSession(){
        return factory.openSession();
    }
}
```

> 此时测试类应该这写
>
> ```java
> public class Test2 {
>     public static void main(String[] args) {
>         Session session = null;
>         Transaction tx = null;
>         try {
>             session = HibUtil.getSession();
>             tx = session.beginTransaction();
>             session.save(new Users());
>             tx.commit();
>         } catch (Exception e){
>             if (tx != null){
>                 tx.rollback();
>             }
>             throw e;   // 一点要把异常报告给上一层
>         } finally {
>             if (session!=null){
>                 session.close();
>             }
>         }
>     }
> }
> ```

### 4.2、Hibernate 对象的状态和生命周期

![image-20200725172944457](images/Hibernate%E5%AF%B9%E8%B1%A1%E7%9A%84%E7%8A%B6%E6%80%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F.png)

### 4.2.1、Transient 瞬间/临时态

1. 使用 new 操作符初始化的对象不是立即就持久的
2. 跟 session 没有任何关系
3. 跟数据库没有任何关系，数据库中没有对应记录存在

#### 4.2.2、Persist 持久态

1. 和session 对象相关，以 map 形式存入到 session 中
2. 在数据库中对应的记录

#### 4.2.3、Detached、托管/游离态

1. 和 session 对象无关
2. 在数据库中有对应记录

