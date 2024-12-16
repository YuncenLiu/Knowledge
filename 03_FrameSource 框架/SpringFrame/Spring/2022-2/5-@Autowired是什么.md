## @Autowired是什么

@AutoWried 表示某个属性是否需要进行依赖注入，可以写在某个属性和方法上。注解中的required 属性默认为 ture、表示如果没有底下可以注入给属性抛异常

```java
@Service
public class OrderService{
  @Autowired
  private UserService userService;
}
```

@Autowrited 加在某个属性上，Spring在进行Bean实例化周期中，在属性填充这一步，会基于实例化出的对象，对该类对象中加入了 @Autowrited 的属性自动给属性赋值

先 by-type 后 by-name，先根据类型找到出多个，在根据属性的名字再确定一个，如果required为true，并且根据属性信息找不到对象，则直接抛出异常





```java
@Service
public class OrderService{
  private UserService userService;
  
  @Autowried
  public void setUserService(UserService userService){
    this.userService = userService;
  }
}
```

当 @Autowried 注解写在某个方法上时，Spring在Bean生命周期的属性填充阶段，会根据方法的参数类型、参数名字从Spring容器找到对象当做方法入参，自动反射调用该方法。

@AutoWired加在构造方法上时，Spring会在推断构造方法阶段，选择该构造方法来进行实例化，在反射调用构造方法之前，会先根据构造方法参数类型、参数名从Spring容器中找到Bean对象，当做构造方法入参
