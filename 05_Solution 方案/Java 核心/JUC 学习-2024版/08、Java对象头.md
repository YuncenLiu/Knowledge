# Java对象内存布局和对象头



JDK8情况，new 一个对象，对象会存在于JVM的 新生代、老年代、方法区中

在HotSpot 虚拟机中，对象在对内存中的存储布局可以划分为三部分：对象头、实例数据、对其填充（保证8个字节的倍数）



<img src="images/08%E3%80%81Java%E5%AF%B9%E8%B1%A1%E5%A4%B4/image-20241204152206513.png" alt="image-20241204152206513" style="zoom:50%;" />

#### 对象头

标记为标记对象（markOop）和类元素信息（klassOop），对应 Mark Word 和 Class Pointer

<img src="images/08%E3%80%81Java%E5%AF%B9%E8%B1%A1%E5%A4%B4/image-20241204153300271.png" alt="image-20241204153300271" style="zoom:67%;" />



在 64位系统中，Mark Word 占用 8 个字节，类型指针占 8 个字节，一共 16 个字节。

<img src="images/08%E3%80%81Java%E5%AF%B9%E8%B1%A1%E5%A4%B4/image-20241204153523939.png" alt="image-20241204153523939" style="zoom:67%;" />



#### 类型指针



