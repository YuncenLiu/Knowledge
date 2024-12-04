## new 一个对象

官网：https://openjdk.org/projects/code-tools/jol/



测试引用Maven

```xml
<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.9</version>
</dependency>
```

new一个对象查看对象大小

````java
Object o = new Object();
System.out.println(ClassLayout.parseInstance(o).toPrintable());
````

![image-20241204213137976](images/09、new一个对象/image-20241204213137976.png)

+ OFFSET：偏移量，也就是这个字段位置所占用的 byte 数
+ SIZE：后面类型的字节大小
+ TYPE：是 Class 中定义的类型
+ DESCRIPTION：DESCPTPTION 是类型的描述
+ VAULE：TYPE在内存中的值



通过上面的图，可以发现最后一句话“loss due to the next object alignment” 补齐8的倍数

```java
class Customer{
    int id;
    boolean flag = false;
}
```

![image-20241204213717019](images/09、new一个对象/image-20241204213717019.png)

因此也证明了 int 占4字节，boolean 占1字节

00000000 00000000 00000000 00000000 = 2^32 /2 = 2,147,483,648-1 



### JVM 分带年龄

最大为15，如果设置为16，则程序无法启动

```
-XX:MaxTenuringThreshold=16
```



![image-20241204215041319](images/09、new一个对象/image-20241204215041319.png)

默认开启压缩，所以 前面 Headers 头是4字节