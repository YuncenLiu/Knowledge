## 1、Shiro 简介

​		Apache Shiro 是一个强大而灵活的开源安全框架，它干净利落地处理身份认证、授权、企业会话管理和加密。在java的世界里，安全框架管理架构有 spring secuity 和 shiro。Spring security 要依赖于 Spring，并且比较复杂，学习曲线比较高。Shiro 比较简单，既可以在 java ee中使用，也可以在java SE 中使用，并在分布式集群环境下也可以使用。

### 1.1、Shiro 的结构体系

Authenitcation：认证，验证用户是否合法，也就是登录

Authorization：授权，授予谁具有某些资源的权限

Session Management：会话管理，用户登录后的信息通过 Session Management 来进行管理，不管是在什么应用中。

Cryptography：加密，提供了常见的加密算法，使得在应用中很方便的实现数据安全，并且使用很便捷。

Web support：web 应用程序支持，Shiro 可以很方便的集成到 web 应用程序中。

Caching：缓存，Shiro 提供了对缓存的支持，支持多种缓存的架构，如：ehcache。还支持缓存数据库，如：Redis

Concurrency：并发支持，多线程并发访问

Testing：测试

Run As：支持一个用户在允许的前提下，用另外一个身份登记

Remember me：记住我

### 1.2、Shiro 的架构

