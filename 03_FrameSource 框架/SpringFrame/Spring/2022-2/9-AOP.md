## AOP是什么

​		AOP就是面向切面编程，是一种非常适合在无需修改业务代码的前提下，对某个或某些事务增加统一的功能，比如日志记录、权限控制、事务管理等，能很好的是的代码解耦，提高开发效率

​		核心概念：

+ Advice
  + 理解为通知建议，在Spring中通过定义 Advice 来定义代理逻辑
+ Pointcut
  + 切点，表示Advice对应的代理逻辑应用在那个类，哪个方法上
+ Advisor
  + 等于 Advice+Pointcut，表示代理逻辑和切点的一个整体，程序员可以通过定义或封装一个 Advisor，来定义切点和代理逻辑
+ Weaving
  + 表示织入，将 Advice代理逻辑在源代码级别嵌入到切点的过程，就叫做织入
+ Target
  + 表示目标对象，被代理对象，在AOP生成的代理对象中会持有目标对象
+ Join Point
  + 在Spring AOP 中，就是方法的执行点



### AOP工作原理

AOP是发生在Bean的生命周期过程中

1. Spring生成bean对象，先实例化出现一个对象，也就是target对象
2. 再对target对象进行属性填充
3. 在初始化后步骤中，会判断target对象有没有对应的切面
4. 如果有切面，就表示当前target对象需要AOP
5. 通过Cglib或JDK动态代理机制生成一个代理对象，作为最终的bean对象
6. 代理对象中有个target属性指向了target对象