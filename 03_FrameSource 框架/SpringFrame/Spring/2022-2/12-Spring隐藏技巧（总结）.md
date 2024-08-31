Spring Bean 和 Java Bean 的区别？

JavaBean 要求所有属性为私有，该类必须要有一个公共无参构造，private 属性必须提供公共的 getter 和 setter 给外部访问

```java
public class User {
    private String name;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

​	SpringBean 是受 Spring 管理的对象，所有能受Spring管理的对象都可以是SpringBean



+ 用处不同：
	+ 传统javabean更多地作为值传递参数
	+ spring中的bean用处几乎无处不在，任何组件都可以被称为bean
+ 写法不同：
	+ 传统javabean作为值对象，要求每个属性都提供getter和setter方法；
	+ 但spring中的bean只需为接受设值注入的属性提供setter方法
+ 生命周期不同：
	+ 传统javabean作为值对象传递，不接受任何容器管理其生命周期；
	+ spring中的bean有spring管理其生命周期行为