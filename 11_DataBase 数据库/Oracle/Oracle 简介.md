## Oracle 简介

oracle 创始人拉里·埃里森

### 1、数据库

​		Oracle 数据库是数据的物理存储，这就包括（数据文件ORA或者DBF、控制文件、联机日志、参数文件）其实Oracle数据库的概念和其他数据库不一样，这里的数据库是一个操作系统只有一个库。可以看作是Oralce就只有一个大数据库

### 2、实例

​		一个Oracle实例（Oracle Instance）有一个系列的后台进程和内存结构组成，一个数据库可以有n个实例

### 3、用户

​		用户是实例下建立的。不同实例可以建相同名字的用户

### 4、表空间

​		表空间是Oracle 对物理数据库上相关数据文件（ORA 或者 DBF 文件）的逻辑映射。一个数据库在逻辑上被划分成一到若干个表空间，每个表空间包含了在逻辑上相关联的一组结构。每个数据库至少有一个表空间（称之谓system表空间）

每个表空间由同一个磁盘的一个或多个文件组成，这些文件叫数据文件（datafile）一个数据文件中属于一个表空间

![image-20200516220057725](images/1.png)

### 5、数据文件

​	数据文件是数据库的物理储存单位，数据的数据是存储在表空间中的，真正的在某个或者多个数据文件中，而一个表空间可由一个或多个数据文件组成，一个数据文件只能属于一个表空间。一旦数据文件被加载到了某个表空间后，就不能删除这个文件，如果要删除某个数据文件，只能删除其所属于的表空间才行。

> 注：表的数据，是有用户放入某个表空间的，而这个表空间会随机吧这些表数据放到一个或者多个数据文件中

![Oralce实例](images/oracle%E5%AE%9E%E4%BE%8B.png)

### 运行代码：

```sql
-- 创建表空间
create tablespace itheima
datafile 'F:\study\Oracle\tablespace\itheima.dbf'
size 100m
autoextend on 
next 10m;
-- 删除表空间
-- 如果不删除表空间，在datafile 对应的文件里，该文件会因 oralce 占用而无法删除
drop tablespace itheima;

-- 创建用户
create user itheima
identified by itheima
default tablespace itheima;

-- 必须要给用户授权
-- oracle 数据库中常用角色
-- connect -- 连接角色，基本角色
-- resource -- 开发者角色
-- dba  -- 超级管理员角色
-- 给itheima 用户授予 dba 角色
grant dba to itheima;

-- 切换到 itheima 用户下


-- 创建一个person 表
create table person(
    pid number(20),
    pname varchar2(10)
);

-- 修改表结构
-- 添加一列
alter table person add gender number(1);
-- 添加多列
alter table person add (
    gender number(1),
    phone number(11)
);

-- 修改列的类型
alter table person modify (
    gender char(6)
);

-- 修改列的名称
alter table person rename column gender to sex;

-- 删除一列
alter table person drop column phone;

-- 查询
select * from person;

-- 添加一条记录
insert into person (pid,pname,sex) values (1,'小明','男');
commit;
-- 脏读 读取了还未提交的数据
-- 修改一条记录
update person set pname = '小马' where pid = 1;
commit;

-- 三个删除
delete from person;         -- 删除表中全部记录
drop table person;          -- 删除表结构
truncate table person;      -- 先删除表，再创建表。效果等同于删除表中全部记录
                            -- 在数据量大的情况下，尤其在表中带有索引的情况下，该操作效率高
-- 索引可以提高查询效率，但是会影响 增删改效率                                

-- 序列不真的属于任何一张表，但是可以逻辑和表做绑定
-- 序列：默认从1开始，一次递增
-- dual: 虚表，只是为了补全语句，没有任何意义
create sequence s_person;
-- .nextval 查询下一个
-- .currval 查询当前一个
select s_person.currval from dual;

-- 添加一条记录
insert into person (pid,pname,sex) values (s_person.nextval,'小紫','女')
```

## Oracle数据类型[应用]

| No   | 数据类型         | 描述                                                    |
| ---- | ---------------- | ------------------------------------------------------- |
| 1    | Varchar,varchar2 | 表示一个字符串                                          |
| 2    | NUMBER           | NUMBER(n)表示一个整数，长度是n                          |
|      |                  | NUMBER(m,n) 表示一个小数，总长度是m，小数是n，整数是m-n |
| 3    | DATE             | 表示日期类型                                            |
| 4    | CLOB             | 大对象，表示大文本数据类型，可存4G                      |
| 5    | BLOB             | 大对象，表示二进制数据，可存4G                          |

