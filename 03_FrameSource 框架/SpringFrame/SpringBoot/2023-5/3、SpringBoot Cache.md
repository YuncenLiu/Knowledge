## SpringBoot Cache 缓存

大家好，我是想想。

最近在复习 SpringBoot 相关源码。发现了很多以前的问题，可以有更为优雅的解决办法。

就像 Cache 缓存一样，是不是很多人都觉得。集成 Mybatis ，只有 Mybatis 的二级缓存可以操作呢？或者就接入 Redis 这类的缓存数据库。

其实 SpringBoot 的 SimpleCache 也是一种基于内存的缓存技术，适用于对少量数据进行缓存处理

1. 对频繁查询的数据进行缓冲
2. 对计算代价较大的数据进行缓冲
3. 记录用户访问次数对接口进行限流的流量控制
4. 记录表单提交状态，防止重复提交。

在我没有足够了解 SpringBoot Cache 之前，我可能就自己封装一个 Map 然后做缓存。

但是我发现 SpringBoot Cache 支持这么多缓存

![image-20230517101207997](images/3%E3%80%81SpringBoot%20Cache/image-20230517101207997.png)

当我们没有引入 JCache、Redis 这类依赖时，SpringBoot 默认使用 SimpleCache 作为缓存，其底层使用 ConcurrentMap 作为容器存储缓存内容，而且有完善的API

![image-20230517101406270](images/3%E3%80%81SpringBoot%20Cache/image-20230517101406270.png)

所以呀~

道行还不够，还得学~



## 进入正文

先简单的用 SpringBoot 初始化创建个 SSM 项目，实现一张表 CRUD。这个就不重点说了。

SpringBoot 启动类添加 `@EnableCaching` 注解，开启缓存

通过断点拦截 SpringBoot 自动配置类可以找到 `org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration` （这一步是 Spring自动配置类的相关技术，如果不清楚怎么找的，可以翻阅 “Spring自动配置类” 相关资料 or 找我）

![image-20230517102820235](images/3%E3%80%81SpringBoot%20Cache/image-20230517102820235.png)

我们发现 `CacheAutoConfiguration` 引入了  `CacheConfigurationImportSelector.class`

![image-20230517103026729](images/3%E3%80%81SpringBoot%20Cache/image-20230517103026729.png)

`CacheConfigurationImportSelector` 是  `CacheAutoConfiguration` 中第一个内部类，它实现了 `ImportSelector` 重写了 `selectImports` 方法，那就是要重新的自动配置一下

我们就可以找到文章开头的那张图，在不引入其他 cache 的情况下，默认采用 SimpleCache 的放松

![image-20230517103301375](images/3%E3%80%81SpringBoot%20Cache/image-20230517103301375.png)

`SimpleCacheConfiguration`  里面只有一个 @Bean 注解，就是返回一个 `ConcurrentMapCacheManager`  而 `ConcurrentMapCacheManager` 里面就有我们之前看到的  

```java
private final ConcurrentMap<String, Cache> cacheMap = new ConcurrentHashMap<>(16);
```

还有一个最重要的方法， `Cache getCache（String name)` ，值得一提的是 `ConcurrentMapCacheManager` 并不是 SpringBoot 中的源码，而是 Spring-context 中的。

![image-20230517105001986](images/3%E3%80%81SpringBoot%20Cache/image-20230517105001986.png)

简单看一下，就是先到 cacheMap (ConcurrentMap) 中获取一下。没获取到就进入业务逻辑进行查询

![image-20230517104138209](images/3%E3%80%81SpringBoot%20Cache/image-20230517104138209.png)



文字描述一下运行流程

1. 方法运行之前，先去查询 Cache 缓存组件，安装 CacheName 指定的名字获取，第一次获取缓存没有 Cache 组件时，就去创建 `createConcurrentMapCache（name）`。
2. 去 Cache 中查找缓存内容，使用 key 默认就是方法参数，如果是多个参数，总是会根据一种策略生成一种 key
3. 没有查到缓存就调用目标方法
4. 然后将目标方法结果放入缓存中



**一句话总结： @Cacheable 标注的方法执行前会查询换成中是否有这个数据，默认按照参数作为key进行查询，如果没有调用目标方法将结果放入缓存，以后在调用时，直接使用缓存中数据。**



除了 @Cacheable 注解之外呢，还有其他两种常用注解

#### @CachePut（Update）

即调用方法，又更新缓存，一般用于更新操作。

运行流程：

1. 先调用目标方法
2. 将目标方法结果缓存起来

![image-20230517134243568](images/3%E3%80%81SpringBoot%20Cache/image-20230517134243568.png)





#### @CacheEvict（Delete）

清除缓存，需要指定名字和key

