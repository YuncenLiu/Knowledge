

### Tomcat 配置文件详解

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
   Server 根元素，创建⼀个Server实例，⼦标签有 Listener、GlobalNamingResources、Service
   这个 port 是监听关闭端口
-->
<Server port="8005" shutdown="SHUTDOWN">
    <!--
        定义监听器 做初始化工作!
    -->
    <!-- 以⽇志形式输出服务器 、操作系统、JVM的版本信息 -->
    <Listener className="org.apache.catalina.startup.VersionLoggerListener"/>
    <!-- 加载（服务器启动） 和 销毁 （服务器停⽌） APR。 如果找不到APR库， 则会输出⽇志， 并不影响 Tomcat启动 -->
    <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on"/>
    <!-- 避免JRE内存泄漏问题 -->
    <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"/>
    <!-- 加载（服务器启动） 和 销毁（服务器停⽌） 全局命名服务 -->
    <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>
    <!-- 在Context停⽌时重建 Executor 池中的线程， 以避免ThreadLocal 相关的内存泄漏 -->
    <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

    <!-- 定义服务器的全局JNDI资源 -->
    <GlobalNamingResources>
        <Resource name="UserDatabase" auth="Container"
                  type="org.apache.catalina.UserDatabase"
                  description="User database that can be updated and saved"
                  factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
                  pathname="conf/tomcat-users.xml"/>
    </GlobalNamingResources>

    <!--
           该标签⽤于创建 Service 实例，默认使⽤ org.apache.catalina.core.StandardService。
           默认情况下，Tomcat 仅指定了Service 的名称， 值为 "Catalina"。
           Service ⼦标签为 ： Listener、Executor、Connector、Engine，
           其中：
               Listener ⽤于为Service添加⽣命周期监听器，
               Executor ⽤于配置 Service 共享线程池
                    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-" maxThreads="150" minSpareThreads="4"/>

               Connector ⽤于配置 Service 包含的链接器，
               Engine ⽤于配置Service中链接器对应的Servlet 容器引擎
     -->
    <Service name="Catalina">

        <!--
            默认情况下，Service 并未添加共享线程池配置。 如果我们想添加⼀个线程池， 可以在<Service> 下添加如下配置：

            name：线程池名称，⽤于 Connector中指定
            namePrefix：所创建的每个线程的名称前缀，⼀个单独的线程名称为 namePrefix+threadNumber
            maxThreads：池中最⼤线程数
            minSpareThreads：活跃线程数，也就是核⼼池线程数，这些线程不会被销毁，会⼀直存在
            maxIdleTime：线程空闲时间，超过该时间后，空闲线程会被销毁，默认值为6000（1分钟），单位毫秒
            maxQueueSize：在被执⾏前最⼤线程排队数⽬，默认为Int的最⼤值，也就是⼴义的⽆限。除⾮特殊情况，这个值 不需要更改，否则会有请求不会被处理的情况发⽣
            prestartminSpareThreads：启动线程池时是否启动 minSpareThreads部分线程。默认值为false，即不启动
            threadPriority：线程池中线程优先级，默认值为5，值从1到10
            className：线程池实现类，未指定情况下，默认实现类为org.apache.catalina.core.StandardThreadExecutor。如果想使⽤⾃定义线程池⾸先需要实现org.apache.catalina.Executor接⼝
        -->
        <Executor name="commonThreadPool"
                  namePrefix="thread-exec-"
                  maxThreads="200"
                  minSpareThreads="100"
                  maxIdleTime="60000"
                  maxQueueSize="Integer.MAX_VALUE"
                  prestartminSpareThreads="false"
                  threadPriority="5"
                  className="org.apache.catalina.core.StandardThreadExecutor"/>


        <!--
            port：端⼝号，Connector ⽤于创建服务端Socket 并进⾏监听， 以等待客户端请求链接。如果该属性设置为0， Tomcat将会随机选择⼀个可⽤的端⼝号给当前Connector 使⽤
            protocol：当前Connector ⽀持的访问协议。 默认为 HTTP/1.1 ， 并采⽤⾃动切换机制选择⼀个基于 JAVA NIO 的链接器或者基于本地APR的链接器（根据本地是否含有Tomcat的本地库判定）
            connectionTimeOut: Connector 接收链接后的等待超时时间， 单位为 毫秒。 -1 表示不超时。
            redirectPort：当前Connector 不⽀持SSL请求， 接收到了⼀个请求， 并且也符合security-constraint 约束，需要SSL传输，Catalina⾃动将请求重定向到指定的端⼝。
            executor：指定共享线程池的名称， 也可以通过maxThreads、minSpareThreads 等属性配置内部线程池。
            URIEncoding:⽤于指定编码URI的字符编码， Tomcat8.x版本默认的编码为 UTF-8 , Tomcat7.x版本默认为ISO-8859-1

            compression: 是否要压缩，
            compressionMinSize: 超过这个值是否压缩
            disableUploadTimeout: 是否放宽上传时间
        -->

        <!--    <Connector port="8080" protocol="HTTP/1.1"
                       connectionTimeout="20000"
                       redirectPort="8443" />   -->

        <Connector port="8080"
                   protocol="HTTP/1.1"
                   executor="commonThreadPool"
                   maxThreads="1000"
                   minSpareThreads="100"
                   acceptCount="1000"
                   maxConnections="1000"
                   connectionTimeout="20000"
                   compression="on"
                   compressionMinSize="2048"
                   disableUploadTimeout="true"
                   redirectPort="8443"
                   URIEncoding="UTF-8"/>

        <Connector port="8009" protocol="AJP/1.3" redirectPort="8443"/>


        <!--
            name： ⽤于指定Engine 的名称， 默认为Catalina
            defaultHost：默认使⽤的虚拟主机名称， 当客户端请求指向的主机⽆效时， 将交由默认的虚拟主机处理， 默认为localhost
        -->
        <Engine name="Catalina" defaultHost="localhost">
            <Realm className="org.apache.catalina.realm.LockOutRealm">
                <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
                       resourceName="UserDatabase"/>
            </Realm>

            <!--  autoDeploy: 热部署 -->
            <Host name="localhost" appBase="webapps"
                  unpackWARs="true" autoDeploy="true">


                <!--
                 docBase：Web应⽤⽬录或者War包的部署路径。可以是绝对路径，也可以是相对于 Host appBase的
                相对路径。
                 path：Web应⽤的Context 路径。如果我们Host名为localhost， 则该web应⽤访问的根路径为：
                 http://localhost:8080/web_demo。
                -->
                <Context docBase="/Users/xiang/.../target/xiang-spring-boot-build-2.2.9.RELEASE.war" path="/spring"></Context>

                <!-- 这不是 value 是阀门  -->
                <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
                       prefix="localhost_access_log" suffix=".txt"
                       pattern="%h %l %u %t &quot;%r&quot; %s %b"/>
            </Host>
        </Engine>
    </Service>
</Server>

```

