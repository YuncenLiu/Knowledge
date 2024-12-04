> 2024-08-22

## Future

Future 接口，Java5定义了操作异步任务执行一些方法，获取异步任务的执行结果、取消任务的执行、判断任务是否被取消、判断任务是否执行完毕

优点：Future + 线程池异步多线程任务配合，能显著提高程序执行效率

缺点：`get()` 阻塞案例：[FutureAPIDemo](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/FutureAPIDemo.java)，调用 get 方法之后，会导致程序阻塞，解决方案在 get 里面写入时间，然后重试，避免长时间阻塞。

`isDone()`轮询的方式会耗费无谓的CPU资源，而且也不见得能及时得到计算结果。

### FutureTask

![image-20241125174952029](images/02%E3%80%81CompletableFutrue/image-20241125174952029.png)





#### 实现复杂功能

对于简单场景 Future 完全 OK 的

阻塞的方式和异步编程的设计理念相违背，而轮训会导致无谓的CPU资源，因此 JDK8 提供了 `CompletableFuture` ，这是一种观察者模式，可以让执行完成后通知监听的一方

![image-20240821174808667](images/02%E3%80%81CompletableFutrue/image-20240821174808667.png)

```java
public class CompletableFuture<T> implements Future<T>, CompletionStage<T> {
```



## CompletableFuture

[核心的四个静态方法获取](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureBuildDemo.java)。

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



#### [whenComplete 当子线程任务完成时，主动回掉](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureUseDemo.java)

如果出现异常，则会主动调用 `exceptionally` 方法，在 `whenComplete` 方法中，用 `if (null == e)` 可以避免异常情况进入代码块，因为存在异常还未及时返回，先执行了 whenComplete 方法

![image-20240822104420358](images/02%E3%80%81CompletableFutrue/image-20240822104420358.png)



## 案例：比价需求

同一款产品，同时搜索出在各大电商平台的售价，搜索在同一个平台下，各个入住买家售价多少

[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureMallDemo.java#L57)

 

## 总结

### 获取结果和触发计算

获取结果方法有 `get`、 `get(long timeout, TimeUnit unit)`、 `join`、 `getNow(T valueIfAbsent)`

[主动触发计算](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureDemo2.java)



### 对计算结果进行处理

计算结果存在以来关系，串行化操作 `thenApply` , 由于有依赖关系，当前异常的话，直接进入 `exceptionally` ，[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureAPI2Demo.java)

如果希望异常还能继续往下走的情况下，使用 `handle(e,v)` 放在下一个节点，这样异常还可以往下继续走。

![image-20240822131359973](images/02%E3%80%81CompletableFutrue/image-20240822131359973.png)



+ 任务A执行完，执行B，并且B 不需要A 的结果 `thenRun` ，[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureAPI4Demo.java)

	1. 没有传入自定义线程池，都用默认线程池 ForkJoinPool

	2. 传入了自定义线程池，第一个任务就传入了自定义线程池

		调用 thenRun 方法执行第二个，则第二个任务和第一个任务共用线程池

		调用 thenRunAsync 执行第二个，则第一个是自定义线程池，第二个是 ForkJoinPool 线程池

		【备注】：也有可能用处理的太快了，系统优化切换原则，直接使用 main 线程处理

		`thenAccpet`、`thenAccpetAsync` 和 `thenApply` 、`thenApplyAsync` 同理 

		[演示案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureWithThreadPoolDemo.java)

+ 任务A执行完，执行B，需要A 的结果，但任务B没有返回值，`thenAccept` ，[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureAPI3Demo.java)

+ 任务A执行完，执行B，需要A 的结果，同时任务B有返回值，`thenApply` ，[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureAPI2Demo.java)





#### 对计算速度进行对比，选用

[看谁快，谁快调用谁](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureFastDemo.java)



#### 对计算结果进行合并

两个 ColpletionStage 任务都完成后，最终把两个任务的结果交给 `thenCombine`  来处理，先完成的等着，等待其他分支任务

[代码案例](https://github.com/YuncenLiu/code-example/blob/master/thread/src/main/java/com/liuyuncen/juc/cf1/CompletableFutureCombineDemo.java)