![Shiro的架构](images/Shiro%E7%9A%84%E6%9E%B6%E6%9E%84.png#pic_center)

Subject 当前与软件交互的实体，是Shiro提供的接口，需要第三方对接，Subject 用于获取主体信息，Principals 和 Credentials

Security Manager：是Shiro 的心脏。是 Shiro 架构的核心，尤其是协调管理  Shiro 各个组件之间的工作。

Authenticator：认证器，负责验证用户的身份。

Authorizer：授权器，负责为合法的用户指定其权限，控制用户可以访问那些资源。

Relasm：用户通过 Shiro 来完成相关的安全工作，Shiro 是不会去维护数据信息的。在 Shiro 的工作过程中，数据的查询和获取工作，是通过 Realm 从不同的数据源来获取。 Relam 可以获取到数据库信息，文本信息等。在 Shiro 中可以有一个 Relam 也可以有多个。

## 2、用户认证

### 2.1、Authentication 用户认证

![image-20200726193726531](images/%E7%94%A8%E6%88%B7%E8%AE%A4%E8%AF%81.png)

​		验证用户是否合法。需要提提交给 Shiro，

Prinipals 用户的身份信息，Prinipals 是 Subject 的标识属性，能够唯一标识 Subject

Credentials：就是密码，只被 Subject 知道的 密匙，也可以是数字证书等。

Principals / Credentials ： 最常见的组合，用户名 、密码，在 Shiro 中通常使用 UsernamePasswordToken 来指定身份和凭证信息

pom 文件：

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>

<dependencies>
    <dependency>
        <groupId>org.apache.shiro</groupId>
        <artifactId>shiro-all</artifactId>
        <version>1.2.3</version>
    </dependency>
    <dependency>
        <groupId>commons-beanutils</groupId>
        <artifactId>commons-beanutils</artifactId>
        <version>1.9.2</version>
    </dependency>
    <dependency>
        <groupId>commons-logging</groupId>
        <artifactId>commons-logging</artifactId>
        <version>1.2</version>
    </dependency>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>servlet-api</artifactId>
        <version>2.5</version>
    </dependency>
    <dependency>
        <groupId>c3p0</groupId>
        <artifactId>c3p0</artifactId>
        <version>0.9.1.2</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>6.0.6</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.10</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.7.7</version>
    </dependency>
    <dependency>
        <groupId>log4j</groupId>
        <artifactId>log4j</artifactId>
        <version>1.2.17</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-log4j12</artifactId>
        <version>1.7.5</version>
    </dependency>
</dependencies>
```

### 2.2、在 Shiro 中用户认证流程

![image-20200726193820234](images/%E7%94%A8%E6%88%B7%E8%AE%A4%E8%AF%81%E6%B5%81%E7%A8%8B.png)

### 2.3、代码实现

1. 新建项目

2. 导入 Shiro 相关jar

     commons-beanutils-1.9.2.jar

     commons-logging-1.2.jar

     junit-4.10.jar

     shiro-all-1.2.3.jar

     slf4j-api-1.7.7.jar

     log4j-1.2.17.jar

     slf4j-log4j12-1.7.5.jar

3. log4j.properties 日志配置

     ```properties
     log4j.rootLogger=debug, stdout
     log4j.appender.stdout=org.apache.log4j.ConsoleAppender
     log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
     log4j.appender.stdout.layout.ConversionPattern=%d %p [%c] - %m %n
     ```

4. 编写 Shiro 的数据文件配置

     ```
     [users]
     zhangsan=1111
     lisi=2222
     ```

5. 编写测试

     ```java
     public class AuthenticationDemo {
         public static void main(String[] args) {
             // 1. 创建 SecurityManager 工厂 读取了相应的配置文件
             Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
             // 2. 通过 SecurityManager 工厂 获取 SecurityManager 的实例
             SecurityManager securityManager = factory.getInstance();
             // 3. 将 securityManager 对象设置到运行环境里
             SecurityUtils.setSecurityManager(securityManager);
             // 4. 通过 SecurityUtil 获取主体 Subject
             Subject subject = SecurityUtils.getSubject();
             // 5. 假如登录的用户名 zhangsan 和 1111 这里表上用户登录时，输入的信息，而 Shrio.ini 相当于数据库中存放的用户信息
             UsernamePasswordToken token = new UsernamePasswordToken("zhangsan","1111");
             // 6. 进行用户身份验证
             subject.login(token);
             // 7. 通过 subject 来判断用户是否通过验证
             if (subject.isAuthenticated()){
                 // 7.1 用户登录成功
                 System.out.println("用户登录成功");
             } else {
                 // 7.2 失败
                 System.out.println("用户名或密码不正确");
             }
         }
     }
     ```

6. 常见的异常信息及处理，在认证过程中有一个父类异常为： ==AuthenticationExecption==

+ AccountException  账号异常
     + ConcurrentAccessException  账户被占用
     + DisabledAccountException  不可用，用户过期，或禁用了，用户失效
          + LockedAccountException  账户被锁了
     + ExcessiveAttemptsException 超过尝试次数
     + UnknownAccountException 用户名不正确
+ CredentialsException 凭证异常
     + ExpiredCredentialsException 凭证过期异常
     + IncorrectCredentialsException 凭证不正确
+ UnsupportedTokenException    Token不支持

虽然  Shiro  为每一种异常都提供了准确的异常类，但是在编写代码过程中，应提示给用户的异常信息为模糊的，这样有助有安全。常见的处理方式为：

```java
try {
    // 6. 进行用户身份验证
    subject.login(token);
    // 7. 通过 subject 来判断用户是否通过验证
    if (subject.isAuthenticated()){
        // 7.1 用户登录成功
        System.out.println("用户登录成功");
    }
} catch (AccountException e){
    System.out.println("用户名或密码错误");
} catch (CredentialsException  e){
    System.out.println("凭证不正确");
}
```

7. 执行流程：

     1. 通过  Shiro 相关的 API ，创建 SecurityManager 及获取 Subject 实例

     2. 封装 token 信息

     3. 通过 subject.login(token)  进行用户认证

          1. Subject 接收 token，通过其实现类 DelegatingSubject  将 token 委托给 SecurityManager 来完成认证。SecurityManager 是通过 DefaultSecurityManager 来完成相关功能。由 DefaultSecurityManager 中 login 来完成认证过程，在 login 中调用了该类中的 authenticate（）来完成认证。该方法是由 AuthenticatingSecurityManager来完成的，在该类的 authenticate（）中，通过调用 authenticator（认证器）来完成认证工作。authenticator 是由默认实现类 MoularRealmAuthenticator 来完成认证。通过 ModularRealmAuthenticator 中的doAuthenticate来获取 Realms信息。如果是单 relam 直接将 token 和 relam 中的数据进行比较，判断是认证成功。如果是多 relam 那么需要通过 Authenticator Strategy 来完成对应认证工作。如果认证失败会抛出异常信息。

               <img src="images/DefaultSecurityManager%20%E7%9B%B8%E5%85%B3.png" alt="image-20200726220716705" style="zoom:80%;" />

               每继承一步，实现一个功能 

     4. 通过 subject.isAuthnticated（）来判断是否认证成功。

## 3、JDBCRelam 及 Authenticator Strategy

1. 使用 Shiro 框架来完成认证工作，默认情况下是使用 iniRelam 。如果需要使用其他 Relam，那么需要进行相关的配置

2. ini 配置文件讲解

     【main】section 是你配置应用程序的 SecurityManager 实例及任何它的依赖组件（如 Relams）的地方。

     ```ini
     [main]
     myRelam=cn.sxt.relam.MyRelam
     # 依赖注入
     securtyManager.realm=$myRelam
     ```

     【users】section 允许你定义一组静态的用户账号。在这一部分拥有少数用户账户活用户不需要在运行时被动态  ，创建的环境下很有用

     ```ini
     [users]
     Zhangsan=1111
     Lisi=222,role,role2
     ```

     【roles】section 运行你把定义在【users】中的角色与权限关联起来。另外，在这大部分拥有少数用户账号或用户账户不需要在运行时被动态创建的环境下很有用的。

     ```ini
     [users]
     Zhangsan=111,role2
     [roles]
     roles=user:add,user:delete
     ```

3. 使用 JdbcRelam 来完成身份认证

     ​		通过观察  JdbcRealm 可知，要实现 JdbcRealm：

     1. 需要为jdbc Relam 设置 DataSource
     2. 在指定的 DataSource 所对应的数据库中有用户表 users， 该表中有 username，password，password_salt 等字段

4. 实现步骤

     1. 新建数据库表

          ![image-20200727103022915](images/%E6%95%B0%E6%8D%AE%E5%BA%931.png)

     2. 编写Shiro 配置

          >  ==注意==   用的是 c3p0 的连接池
          >
          > 6.0 的mysql链接 要用 com.mysql.cj.jdbc.Driver，而且url后面跟 ?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
          >
          > 因为是 c3p0   链接的key 是 driverClass 、jdbcUrl 、user 、password

          ```ini
          [main]
          # 数据源
          dataSource=com.mchange.v2.c3p0.ComboPooledDataSource
          dataSource.driverClass=com.mysql.cj.jdbc.Driver
          dataSource.jdbcUrl=jdbc:mysql://localhost:3306/shiro?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
          dataSource.user=root
          dataSource.password=root
          jdbcRealm=org.apache.shiro.realm.jdbc.JdbcRealm
          #  $表示引用对象
          jdbcRealm.dataSource=$dataSource
          securityManager.realms=$jdbcRealm
          ```

     3. 编写测试

          ```java
          public class JdbcRealmDemo {
              public static void main(String[] args) {
                  Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
                  SecurityManager securityManager = factory.getInstance();
                  SecurityUtils.setSecurityManager(securityManager);
                  Subject subject = SecurityUtils.getSubject();
                  UsernamePasswordToken token = new UsernamePasswordToken("wangwu","1111");
                  try {
                      subject.login(token);
                      if (subject.isAuthenticated()){
                          System.out.println("验证通过");
                      }
                  } catch (AuthenticationException e){
                      System.out.println("验证失败");
                  }
              }
          }
          ```

     4. Authentication Strategy：认证策略，在Shiro中有 3 种认证策略

          1. AtLeastOneSuccessfulStrategy 如果一个或多个 Relam 验证成功，则整体会被认为是成功的
          2. FirstSuccessfulStrategy 只要有一个验证成功的 Realm 返回的信息将会被使用，所有进一步的 Realm 将会被忽略，如果没有一个验证成功，则整体尝试失败
          3. AllSuccessfulStrategy：为了整体的尝试成功，所有配置的Realm 必须验证成功。如果没有一个验证成功，则整体尝试失败

          默认的策略是  AtLeastOneSuccessfulStrategy 

     5. 设置认证策略

          ```ini
          #验证策略设置
          authenticationStrategy=org.apache.shiro.authc.pam.FirstSuccessfulStrategy
          securityManager.authenticator.authenticationStrategy=$authenticationStrategy
          ```

     

## 4、自定义 Realm 来实现身份认证

1. JdbcReam 已经实现了从数据库中获取用户的验证信息，但是 jdbcRealm 的灵活性太差。如果要实现自己的一些特殊应用时将不能支持，这个时候，可以通过自定义Realm来实现身份的认证功能

2. Realm 是一个接口，在接口中定义了根据 token 获得认证信息的方法，Shiro 内容实现了一系列的 realm，这些不通过 Realm 实现类提供了不同的功能。 AuthenticatingRealm 实现了获取身份验证的功能，AuthoizizngRealm，实现了获取权限信息的功能，通常自定义 Realm 需要继承 AuthorizingRealm ，这样可以提供了身份认证的方法，也可以实现授权的自定义方法

     ![image-20200727123555941](images/Realm%20%E8%BA%AB%E4%BB%BD%E8%AE%A4%E8%AF%81.png)

3. 自定义 Realm

     ```java
     /**
      * 自定义 realm的实现 该 realm 类提供了两个方法
      * doGetAuthenticationInfo  获取认证信息
      * doGetAuthorizationInfo 获取权限信息
      */
     public class UserRealm extends AuthorizingRealm {
     
         @Override
         public String getName() {
             return "userRealm";
         }
     
         /**
          *
          * @param authenticationToken 完成身份认(从数据库中取数据)证并且返回认证信息
          * @return org.apache.shiro.authc.AuthenticationInfo 获取认证信息
          *      如果身份认证失败，返回 null
          */
         @Override
         protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
             // 获取用户输入的用户名
             String username = (String) authenticationToken.getPrincipal();
             System.out.println("username ："+username);
             // 根据用户名到数据库查询信息 -- 模拟
             // 假定从数据获取的密码为 1111
             String pwd = "1111";
             // 从数据库中查询的信息封装到 SimpleAuthenticationInfo 中
             SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(username,pwd,getName());
             return info;
         }
         
         @Override
         protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
             return null;
         }
     
     }
     ```

     ==使用 Shiro 来完成权限管理，Shiro 并不会去维护数据，Shiro 中使用的数据需要程序员根据处理业务将数据传递给 Shiro 的相应接口==



## 5、散列算法（加密算法）

1. 在身份认证的过程中往往会涉及加密。如果不加密那么数据信息不安全。Shiro 内容实现比较多的散列算法。如：MD5、SHA、Base64。并且提供了加盐功能，比如 "1111" 的 MD5 码为：b59c67bf196a4758191e42f76670ceba ，这个md5 码可以在很多破解网站上找到对应的原密码。但是如果 ‘1111’+姓名  那么能找到原密码的难度会增加

2. 测试 MD5

     ```java
     public class Md5Demo {
         public static void main(String[] args) {
             // 1 使用md5 加密算法 加密
             Md5Hash md5 = new Md5Hash("1111");
             System.out.println("1111="+md5.toString());
             // 2 加盐
             md5 = new Md5Hash("1111","sxt");
             System.out.println("1111="+md5.toString());
             // 迭代次数
             md5 = new Md5Hash("1111","sxt",2);
             System.out.println("1111="+md5.toString());
         }
     }
     ```

3. 在自定义的 Realm 中使用 散列算法

     ```java
     SimpleHash hash = new SimpleHash("md5","1111","sxt",2);
     System.out.println("1111="+hash);
     ```

4. 自定义 Realm 的实现

     ```java
     public class UserRealm extends AuthorizingRealm {
     	@Override
         public String getName() {
             return "userRealm";
         }
         
         @Override
         protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
             String username = (String) authenticationToken.getPrincipal();
             System.out.println("username ："+username);
             String pwd = "e41cd85110c7533e3f93b729b25235c3";
             String salt = "sxt";
             SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(username,pwd, ByteSource.Util.bytes(salt),getName());
             return info;
         }
     	@Override
         protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
             return null;
         }
     }
     ```

     > 这里的pwd 和 salt 应该是放在数据库里的，跳过取出的环节  ` e41cd85110c7533e3f93b729b25235c3`  表示 两次 MD5 的 `1111`

     ```ini
     [main]
     credentialsMatcher=org.apache.shiro.authc.credential.HashedCredentialsMatcher
     credentialsMatcher.hashAlgorithmName=md5
     credentialsMatcher.hashIterations=2
     userRealm=com.sxt.realm.UserRealm
     userRealm.credentialsMatcher=$credentialsMatcher
     securityManager.realms=$userRealm
     ```

     > 前三句表示：这里面使用了 MD5 的算法，两次散列

     ```java
     public class JdbcRelmDemo {
         public static void main(String[] args) {
             Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
             SecurityManager securityManager = factory.getInstance();
             SecurityUtils.setSecurityManager(securityManager);
             Subject subject = SecurityUtils.getSubject();
             UsernamePasswordToken token = new UsernamePasswordToken("laoliu","1111");
             try {
                 subject.login(token);
                 if (subject.isAuthenticated()){
                     System.out.println("验证通过");
                 }
             } catch (AuthenticationException e){
                 System.out.println("验证失败");
             }
         }
     }
     ```

## 6、授权

1. 授权：给身份认证的人，授予他可以访问资源的权限

     ![image-20200727170733334](images/%E6%8E%88%E6%9D%83%E8%AE%A4%E8%AF%81.png)

### 6.1、权限粒度

​		分为粗粒度和细粒度。粗粒度：对 user 的 crud，通常对表的操作，细粒度，是对记录的操作，如：只允许查询 id 为 1的user工资，Shiro 一般管理的是粗粒度的权限，比如：菜单，按钮，url，一般细粒度的权限是通过业务来控制的。

​		角色：权限的集合

​		权限表示规则  资源：操作，实例。可以用通配符表示

​			如 user：add表示 user 有添加的权限 ，user：*  表示 user 具有所有操作的权限，user：delete：100，表示 user标识为100的记录有删除权限。

### 6.2、Shiro 的权限流程：

<img src="images/Shiro%E7%9A%84%E6%9D%83%E9%99%90%E6%B5%81%E7%A8%8B.png" alt="image-20200727171718444" style="zoom:80%;" />



### 6.3、编码实现：

1. shiro.ini 配置文件

     ```ini
     [users]
     zhangsan=1111,role1
     lisi=2222,role2
     [roles]
     role1=user:add,user:update,user:delete
     role2=user:*
     ```

2. 测试

     ```java
     public class AuthorizationDemo {
         public static void main(String[] args) {
             Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
             SecurityManager securityManager = factory.getInstance();
             SecurityUtils.setSecurityManager(securityManager);
             Subject subject = SecurityUtils.getSubject();
             UsernamePasswordToken token = new UsernamePasswordToken("zhangsan", "1111");
             try {
                 // 认证
                 subject.login(token);
             } catch (AuthenticationException e){
                 System.out.println("认证不通过");
             }
             // 基于角色的授权
             boolean flag = subject.hasRole("role1");
             System.out.println(flag?"授权成功":"授权失败");
             // 判断是否具有多个角色
             boolean[] booleans = subject.hasRoles(Arrays.asList("role1","role2"));
             int i=0;
             for (boolean aBoolean : booleans) {
                 i++;
                 System.out.println("第"+i+"个为："+aBoolean);
             }
             // 可以通过 checkRole 来检测是否具有某个角色，如果不具有该角色则抛出 AuthorizerException
     //        subject.checkRole("role2");
     //        subject.checkRoles("role1","role2");
     
             // 基于资源的授权
             flag = subject.isPermitted("user:delete");
             System.out.println(flag);
             // 判断是否多个权限
             boolean flag1 = subject.isPermittedAll("user:add", "user:update", "user:delete");
             System.out.println(flag1?"拥有 user:add  user:update user:delete权限":"没有权限");
             // 通过 checkPermission  检测认证用户是否具有某个权限，如果没有则抛出异常 UnauthorizedException
             subject.checkPermission("user:add");
         }
     }
     ```

### 6.4、Shiro 中的权限检查方式有 3 种

1. 编程式

     ```java
     if(subject,hasRole("管理员")){
     	// 操作某个资源
     }
     ```

2. 注解式，在执行指定的方式是  会检测是否具有该权限

     ```java
     @RequiresRoles("管理员")
     public void list(){
         // 查询数据
     }
     ```

3. 标签

     ```jsp
     <%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
     <body>
         <shiro:hasPermission name="user:update">
         	<a href="#">更新</a>
         </shiro:hasPermission>
     </body>
     ```

### 6.5、授权流程：

1. 获取 subject 主体
2. 判断主体是否通过认证
3. 调用 subject.isPermitted*/hasRole 来进行权限的判断
     1. Subject 是由其实现类 DelegationSubject  来调用方法的，该类将处理交给了 SecurityManager 
     2. SecurityManager 是由其实现类 DefaultSecurityManager 来进行处理的，该类的 isPermitted 来处理，其本质 父类 AuthorizingSercurityManager 来进行处理，该类将处理交给了 authorizer（授权器）
     3. authorizer 由其实现类 ModularRealmAuthorizer来处理，该类可以调用对应的 Realm 来获取数据，在该类有 PermissionResolver 对权限字符串进行解析，在对应的 Realm 中也有对应的  PermissionResolver 交给  WildcardPermissionResolver 该类调用 wildcardPermission

## 7、自定义 Relam 实现授权

1. 仅仅通过配置文件来指定权限不够灵活，并且不方便。在实际的应用中大多数情况下都是将用户信息，角色信息，权限信息保存到数据库中。所有需要从数据库中获取相关的数据信息。可以使用 Shiro 提供的 JdbcRealm 来实现，也可以自定义 realm 来实现，使用 jdbcRealm 往往也不够灵活，所以在实际应用大多数情况下都是自定义 realm 来实现。

2. 自定义 Realm 需要继承 AuthorizingRealm 代码如下：

     > doGetAuthenticationInfo（上面的）  是认证，doGetAuthorizationInfo 才是授权，必须先认证成功后，才能授权。要是实现授权，二者必须实现

     ```java
     public class UserRealm extends AuthorizingRealm {
     
         @Override
         public String getName() {
             return "userRealm";
         }
     
         @Override
         protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
             String username = (String) authenticationToken.getPrincipal();
             System.out.println("username ："+username);
             String pwd = "1111";
             SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(username,pwd,getName());
             return info;
         }
         @Override
         protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
             String username = principalCollection.toString();
             System.out.println("授权 《《《");
             System.out.println("username：\t\t"+username);
             // 根据用户名到数据查询该用户对应的权限信息 -- 模拟
             List<String> permission = new ArrayList<>();
             permission.add("user:add");
             permission.add("user:delete");
             permission.add("user:update");
             permission.add("user:find");
             SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
             for (String perms : permission) {
                 info.addStringPermission(perms);
             }
             return info;
         }
     
     }
     ```

     shiro 配置

     > 这里不需要写 roles 上面的 Permission 已经添加进去了

     ```ini
     [main]
     userRealm=com.sxt.realm.UserRealm
     securityManager.realm=$userRealm
     [users]
     zhangsan=1111
     ```

     测试类

     ```java
     public class JdbcRelmDemo {
         public static void main(String[] args) {
             Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
             SecurityManager securityManager = factory.getInstance();
             SecurityUtils.setSecurityManager(securityManager);
             Subject subject = SecurityUtils.getSubject();
             UsernamePasswordToken token = new UsernamePasswordToken("zhangsan","1111");
             try {
                 subject.login(token);
                 if (subject.isAuthenticated()){
                     System.out.println("验证通过");
                 }
             } catch (AuthenticationException e){
                 System.out.println("验证失败");
             }
             System.out.println(subject.isPermittedAll("user:add","user:delete"));
         }
     }
     ```

### 7.1、实现JdbcRealm和自定义Realm的结合

```java
public class UserRealm extends AuthorizingRealm {

