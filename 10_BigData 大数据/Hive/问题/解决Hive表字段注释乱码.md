原因是 MySQL 数据库

无需重启任何服务

MySQL 操作提交后，删除表重建提交生效

```sql

alter table hive.COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;
alter table hive.TABLE_PARAMS modify column PARAM_VALUE varchar (4000) character set utf8;
alter table hive.PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;
alter table hive.PARTITION_PARAMS modify column PARAM_VALUE varchar (4000) character set utf8;
alter table hive.INDEX_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;

```

