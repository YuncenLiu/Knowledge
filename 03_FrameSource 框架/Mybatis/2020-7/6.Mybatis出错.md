## 1、找不到 Mapper.xml 文件

```
Exception in thread "main" org.apache.ibatis.exceptions.PersistenceException: 
### Error building SqlSession.
### The error may exist in src/main/java/com/xiang/mapper/BillMapper.xml
### Cause: org.apache.ibatis.builder.BuilderException: Error parsing SQL Mapper Configuration. Cause: java.io.IOException: Could not find resource src/main/java/com/xiang/mapper/BillMapper.xml
	at org.apache.ibatis.exceptions.ExceptionFactory.wrapException(ExceptionFactory.java:30)
	at org.apache.ibatis.session.SqlSessionFactoryBuilder.build(SqlSessionFactoryBuilder.java:80)
	at org.apache.ibatis.session.SqlSessionFactoryBuilder.build(SqlSessionFactoryBuilder.java:64)
	at com.xiang.test.Test.main(Test.java:23)
```

​		在构建项目时候，使用了 maven 构建项目。这时，会有 resources 静态资源文件夹，此时Mybatis.xml 会放在里面，如果不把 Mapper文件也存放在这里面，就会报这样的错。   

### 1.1、解决办法：

 在resources 包下，建同级项目路径，并把xxxMapper.xml 放进去

<img src="images/%E9%97%AE%E9%A2%981.png" alt="image-20200724123153166" style="zoom:50%;" />

### 1.2、解决办法2：

更改 maven 项目结构，把所有项目资源全部放在   源码 根 路径下。这样也可以找到 ，但是要注意，如果有了 resources 静态资源标记，则这个方法不能使用

<img src="images/%E9%97%AE%E9%A2%982.png" alt="image-20200724123228871" style="zoom:50%;" />

### 1.3、合并

如果要使用 interface 方式，在有 resources 源码 根标记的情况下，必须使用 解决办法 1，反之直接在mapper 包下即可



## 2、找不到方法

```
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.ibatis.reflection.Reflector (file:/D:/Program%20Files/repository/org/mybatis/mybatis/3.2.7/mybatis-3.2.7.jar) to method java.lang.Class.checkPackageAccess(java.lang.SecurityManager,java.lang.ClassLoader,boolean)
WARNING: Please consider reporting this to the maintainers of org.apache.ibatis.reflection.Reflector
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
Exception in thread "main" org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database.  Cause: java.lang.IllegalArgumentException: Mapped Statements collection does not contain value for com.xiang.mapper.BillMapper.selAll
### Cause: java.lang.IllegalArgumentException: Mapped Statements collection does not contain value for com.xiang.mapper.BillMapper.selAll
```

​		使用了   package 扫描，但是没有写 interface 接口方法，加上接口方法即可，或者不用 package 使用  mapper 标签 + resource 属性