    @Override
    public String getName() {
        return "userRealm";
    }
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        return null;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        String username = principalCollection.toString();
        System.out.println("授权 《《《");
        System.out.println("username：\t\t"+username);
        List<String> permission = new ArrayList<>();
        permission.add("user:add");
        permission.add("user:delete");
        permission.add("user:update");
        permission.add("user:find");
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        for (String perms : permission) {
            info.addStringPermission(perms);
        }
        return info;
    }

}
```

shiro.ini 配置

> 第12行的位置，  一定是 userRealm 授权在前，然后再是验证。 否则通过验证后，则不再进入授权

```ini
[main]
dataSource=com.mchange.v2.c3p0.ComboPooledDataSource
dataSource.driverClass=com.mysql.cj.jdbc.Driver
dataSource.jdbcUrl=jdbc:mysql://localhost:3306/shiro?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
dataSource.user=root
dataSource.password=root
jdbcRealm=org.apache.shiro.realm.jdbc.JdbcRealm
jdbcRealm.dataSource=$dataSource
userRealm=com.sxt.realm.UserRealm
authenticationStrategy=org.apache.shiro.authc.pam.AtLeastOneSuccessfulStrategy
securityManager.authenticator.authenticationStrategy=$authenticationStrategy
securityManager.realms=$userRealm,$jdbcRealm
# 在 realm 中给定了用户信息，该用户可以不用配置
# [users]
# zhangsan=1111
```

测试

```java
public class JdbcRelmDemo {
    public static void main(String[] args) {
        Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");
        SecurityManager securityManager = factory.getInstance();
        SecurityUtils.setSecurityManager(securityManager);
        Subject subject = SecurityUtils.getSubject();
        UsernamePasswordToken token = new UsernamePasswordToken("wangwu","2222");
        try {
            subject.login(token);
            if (subject.isAuthenticated()){
                System.out.println("验证通过");
            }
        } catch (AuthenticationException e){
            System.out.println("验证失败");
        }
        System.out.println(subject.isPermittedAll("user:add","user:deete"));
    }
}
```

