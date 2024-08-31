> 创建于2022年2月7日
> 作者：想想

[toc]

# 什么是 BeanDefinition

BeanDefinition 表示 Bean 定义，Spring根据 BeanDefinition 来创建 Bean 对象，BeanDefinition 有很多属性用来描述 Bean，BeanDefinition 是Spring非常重要的概念

+ beanClass
+ scope
+ isLazy
+ dependsOn
+ primary
+ initMethodName

### beanClass

​	表示一个bean的类型，比如：UserService.class、OrderService.class，Spring在创建Bean的过程中会根据此属性来实例化得到对象

### scope

​	表示一个bean的作用域，比如scope等于singleton，表示单利，scope等于prototype，就表示原型bean

### isLazy

​	表示一个bean是不是需要懒加载，原型bean在isLazy属性不起作用，懒加载的单利bean，会在第一次getBean的时候生成该bean，非懒加载的单利bean，则会在Spring启动过程中直接生成好。

### dependsOn

​	表示一个bean在创建之前所依赖的其他bean，在一个bean创建之前，它所依赖的这些bean得到全部建好的

### primary

​	表示一个bean是主bean，在Spring中一个类型可以有多个bean对象，在进行依赖注入时，如果根据类型找到多个bean，此时会判断这些bean中是否存在一个主bean，如果存在则直接将这个bean注入给属性

### initMethodName

​	表示一个bean的初始化方法，一个bean的生命周期过程中有一个步骤叫初始化，Spring会在这个步骤调用bean的初始化方法，初始化逻辑由程序员自己控制，表示程序员可以自定义逻辑对bean进行加工。



平常用的 `@Component`、`@Bean`、`<bean/>`都会解析为 BeanDefinition对象