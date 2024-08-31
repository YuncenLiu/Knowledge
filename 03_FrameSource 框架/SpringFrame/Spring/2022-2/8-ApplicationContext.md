## ApplicationContext

​		ApplicationContext 是比 BeanFactory 更加强大的 Spring 容器，它既可以创建 bean、获取 bean，还可以支持国际化、事件广播、获取资源等 BeanFactory 不具备的功能

​	

​		ApplicationContext 所继承的接口

+ EnvironmentCapable
  + ApplicationContext 继承了这个接口，表示拥有了获取环境变量的功能，可以通过 ApplicationContext 获取操作系统环境变量 JVM 环境变量
+ ListableBeanFactory
  + 拥有了获取所有 beanNames、判断某个 beanNamse是否存在 BeanDefinition对象，统计 BeanDefinition 个数，获取某个类型对应的所有 beanNames等功能
+ HierarchicalBeanFactory
  + 继承后，就用了获取 BeanFactory、判断某个 name 是否存在 bean对象的功能
+ MessageSource
  + 继承后，就用来国际化功能，比如可以直接利用 MessageSource 对象获取某个国际化资源（比如不同国家语言所对应的字符）
+ ApplicationEventPublisher
  + 继承后，就拥有了事件发布功能，可以发布事件就是ApplicationContext相对于 BeanFactory 比较突出、常用的功能
+ ResourcePatternResolver
  + 继承后，就拥有了并加载了获取资源的功能，这里的资源可以是文件，图片等某个URL资源都可以。

