## @Resource 是什么

@Resource 注解与 @AutoWired类似，也是用来进行依赖注入的，@Resource 是Java层面提供的注解，@Autowried 是Spring提供的注解，他们依赖注入的底层实现逻辑也不同



@Resource 注解中有一个name属性，针对 name 属性是否有值，@Resouce 的依赖注入底层流程是不同的。如果name属性有值，那么Spring会直接根据指定的name值去Spring容器找Bean对象，如果找到了则成功，如果没找到，则报错。如果name属性没有值，则

1. 先判断该属性名在 Spring 容器中是否存在Bean对象
	1. 如果存在：则成功找到Bean对象进入注入
	2. 如果没有，则根据属性类型去Spring容器找Bean对象，找到一个则进行注入



总结：先 by-name 再 by-type



