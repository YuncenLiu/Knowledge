# Gateway 实现 API 网关

Github官方文档：https://cloud.spring.io/spring-cloud-gateway/reference/html/

## 1.核心概念

路由（Route），路由是网关最基本部分，路由信息由 ID、目标URL、一组断言和一组过滤器组成，如果断言路由为真，则说明请求的URL和配置匹配

断言（Predicate），Java8中的断言函数，Spring Cloud Gateway 中的断言函数输入类型是 Spring 5.0框架中的，ServerWebExchange，允许开发者自定义匹配来自 Http Request 中的任何信息，比如请求头参数等

过滤器（Filter），一个标准的 Spring Web Filter分别是 Gateway Filter 和 Gloab Filter，过滤器将会对请求和响应进行处理

