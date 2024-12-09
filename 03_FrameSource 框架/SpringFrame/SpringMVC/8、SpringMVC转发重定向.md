## 重定向参数传递

```java
    @RequestMapping("/handleRedirect")
    public String handleRedirect(String name) {
        return "redirect:handle01?name="+name;
    }

    @RequestMapping("/handle01")
    public ModelAndView handle01(@ModelAttribute("name") String name) {
				// ...
        modelAndView.setViewName("success");
        return modelAndView;
    }
```

拼接参数安全性、参数长度都有局限

解决方法如下

```java
    @RequestMapping("/handleRedirect")
    public String handleRedirect(String name,RedirectAttributes redirectAttributes) {
        //return "redirect:handle01?name=" + name;  // 拼接参数安全性、参数长度都有局限
        // addFlashAttribute方法设置了一个flash类型属性，该属性会被暂存到session中，在跳转到页面之后该属性销毁
        redirectAttributes.addFlashAttribute("name",name);
        return "redirect:handle01";

    }
```

