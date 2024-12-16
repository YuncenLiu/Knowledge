

### HTTP 反馈400 时啥问题

当某一接口 [/inventory/saleByRedisson](http://localhost:7777/swagger-ui.html#/operations/redis 分布式锁测试/saleByRedissonUsingGET) 需要的参数是 `count integer($int32)` ，此时前端发送 count=A ，后台立即反馈 `400` 

后台同时打印日志：

```
2024-08-15 09:41:40.937 [http-nio-7777-exec-6] WARN  o.s.w.s.m.s.DefaultHandlerExceptionResolver - Resolved [org.springframework.web.method.annotation.MethodArgumentTypeMismatchException: Failed to convert value of type 'java.lang.String' to required type 'java.lang.Integer'; nested exception is java.lang.NumberFormatException: For input string: "A"]
```