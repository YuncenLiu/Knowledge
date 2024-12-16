## 异常处理

在一个 Controller 里写一个方法，使用 @ExceptionHandler 注解

```java
@ExceptionHandler(ArithmeticException.class)
public void handleException(ArithmeticException exception,HttpServletResponse response) {
    // 异常处理逻辑
    try {
        response.getWriter().write(exception.getMessage());
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

这个异常处理类，只能针对当前 controller 有效，如果出现了 ArithmeticException 异常，则会进入这个方法里。



全局异常处理 `@ControllerAdvice` 

```java
@ControllerAdvice
public class GlobalExceptionResolver {

    @ExceptionHandler(ArithmeticException.class)
    public ModelAndView handleException(ArithmeticException exception, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("msg",exception.getMessage());
        modelAndView.setViewName("error");
        return modelAndView;
    }
}
```

这样就可以跳转到一个页面，优雅的处理异常信息

否则

![image-20230323170849276](images/7%E3%80%81SpringMVC%E5%BC%82%E5%B8%B8%E5%A4%84%E7%90%86/image-20230323170849276.png)