 

### 中断机制

一个线程不应该被其他线程中断，应该由自身线程决定，所以 `thrad.stop`、`thread.suspend`、`thread.resume` 都已经废弃了



这是一种协商机制，底层打一个True标识，线程自身发现后，由程序员自己写代码处理线程



这下面三个方法分别什么功能

```java
void interrupt(); // 设置线程未中断状态
static boolean interrupted() // 判断线程是否中断，清零线程的中断状态
boolean isInterrupted() // 判断线程是否中断
```



> 问题：
>
> 1. 如何中断运行中线程
> 1. 如何停止运行中线程
> 2. 当前线程中断标识为 true，是否立刻停止
> 3. 静态方法 Thread.interupted() 谈谈你的理解