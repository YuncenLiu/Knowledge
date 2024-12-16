[toc]

> 使用 SQL Developers 操作

连接名：EAST

用户名：EAST

密码：EAST

------

连接类型：基本				角色：默认值

主机名：115.28.187.91

端口：1521

SID：orcl



## 游标

游标，可以存放多个对象，多行记录   类似于java中的集合
具体使用：可用于输出

```sql
-- 创建一个游标，打印 X27_USER 中的NAME
DECLARE
    cursor u1 is select * from X27_USER;
    -- 赋类型
    usern X27_USER%rowtype;
BEGIN
    -- 打开游标
    open u1;
        -- 开始遍历，有开始就要有结束
        loop
            -- 把 u1 中的数据 放入 usern 中
            fetch u1 into usern;
            -- 当遍历到最后一个的后面一个的时候，跳出
            exit when u1%notfound;
            -- 输出 u1 集合中 写入到游标中的 name字段
            dbms_output.put_line(usern.name);
        end loop;
    -- 关闭游标
    close u1;
END;
```

打开`查看`   打开`DBMS输出`   连接到  EAST 数据库



备份自己的Oracle 来操作

准备环境

```sql
-- 创建表空间，指定大小、位置、自动增长、新增大小
create tablespace east_test
datafile 'F:\study\Oracle\tablespace\east_test.dbf'
size 100m
autoextend on 
next 10m;
-- 新增用户 用户名east 密码east 并指定 表空间
create user east
identified by east
default tablespace east_test;
-- 授于最高管理员权限
grant dba to east;
```

从 east 库中 导出 X27_ORG 表 使用 cvs 方式

导入到 本地数据库的 east 库中，以 ORG 为名

### 游标控制数据

使用游标，把该字段的所有数据 + 100

需求：把所有自治区的 LVL_CODE  + 100

```sql
DECLARE
    cursor c(name1 org.name%TYPE)
    is select name from org where name like name1;
    name2 org.name%TYPE;
BEGIN
    open c('%自治区%');
        LOOP
            fetch c into name2;
            exit when c%notfound;
            update org set LVL_CODE = LVL_CODE+100 where NAME = name2;
            dbms_output.put_line(name2);
            commit;
        END LOOP;
    close c;
END;
```

## 存储过程

用法：

```sql
-- 存储过程：就是提前已经编译好的一段 pl/sql 语言，放置在数据库，可以直接被调用，这一段pl/sql 一般都是固定步骤的业务

-- 语法：
-- create [or replace] PROCEDURE 过程名 [(参数名 in/out 数据类型)]
-- IS
-- begin
-- 		PLSQL 执行sql;
-- END;
```

创建存储过程 给指定的org_id 加1000 的lvl_code

```sql
create or replace PROCEDURE p1(id org.org_id%type)
is
begin
    update org set lvl_code = lvl_code + 1000 where org_id=id;
    DBMS_OUTPUT.put_line(id);
    commit;
end;
```

or replace 即使出错，也可以创建出该存储过程，不严谨创建

调用 存储过程    给 3c9fe8546978855d01697b9d7998030b 的 org_id 的 lvl_code 加1000

```sql
DECLARE
BEGIN
	p1('3c9fe8546978855d01697b9d7998030b');
END;
```

## 存储函数

通过存储函数返回一个值

需求：查询当天的操作次数    X27_OPERATION_LOG 表

```sql
create or replace function f2(time1 VARCHAR2) return number
is
s number(11);
begin
    select count(0) into s from X27_OPERATION_LOG where operate_time like time1;
    DBMS_OUTPUT.put_line('入参 ：'||time1);
    DBMS_OUTPUT.put_line('返回值 ：'||s);
    return s;
end;
```

测试:

存储函数在调用的时候，必须接受返回值

```sql
DECLARE 
	en NUMBER(10);
BEGIN
	en:=F2('2020-08-27%');
	dbms_output.put_line(en);
END;
```

输出：

入参 ：2020-08-27%
返回值 ：91
91