> 本文创建于 2021年5月14日
>
> 作者：xiang
> 参考文献：[https://blog.csdn.net/u013851082/article/details/70208246](https://blog.csdn.net/u013851082/article/details/70208246)

[toc]

## Semaphore

​		构造：

+ new Semaphore (int cout);

  ```java
  // count 指线程数
  Semaphore sp = new Semaphore(1);
  ```

​		主要的方法有：

+ void acquire();

  从构造中填入的信号数中获取一个，如果 Semaphore 中没有了，就滞留线程，等待其他现场释放

+ void release();

  释放一个信号，可以供其他现场使用 ==释放之前，不见得一定要acquire（）使用==

  ```java
  Semaphore sp = new Semaphore(1);
  sp.release();
  System.out.println(sp.availablePermits()); // 2
  ```

+ int availablePermits();

  返回当前的信号数

+ boolean hasQueuedThreads();

  查询是否有线程正在等待获取

