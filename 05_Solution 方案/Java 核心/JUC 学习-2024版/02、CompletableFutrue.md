> 2024-08-22

## Future

Future 接口，Java5定义了操作异步任务执行一些方法，获取异步任务的执行结果、取消任务的执行、判断任务是否被取消、判断任务是否执行完毕

优点：Future + 线程池异步多线程任务配合，能显著提高程序执行效率

缺点：`get()` 阻塞案例：[FutureAPIDemo](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf/FutureAPIDemo.java)，调用 get 方法之后，会导致程序阻塞，解决方案在 get 里面写入时间，然后重试，避免长时间阻塞。



#### 实现复杂功能

对于简单场景 Future 完全 OK 的

阻塞的方式和异步编程的设计理念相违背，而轮训会导致无谓的CPU资源，因此 JDK8 提供了 `CompletableFuture` ，这是一种观察者模式，可以让执行完成后通知监听的一方

![image-20240821174808667](images/02%E3%80%81CompletableFutrue/image-20240821174808667.png)

```java
public class CompletableFuture<T> implements Future<T>, CompletionStage<T> {
```



## CompletableFuture

[核心的四个静态方法获取](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf/CompletableFutureBuildDemo.java)。

1. runAsync 无返回值
2. supplyAsync 有返回值

在这两个基础上，每个都可以传入线程池，或者不传

如果没有指定 Executor 方法，直接默认 `ForkJoinPool.commonPool()` 作为它的线程池执行异步代码，拿 runAsync 举例子

![image-20240821175635472](images/02%E3%80%81CompletableFutrue/image-20240821175635472.png)



> 守护线程 和 用户线程 概念
>
> Main 线程结束时候，默认的线程就会被关闭，如果是自定义的线程池，则需要自己手动关闭，关闭后，无论子线程是否在工作都会被关停。
>
> 非自定义线程需要 sleep 保证线程池中任务正常完成。



#### [whenComplete 当子线程任务完成时，主动回掉](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf/CompletableFutureUseDemo.java)

如果出现异常，则会主动调用 `exceptionally` 方法，在 `whenComplete` 方法中，用 `if (null == e)` 可以避免异常情况进入代码块，因为存在异常还未及时返回，先执行了 whenComplete 方法

![image-20240822104420358](images/02%E3%80%81CompletableFutrue/image-20240822104420358.png)



## 案例：比价需求

同一款产品，同时搜索出在各大电商平台的售价，搜索在同一个平台下，各个入住买家售价多少

[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf/CompletableFutureMallDemo.java#L57)

