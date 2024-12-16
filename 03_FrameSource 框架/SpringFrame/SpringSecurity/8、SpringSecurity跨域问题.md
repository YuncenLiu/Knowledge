### 跨域

浏览器处于安全考虑，使用 XMLHttpRequest 对象发起 HTTP 请求时必须遵守同源策略，否则就是跨域的 HTTP 请求，默认情况下是被禁止的，同源测率要求源相同才能正常进行通讯，即协议、域名、端口号都完全一致

前后端分离项目，一般都是不同源的，所以肯定会存在跨域请求问题

针对 SpringSecurity 就需要处理一些，让前端能进行跨域请求

  

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // 设置允许跨域路径
        registry.addMapping("/**")
                // 允许跨域请求域名
                .allowedOriginPatterns("*")
                // 是否允许 cookie
                .allowCredentials(true)
                // 设置允许的请求方式
                .allowedMethods("GET","POST","DELETE","PUT")
                // 设置允许的 header 属性
                .allowedHeaders("*")
                // 跨域允许时间
                .maxAge(3600);
    }
}
```

在  SecurityConfig.configure() 开启跨域

```java
// 允许跨域
http.cors();
```