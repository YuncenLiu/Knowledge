配置在 web.xml 中

```xml
 <!--
      方式一：带后缀，比如*.action  *.do *.aaa
             该种方式比较精确、方便，在以前和现在企业中都有很大的使用比例
      方式二：/ 不会拦截 .jsp，但是会拦截.html等静态资源（静态资源：除了servlet和jsp之外的js、css、png等）

            为什么配置为/ 会拦截静态资源？？？
                因为tomcat容器中有一个web.xml（父），你的项目中也有一个web.xml（子），是一个继承关系
                      父web.xml中有一个DefaultServlet,  url-pattern 是一个 /
                      此时我们自己的web.xml中也配置了一个 / ,覆写了父web.xml的配置
            为什么不拦截.jsp呢？
                因为父web.xml中有一个JspServlet，这个servlet拦截.jsp文件，而我们并没有覆写这个配置，
                所以springmvc此时不拦截jsp，jsp的处理交给了tomcat


            如何解决/拦截静态资源这件事？


      方式三：/* 拦截所有，包括.jsp
    -->
    <!--拦截匹配规则的url请求，进入springmvc框架处理-->
    <url-pattern>/</url-pattern>
```

