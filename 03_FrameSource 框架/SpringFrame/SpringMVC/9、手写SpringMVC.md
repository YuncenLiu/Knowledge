## 手写 SpringMVC

### 1、注解

写一个注解包

+ Autowired
+ Controller
+ RequestMapping
+ Service

Autowired、Controller、Service 都是Spring底层源码的东西

自动扫描、生成bean、依赖注入这些。具体实现后面再说

### 2、DispatcherServlet 继承 HttpServlet

核心：Handler 对象

```java
public class Handler {

    private Object controller; 
  // method.invoke(obj,)

    private Method method;

    private Pattern pattern; 
  // spring中url是支持正则的

    private Map<String,Integer> paramIndexMapping; 
  // 参数顺序,是为了进行参数绑定，key是参数名，value代表是第几个参数 <name,2>
}
```

通过 Spring 扫描 Controller 