### 1、其他权限校验方法

前面都是使用的  `@PreAuthorize` 注解，然后再其中使用 hasAuthority 方式进行校验，SpringSecurity 还为我们提供了其他方法，例如 hasAnyAuthority，hasRole，hasAnyRole 等

+ hasAnyAuthority：存在任意一个就可以访问
+ hasRole、hasAnyRole：需要拼接 `ROLE_` 



### 2、自定义权限校验方法

我们可以自定义权限校验方法，再 @PreAuthorize 注解中使用

```java
/**
 * 自定义权限校验方法
 */
@Component("ex")
public class SGExpressionRoot {

    public boolean hasAuthority(String authority){
        // 获取当前用户权限
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        LoginUser loginUser = (LoginUser) authentication.getPrincipal();
        List<String> permissions = loginUser.getPermissions();
        // 判断用户权限集合存在 authority
        return permissions.contains(authority);
    }
}
```

Controller

```java
@PreAuthorize("@ex.hasAuthority('admin')")
public String sayHello(){
    return "hello world";
}
```


也可以基于配置的方式进行权限配置

```java
 .antMatchers("/test").hasAnyAuthority("admin")
```



### 3、认证成功处理器

实际上再 UsernamePasswordAuthenticationFilter 进行登录认证的时候，如果登录成功了是会调用 AuthenticationSuccessHandler 的放啊进行认证成功处理的。AuthenticationSuccessHandler 就是登录成功处理器。

​	我们也可以自己去自定义成功处理器进行成功后的相应处理  

> 注意：这里只针对表单的案例

SecurityConfig

```java
	@Autowired
    private SuccessHandler successHandler;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().successHandler(successHandler);
        http.authorizeRequests().anyRequest().authenticated();
    }
```

SuccessHandler

```
@Component
public class SuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        System.out.println("登录成功！");
    }
}
```