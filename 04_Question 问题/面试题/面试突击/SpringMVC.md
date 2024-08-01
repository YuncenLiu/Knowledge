[toc]



# SpringMVC



​		发送请求后台处理

1. Request 请求到 DispacherServlet 
2. DispacherServlet 请求查找 Hanler ，HandlerMapping 映射处理器 返回执行链给 DispatcherServlet
3. DispacherServlet 请求适配器执行 HandlerAdaoter 去执行 Handler ，Hander 返回 ModelAndView 给 HandlerAdatpter 再返回给 DsiapcherSerlvet
4. DispacherServlet 请求试图解析器 ViewResolver ，返回 View 给 控制器
5. 控制器渲染页面，jsp、Freemarker 、pdf 等，返回给前端页面。



​		上传文件

1. 前端提交文件上传 request  到前端控制器
2. 控制器 请求 配置文件解析器 解析request
3. 解析器 upload 前端控制器
4. 前端控制器 upload 控制层文件上传，最终 MulitiarFile upload 文件就可以拿到文件了



​		异常处理

1. 一层一层往上抛，dao - service - web - 控制器 - 异常处理器



​		拦截器

过滤器是Java web 工程一个部分，也是引入了 aop 的思想，如果要自定义拦截器的话，必须实现 HandlerInterceptor