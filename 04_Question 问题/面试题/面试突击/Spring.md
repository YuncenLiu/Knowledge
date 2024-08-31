[toc]

# Spring

## 核心

Spring 两大核心 IOC、AOP

IOC 作用削减程序的耦合 ，ApplicationContext 有三个实现类，ClassPathXmlApplicationContext 类路径下加载，FileSystemXmlApplicationContext 加载任意磁盘，这个有可能会没权限，AnnotaiionApplicationContext 读取注解创建容器的。  单利对象建议使用 ApplicationContext 多利的话建议使用 BeanFactory

创建Bean

1 使用默认构造函数，2、使用普通工厂中的方法创建对象，3、第三种工厂静态方法创建对象

Bean 的作用范围

singleton 单利、prototype 多利、request 作用于 web 请求 范围、session 作用于 web 会话范围、global-session 集群环境，全局回话范围，如果不是集群就是 session

Bean 的生命周期

单利：创建容器出生、只要容器在，就活着，容器销毁，对象销毁。和容器不同生，但共死

多利：用到他的时候，spring框架帮我们创建，只要在用，就一直活着。最后由GC回收



依赖注入（Dependecy Injection）

IOC 的作用，以后就把这个对象交给 spring 来管理，注入的方法分为   构造函数、set方法，注解方式注入



AOP 的一些相关术语： JoinPoint 连接点、PointCut 切入点、Advice 增强/通知



### Spring 声明式事务

isolation：事务的隔离级别 默认送 Default 表示数据库默认的隔离级别

propagation：用于指定事务传播行为，默认送 required 表示一定会有事务，增删改可以用这个 查询方法用 supports

read-only 指定事务是否只读，默认 false ，查询方法可以设置为 true 

timeout 超时时间，默认-1 不超时，如果指定了就以秒为单位

 rollback-for：用于指定一个异常，当产生该异常时，事务回滚，产生其他异常时，事务不回滚。没有默认值。表示任何异常都回滚。
 no-rollback-for：用于指定一个异常，当产生该异常时，事务不回滚，产生其他异常时事务回滚。没有默认值。表示任何异常都回滚。