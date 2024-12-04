## ThreadLocal 

简介：通过实现每个线程拥有自己专属变量副本，从而避免线程安全问题

1. 为什么是弱引用
2. 为什么会内存泄漏？
3. 为什么要调用remove方法



### Thread、ThreadLocal、ThreadLocalMap 关系



<img src="images/07%E3%80%81ThreadLocal/image-20241204104837856.png" alt="image-20241204104837856" style="zoom:50%;" />

JVM内部维护了一个线程版的 Map<ThreadLocal, value> 把自身线程当作key 放入 Map中

源码片段：

<img src="images/07%E3%80%81ThreadLocal/image-20241204104937025.png" alt="image-20241204104937025" style="zoom:50%;" />



引出问题：

1. 为什么是弱引用
2. 为什么会内存泄漏？



为什么会内存泄漏，不再被使用的对象或变量占用内存但不能被回收，就是内存泄漏。就是指 ThreadLocal 在线程池使用过程中，使用完成后不 remove 清理，导致内存泄漏问题。

<img src="images/07%E3%80%81ThreadLocal/image-20241204110249044.png" alt="image-20241204110249044" style="zoom:50%;" />

> 四种引用类型：
>
> 1. 强引用：GC不会自动回收
> 2. 软引用：回不回收看内存紧张不紧张
> 3. 弱引用：下一次就会被清掉了
> 4. 虚引用：任何时候都会被干掉

软引用和弱引用适用场景：

假设有一个应用需要读取大量本地图片

+ 如果每次读取图片都需要从硬盘读取则会严重影响性能
+ 如果一次性全部加载到内存中，又可能造成内存溢出

此时软引用解决这个问题，用 HashMap 保存图片路径和相对应图片关联的软引用之间映射关系，在内存不足时，JVM自动回收这些缓存图片所占用的空间，从而有效避免OOM问题

```java
Map<String, SoftReference<Bitmap>> imageCache = new HashMap<String, SoftReference<Bitmap>>()
```

![image-20241204115256129](images/07%E3%80%81ThreadLocal/image-20241204115256129.png)



总结：

ThreadLocal 只是一个空壳子，真正存储结构是 ThreadLocal 里有个 ThreadLocalMap 内部类，每一个 Thread 对象维护一个 ThreadLocalMap ,内部用 Entiry 存储

set 方法时，实际上是往 ThreadLocalMap 设置值，value是传递进来的对象、get 也差不多

正因为如此，ThreadLocal 能够实现数据隔离，获取当前线程的局部变量，不受其他线程影响





**为什么源代码用弱引用？**

当 function1 方法执行完成后，栈帧销毁强引用 tl 也就没了，但此时线程的 ThreadLocalMap 里的某个 entry 的 key 还引用指向那个对象，

+ 若这个key 引用是强引用，就会导致key指向的 ThreadLocal 对象及 v 指向的对象不能被 GC，造成内存泄漏。
+ 若这个key 是 弱引用，大概率会减少内存泄漏问题，

<img src="images/07%E3%80%81ThreadLocal/image-20241204141643350.png" alt="image-20241204141643350" style="zoom:50%;" />



**引发 key 为null 的情况？**

因为使用 弱引用，当使用 tl 的get、set、remove方法时，就会尝试删除 key 为null的entry，释放value对象所占内存。

当我们为 ThreadLocal 变量赋值时，实际上就是当前 Entry 往这个 threadLocalMap 中存放，Entry 中的key 是弱引用，当 threadLocal 外部强引用被置为 null 时，那么系统 GC 时，根据可达性分析，这个 threadLocal 实例就没有任何一条链路能够引用到它， threadLocal 势必会被回收

1、这样一来，ThreadLocalMap 中就会出现key为null的entiry，就没办法访问到这些 value，如果当前线程迟迟不结束，这些 value 就会一直存在一条强引用链， Thread Ref -> Thread  -> ThreadLocalMap -> Entry -> value 就永远无法回收。

2、如果 thread 提前结束，没有引用链可达，就能成功回收

3、实际系统中都会用线程池维护线程，为了复用线程是不会结束的，所以 ThreadLocal 内存泄漏就值得我们小心。



虽然弱引用，保证了 key 指向的 ThreadLocal 对象能够被及时回收，但是 v 指向的 value 对象需要 ThreadLocalMap 调用 get、set 时发现 key 为 null 时，才会回收整个 entry、value 因此弱引用不能 100%保证内存不泄漏，所以我们要在不使用 ThreadLocal 对象后，手动调用 remove 方法删除，尤其是线程池。