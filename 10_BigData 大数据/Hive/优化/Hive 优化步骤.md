
>2024-6-21 
>昆仑 DolphinScheduler 继续率调度优化 业务



### 第一步拆分SQL


以此文件为例子： ![](all.sql)

根据 `;` 拆分出多个不同的子 SQL 文件
注意点
1. 去除所有的 `TEMPORARY` 关键字，避免数据丢失
2. 在 drop table ... 后面添加 `purge` 删除，提高删除效率

拆分后的 SQL，会形成多个 子 SQL，此时使用调度工具，将第一个SQL 串联 到最后一个 SQL 执行一遍，效率可能不升反降

原因是 Hive 数据库默认开启 `CBO` 优化： 类似于 MySQL 的查询优化器，选择最优方法去做查询操作
```sql
-- 默认开启
set hive.cbo.enable=ture;
set hive.compute.query.using.stats=ture;
set hive.stats.fetch.column.stats=ture;
set hive.stats.fetch.partition.stats=ture;
```

关联文档： [Hive_Advanced 03_DQL](obsidian://open?vault=Hive_Advanced&file=doc%2F03_DQL)

此时就需要人工介入，通过分析单独SQL查看效率


### 查看串联执行效率

查看： [dolphin DWS_XQ_JXL37JYY 测试环境效率案例](http://dolphinscheduler_dev.com/dolphinscheduler/ui/projects/11495966918496/workflow/instances/6223/gantt?code=13555512138720)

![](images/Pasted%20image%2020240621113040.png)
通过甘特图，判断 3、5、7 执行时间较长，专门对其优

将 SQL 中 `from ( select xxxx from xxxx ) T `  其中的子查询部分单独拎出来，排查数据量，如果是小于十几万，那其实还行，如果是远超于这个数值，就一定要单独拎出来

关联文档： [Hive_Advanced 03_DQL](obsidian://open?vault=Hive_Advanced&file=doc%2F03_DQL) MapJoin 部分，


通过使用逻辑图分析
![](继续率优化图.graffle)



单独一个SQL占用资源过大，导致其他SQL需要排队提交

![](images/Pasted%20image%2020240621114218.png)




