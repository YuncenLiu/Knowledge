# Gateway 实现 API 网关

Github官方文档：https://cloud.spring.io/spring-cloud-gateway/reference/html/

## 1.核心概念

路由（Route），路由是网关最基本部分，路由信息由 ID、目标URL、一组断言和一组过滤器组成，如果断言路由为真，则说明请求的URL和配置匹配

断言（Predicate），Java8中的断言函数，Spring Cloud Gateway 中的断言函数输入类型是 Spring 5.0框架中的，ServerWebExchange，允许开发者自定义匹配来自 Http Request 中的任何信息，比如请求头参数等

过滤器（Filter），一个标准的 Spring Web Filter分别是 Gateway Filter 和 Gloab Filter，过滤器将会对请求和响应进行处理



### 1.2.路由 Route

​        Route 主要由 路由id、目标uri、断言集合和过滤器集合组成，那我们简单看看这些属性到底有什么作用。

（1）id：路由标识，要求唯一，名称任意（默认值 uuid，一般不用，需要自定义）

（2）uri：请求最终被转发到的目标地址

（3）order： 路由优先级，数字越小，优先级越高

（4）predicates：断言数组，即判断条件，如果返回值是boolean，则转发请求到 uri 属性指定的服务中

（5）filters：过滤器数组，在请求传递过程中，对请求做一些修改



11种断言策略：https://docs.spring.io/spring-cloud-gateway/docs/2.2.9.RELEASE/reference/html/#gateway-request-predicates-factories



