## JDK 版本变化

### JDK 1.5

1. 自动装箱与拆箱：

2. 枚举

3. 静态导入，如：import staticjava.lang.System.out

4. 可变参数（Varargs）

5. 内省（Introspector），主要用于操作JavaBean中的属性，通过getXxx/setXxx。一般的做法是通过类Introspector来获取某个对象的BeanInfo信息，然后通过BeanInfo来获取属性的描述器（PropertyDescriptor），通过这个属性描述器就可以获取某个属性对应的getter/setter方法，然后我们就可以通过反射机制来调用这些方法。

6. 泛型(Generic)（包括通配类型/边界类型等）

7. For-Each循环

8. 注解

9. 协变返回类型：实际返回类型可以是要求的返回类型的一个子类型



### JDK1.6

1. AWT新增加了两个类:Desktop和SystemTray，其中前者用来通过系统默认程序来执行一个操作，如使用默认浏览器浏览指定的URL,用默认邮件客户端给指定的邮箱发邮件,用默认应用程序打开或编辑文件(比如,用记事本打开以txt为后缀名的文件),用系统默认的打印机打印文档等。后者可以用来在系统托盘区创建一个托盘程序

2. 使用JAXB2来实现对象与XML之间的映射，可以将一个Java对象转变成为XML格式，反之亦然

3. StAX，一种利用拉模式解析(pull-parsing)XML文档的API。类似于SAX，也基于事件驱动模型。之所以将StAX加入到JAXP家族，是因为JDK6中的JAXB2和JAX-WS 2.0中都会用StAX。

4. 使用Compiler API，动态编译Java源文件，如JSP编译引擎就是动态的，所以修改后无需重启服务器。

5. 轻量级Http Server API，据此可以构建自己的嵌入式HttpServer,它支持Http和Https协议。

6. 插入式注解处理API(PluggableAnnotation Processing API)

7. 提供了Console类用以开发控制台程序，位于java.io包中。据此可方便与Windows下的cmd或Linux下的Terminal等交互。

8. 对脚本语言的支持如: ruby,groovy, javascript

9. Common Annotations，原是J2EE 5.0规范的一部分，现在把它的一部分放到了J2SE 6.0中

10. 嵌入式数据库 Derby



### JDK1.7

1. 对Java集合（Collections）的增强支持，可直接采用[]、{}的形式存入对象，采用[]的形式按照索引、键值来获取集合中的对象。如：

     ```java
     List<String>list=[“item1”,”item2”];//存
     Stringitem=list[0];//直接取
     Set<String>set={“item1”,”item2”,”item3”};//存
     Map<String,Integer> map={“key1”:1,”key2”:2};//存
     Intvalue=map[“key1”];//取
     ```

2. 在Switch中可用String

3. 数值可加下划线用作分隔符（编译时自动被忽略）

4. 支持二进制数字，如：int binary= 0b1001_1001;

5. 简化了可变参数方法的调用

6. 调用泛型类的构造方法时，可以省去泛型参数，编译器会自动判断。

7. Boolean类型反转，空指针安全,参与位运算

8. char类型的equals方法: booleanCharacter.equalsIgnoreCase(char ch1, char ch2)

9. 安全的加减乘除: Math.safeToInt(longv); Math.safeNegate(int v); Math.safeSubtract(long v1, int v2);Math.safeMultiply(int v1, int v2)……

10. Map集合支持并发请求，注HashTable是线程安全的，Map是非线程安全的。但此处更新使得其也支持并发。另外，Map对象可这样定义：Map map = {name:"xxx",age:18};



### JDK1.8

1. 接口的默认方法：即接口中可以声明一个非抽象的方法做为默认的实现，但只能声明一个，且在方法的返回类型前要加上“default”关键字。

2. Lambda 表达式：是对匿名比较器的简化，如：

     ```java
Collections.sort(names,(String a, String b) -> {
   returnb.compareTo(a);
});
     ```

对于函数体只有一行代码的，你可以去掉大括号{}以及return关键字。如：

     ```java
Collections.sort(names,(String a, String b) -> b.compareTo(a));
//或：
Collections.sort(names, (a, b) -> b.compareTo(a));
     ```

3. 函数式接口：是指仅仅只包含一个抽象方法的接口，要加@FunctionalInterface注解

4. 使用 :: 关键字来传递方法或者构造函数引用

5. 多重注解

6. 还增加了很多与函数式接口类似的接口以及与Map相关的API等……

