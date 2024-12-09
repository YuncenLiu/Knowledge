### 退出登录

从上一章我们知道， JwtAuthenticationTokenFilter 过滤器的最后一步，会从 redis 中获取到当前用户的所有信息

我们只需要把 redis 中当前用户的信息给删掉，即可实现退出登录

```java
    @Override
    public ResponseResult logout() {
        // 获取 SecurityContextHolder 中的用户
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken)SecurityContextHolder.getContext().getAuthentication();
        LoginUser loginUser = (LoginUser) authentication.getPrincipal();
        Long userid = loginUser.getUser().getId();
        // 删除 redis 中的值
        String key = "login:";
        redisCache.deleteObject(key+userid);
        return new ResponseResult(200,"注销成功");
    }
```

