## BeanPostProcess

​	BeanPostProcess 是Spring所提供的扩展机制，可以利用该机制对Bean进行定制化加工，在Spring底层源码中实现，也广泛的用到了该机制，BeanPostProcessor通常也叫作Bean后置处理器

​		BeanPostProcess在Spring中是一个接口，我们定义了后置处理器，就是提供了一个类实现该接口，在Spring中还存在一些接口继承了 BeanPostProcessor，这些子接口是在 BeanPostProcess 的基础上增加了一些其他功能



​		一些方法：

+ postProcessBeforeInitialization()：初始化前方法，表示可以利用这个方法对Bean在初始化前进行自定义加工。
+ postProcessAfterInitalization()：初始化后方法，表示可以利用这个方法对Bean在初始化后进行自定义加工



​		InstantiationAwareBeanPostProcessor是BeanPostProcess 的一个子接口，其中有三个方法：

+ postProcessBeforeInstantiation()：实例化前
+ postProcessAfterInstantiation()：实例化后
+ postProcessProperties()：属性注入后