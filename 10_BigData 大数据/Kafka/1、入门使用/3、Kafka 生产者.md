## 发送原理

在消息发送过程中，涉及到两个线程——main线程和 Sender 线程，在 main 线程中创建了一个双端队列 RecordAccumulator，main 线程将消息发送给 RecordAccumulator，Sender 线程不断从 RecordAccumulator 中拉去消息发送到 Kafka Broker 中。

![image-20231022173505194](images/3、Kafka 生产者/image-20231022173505194.png)

