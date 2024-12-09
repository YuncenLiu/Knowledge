![image-20241209135249777](images/14%E3%80%81AQS/image-20241209135249777.png)



基于 ReetrantLock 的 AQS 源码解析，以非公平案例演示



抢占

第一步：`compareAndSetState(0, 1)` 比较交换

第二步：`setExclusiveOwnerThread(Thread.currentThread())` 当前持有锁，占有线程 



没抢到

`acquire(1)` 排队去



`acquire` 方法源码分析

```java
if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
```

第一步：`tryAcquire(arg)` 

基于 AQS 父类接口，由子类实现的 `tryAcquire` ，ReetrantLock 公平锁与非公平 区别在于调用 `tryAcquire()` 和 `nonfairTryAcquire()` 方法，他们之前区别就是 一个有 `hasQueuedPredecessors()` 另一个没有，根据上图显示

第二步：

1. `addWaiter` 将线程放到队列后面 
2. enq 入队
3. `acquireQueued` 循环入队
4. `cancelAcquire` 取消入队