```sql
-- scott 用户，密码 tiger
-- 解锁scott 用户
alter user scott account unlock;
-- 解锁 scott 用户的密码
alter user scott identified by tiger;
-- 切换到 scott 用户

-- 单行函数：作用与一行，返回一个值
-- 字符函数
select upper('yes') from dual; --yes
select lower('yes') from dual; --yes
-- 数值函数
select round(26.18,-1) from dual; --  四舍五入，后面的参数表示保留的小数
select trunc(56.18,1) from dual;  --  直接截取，不再看后面位数的数字是否舍入
select mod(10,3) from dual;       --  求余数
-- 日期函数
-- 查询出emp表中所有员工入职距离现在有几天
select sysdate-e.hiredate from emp e;
-- 算出明天此刻
select sysdate+1 from dual;
-- 查询出emp表中所有员工入职距离现在有几个月
select months_between(sysdate,e.hiredate) from emp e;
-- 查询出emp表中所有员工入职距离现在有几个年
select months_between(sysdate,e.hiredate)/12 from emp e;
-- 查询出emp表中所有员工入职距离现在有几个星期
select round((sysdate-e.hiredate)/7,2) ms from emp e;

-- 转换函数
-- 日期转字符串
select to_char(sysdate,'fm yyyy-mm-dd hh24:mi:ss') from dual;
-- 字符串转日期
select to_date('2020-5-17 11:56:51','yyyy-mm-dd hh:mi:ss') from dual;

-- 通用函数
-- 算出 emp 表中所有员工的年薪
-- 奖金里面有null 值，如果null 值和任意数字做运算，结果都是null
select ename,e.sal*12+nvl(e.comm,0) from emp e;

-- 条件表达式
-- 条件表达式的通用写法，mysql 和 oracle 通用
-- 给emp表中员工起中文名
select e.ename,
       case e.ename
            when 'SMITH' then '曹贼'
                when 'ALLEN' then '大耳贼'
                    when 'WARD' then '诸葛小儿'
                        -- else '无名'
                            end
from emp e;
-- 判断emp表中员工工资，如果高于3000显示高收入，如果高于1500 低于 3000 显示中收入 其余显示低收入
select e.ename,e.sal,
       case 
            when e.sal>3000 then '高收入'
                when e.sal>1500 then '中等收入'
                         else '低收入'
                            end ems
from emp e;
-- oracle 中除了起别别名，都用单引号。  起别名，要么不加引号，要加就加双引号
-- oracle 专用条件表达式：
select e.ename,
        decode(e.ename,
             'SMITH' , '曹贼',
                 'ALLEN' , '大耳贼',
                     'WARD' , '诸葛小儿') "中文名"
from emp e;


-- 多行函数【聚合函数】：作用于多行，返回一个值
select count(1) from emp; -- 查询总数量
select sum(sal) from emp; -- 工资总和
select max(sal) from emp; -- 最大工资
select min(sal) from emp; -- 最低工资
select avg(sal) from emp; -- 平均工作

-- 分组查询
-- 查询出每个部分的平均工资
-- 分组查询中，出现在 group by 后面的原始列，才能出现在select后面
-- 没有出现在group by后面的列，想在select后面，必须加上聚合函数。
-- 聚合函数有一个特性，可以把多行记录变成一个值。
select e.deptno,avg(e.sal) -- ,e.ename
from emp e 
group by e.deptno;
-- 查询出平均工资高于2000的部门信息
select  e.deptno,avg(e.sal) asal
from emp e
group by e.deptno
having avg(e.sal)>2000;
-- 所有条件都不能使用别名来判断
select ename,sal a from emp where sal>1500;

-- 多表查询中的一些概念
-- 笛卡尔积
select * 
from emp e,dept d;
-- 等值连接
select  *
from emp e,dept d
where e.deptno=d.deptno;
-- 内连接
select *
from emp e inner join dept d
on e.deptno = d.deptno;
-- 查询出所有部门，以及部门下的员工信息 【外连接】
select * 
from dept d left join emp e
on e.deptno=d.deptno;
-- oracle 中专用的外连接
select *
from emp e,dept d
where e.deptno(+) = d.deptno;


select * from emp;

-- 查询出员工姓名，员工领导姓名
-- 自连接
select e1.ename,e2.ename
from emp e1,emp e2
where e1.mgr = e2.empno;
-- 查询出员工姓名，员工部门名称，员工领导姓名
select e1.ename, d1.dname, e2.ename,d2.dname
from emp e1, emp e2, dept d1,dept d2
where e1.mgr = e2.empno
and e1.deptno=d1.deptno
and e2.deptno = d2.deptno;

-- 子查询
-- 子查询返回一个值
-- 查询出工资和SCOTT 一样的员工信息
select * from emp where sal =
(select sal from emp where ename ='SCOTT');
-- 子查询返回一个集合
-- 查询出工资和10号部门任意员工一样的员工信息
select * from emp where sal in
(select sal from emp where deptno = 10);
-- 子查询返回一张表
-- 查询出每个部门最低工资，和最低工资员工姓名，和该员工所在部门名称
-- 先查询出每个部门最低工资
select deptno,min(sal) msal
from emp
group by deptno;
-- 三表联查，得到最终结果
select t.deptno,t.msal,e.ename,d.dname
from   (select deptno,min(sal) msal
from emp
group by deptno) t, emp e, dept d
where t.deptno = e.deptno
and t.msal = e.sal
and e.deptno = d.deptno;

-- oralce 中的分页
-- rownum 行号：当我们做select 操作的时候，
-- 每查询出一行记录，就会在该行上加一行号
-- 行号从1开始，依次递增，不能调着走

-- 排序操作会影响rownum 的顺序
select rownum,e.* from emp e  order by e.sal desc;

select rownum,t.* from(
select rownum,e.* from emp e  order by e.sal desc) t;

-- emp 表工资倒序排列后，每页五条记录，查询第二页
-- rowun 行号不能写上大于一个正数
select * from(
select rownum rn,tt.* from
(select * from emp  order by sal desc)
tt where rownum<11 ) where rn>5

```