属性：

+ value / cacheNames 缓存名字
+ key 缓存键
+ allEntrles 是否清除这个缓存 value 中的所有 key，如果为 true 则清除所有 key（与 key 属性二选一）
+ beforelnvocation  默认 false，执行方法后再清除缓存，如果设置为 true 则执行目标方法前清除缓存 作用：可能目标方法存在异常 实际数据清除了，但因为别的事务导致异常，方法执行失败，缓存就没有删除，（数据库已删除，缓存未删除）

![image-20230517134718665](images/3%E3%80%81SpringBoot%20Cache/image-20230517134718665.png)



### 基于 Redis 的缓存

第一步启动一个 Redis 然后项目中添加 redis 依赖

![image-20230517140942268](images/3%E3%80%81SpringBoot%20Cache/image-20230517140942268.png)

```xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-redis</artifactId>
		</dependency>
```

通过断点老办法，我们可以找到 `RedisAutoConfiguration`

![image-20230517141034799](images/3%E3%80%81SpringBoot%20Cache/image-20230517141034799.png)

熟悉的感觉来了，一个 `redisTemplate`  还有一个 `stringRedisTemplate` 其实  `stringRedisTemplate` 就是继承了 `redisTemplate`

![image-20230517141123440](images/3%E3%80%81SpringBoot%20Cache/image-20230517141123440.png)

简单的介绍了一下 SpringBoot 自动配置 Redis 相关的源码之后，迅速的写一个例子吧

![image-20230517142752109](images/3%E3%80%81SpringBoot%20Cache/image-20230517142752109.png)

![image-20230517142835934](images/3%E3%80%81SpringBoot%20Cache/image-20230517142835934.png)

缓存顺利的加载到 Redis 中了

没有 Redis 之前使用的 SimpleCache ，使用了 仅仅是因为加入了 Reids 的依赖，缓存就顺利的写到了 Redis 里，这是因为 SpringBoot 自动配置顺序有关:

![image-20230517143033032](images/3%E3%80%81SpringBoot%20Cache/image-20230517143033032.png)

我们可以看到 `RedisCacheConfiguration` 高于 `SimpleCacheConfiguration` 的

难道是 SpringBoot 一个一个扫描，发现一个之后就 continue 吗？当然不是了，SpringBoot 就玩的很优雅

我们打开原先的 `SimpleCacheConfiguration` 

可以看到注解上有这样一段代码

```java
@ConditionalOnMissingBean(CacheManager.class)
```

**`@Conditional` 的意思是如果存在或者 （类、注解...） 的情况下，就加载此配置类，这样是 SpringBoot 自动化配置的一个核心点！**

那 `@ConditionalOnMissingBean`  的意思是，如果存在这个类，就不让这个自动配置类生效。我们再根据上图的加载优先顺序，每个配置类中，都有这样一句话。也都有一个  cacheManager 的 Bean

```java
	@Bean
	ConcurrentMapCacheManager cacheManager()...
```

也就意味着，谁先创建 `CacheManager` 后续再加载的 Cache配置类就无法实例化。

设计的非常巧妙对不对。这种思想在 SpringBoot 的其他地方均有体现！



既然我们已经知道 SpringBoot 是如何通过自动加载的方式创建 CacheManager 的，当然我们也可以用同样的办法自定义 CacheManger

Redis 默认的配置是使用 JDK 自带的序列化去缓存 value 值，我们可以用同样的方式去修改此配置

```java
	@Bean
	public RedisCacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
		// 分别创建String和JSON格式序列化对象，对缓存数据key和value进行转换
		RedisSerializer<String> strSerializer = new StringRedisSerializer();
		Jackson2JsonRedisSerializer jacksonSeial =
				new Jackson2JsonRedisSerializer(Object.class);
		// 解决查询缓存转换异常的问题
		ObjectMapper om = new ObjectMapper();
		om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
		om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
		jacksonSeial.setObjectMapper(om);
		// 定制缓存数据序列化方式及时效
		RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
				// 设置有效期为1天
				.entryTtl(Duration.ofDays(1))
				// 设置 key 的序列化方式为 String
				.serializeKeysWith(RedisSerializationContext.SerializationPair
						.fromSerializer(strSerializer))
				// 设置 value 的序列化方式为 Json
				.serializeValuesWith(RedisSerializationContext.SerializationPair
						.fromSerializer(jacksonSeial)) .disableCachingNullValues();
		RedisCacheManager cacheManager = RedisCacheManager .builder(redisConnectionFactory).cacheDefaults(config).build();
		return cacheManager;
	}
```

重新看一眼效果！

![image-20230517150043008](images/3%E3%80%81SpringBoot%20Cache/image-20230517150043008.png)

感谢阅读！