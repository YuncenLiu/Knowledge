## @Value 是什么

@Value 注解和 @Resource、@Autowired类似，也是用来对属性进行依赖注入的， 只是不过@Value是用来从 Properties 文件中来获取值的，并且 @Value 可以解析 SpEL（Spring表达式）

```
@Value("zhouyu")
```

直接将字符串“zhouyu”赋值给属性，如果属性类型不是String，或者无法进行类型转换，则报错



```java
@Value("${zhouyu}")
```

将会把`${}` ,中的字符串当做 key，从 Properties 文件中找出对应的value赋值给属性，如果没找到，则会把 `${zhouyu}` 当做普通字符串注入给属性



```java
@Value("#{zhouyu}")
```

会讲`#{}` 中的字符串当做Spring表达式进行解析，Spring会把”zhouyu“ 当做 beanName，并从 Spring容器中找到对应Bean，如果找到则进行属性注入，没找到则报错