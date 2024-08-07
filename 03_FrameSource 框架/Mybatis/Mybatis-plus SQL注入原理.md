## Mybatis-plus 的SQL注入原理

myabtisplus 在启动时，会将一系列的方法注册到 meppedStatements 中，那么究竟是如何注入的呢？流程如何？

下面我们来分析一下

在 Mybatis-plus 中，ISqlInjector 负责 SQL 注入工作，它是一个接口，AbstractSqlInjector 是它的实现类，

