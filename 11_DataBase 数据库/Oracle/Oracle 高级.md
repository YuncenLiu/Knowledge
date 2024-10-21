## 行转列



```sql
SELECT *
FROM (
    SELECT column1, column2, column3
    FROM your_table
)
PIVOT (
    SUM(column3) -- 聚集操作
    FOR column2 IN ('值1' AS Value1, '值2' AS Value2, '值3' AS Value3) -- 多个列
) 
ORDER BY column1;
```







### 1、Oracle 分页

```sql

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
		(select * from emp)
	tt where rownum<11 ) aa
where rn>5

```

### 2、视图

```sql
-- 视图
-- 视图的概念：视图就是提供一个查询的窗口，所有数据来自于原表
-- 查询语句创建表
create table emp as select * from scott.emp;

drop table emp;
-- 创建视图【必须有 dba 权限】
CREATE VIEW V_EMP as SELECT ename,job from emp;
-- 查询视图 
SELECT * FROM V_EMP
-- 修改视图
UPDATE V_EMP set job='good' where ename = 'ALLEN';
COMMENT;
-- 修改视图也能修改数据

-- 创建只读视图
create view v_emp1 as select ename,job from emp with read only;
select * from V_EMP1
-- 只读视图不能修改
UPDATE V_EMP1 set job='good' where ename = 'ALLEN';

-- 视图的作用？
-- 第一：视图可以屏蔽掉一些敏感字段
-- 第二：保证总部和分部数据及时统一
```

```sql
-- oracle 中的分页
-- rownum 行号; 当我们做 seleect 操作的时候
-- 每次查询一行数据，就会在该行上加一个行号
-- 行号从1号开始，依次递增，不能跳着走
--- emp 表工资倒序排序后，每页五条数据，查询第二页

-- 排序操作会影响 rownum 的顺序

SELECT ROWNUM ,e.* FROM EMP e ORDER BY e.sal desc

-- 取前3条数据
select * from emp e where ROWNUM <4
-- 排序后 取前三条数据
SELECT ROWNUM,t.* FROM(
SELECT ROWNUM ,e.* FROM EMP e ORDER BY e.sal desc) t where ROWNUM < 4;


-- emp 表工资倒序排序后，每页五条记录，查询第二条
select ROWNUM,e.* from(
	SELECT * FROM emp  ORDER BY sal desc
) e where ROWNUM < 11 and ROWNUM > 5
-- 加 and 条件后，查询不到条件， 因为 rownum 不能跳着走，所以查询不到数据
-- rownum 行号不能写上大于一个正数
SELECT * from (
	select ROWNUM rn,e.* from(
		SELECT * FROM emp  ORDER BY sal desc
	) e where ROWNUM < 11 
)  where rn > 5
-- 死格式 --

-- 分页公式
-- rn > (pageindex-1)*pageSize AND rn <=(pageindex*pageSize)


-- 视图
-- 视图的概念：视图就是提供一个查询的窗口，所有数据来自于原表
-- 查询语句创建表
create table emp as select * from scott.emp;

drop table emp;
-- 创建视图【必须有 dba 权限】
CREATE VIEW V_EMP as SELECT ename,job from emp;
-- 查询视图 
SELECT * FROM V_EMP
-- 修改视图
UPDATE V_EMP set job='good' where ename = 'ALLEN';
COMMENT;
-- 修改视图也能修改数据

-- 创建只读视图
create view v_emp1 as select ename,job from emp with read only;
select * from V_EMP1
-- 只读视图不能修改
UPDATE V_EMP1 set job='good' where ename = 'ALLEN';

-- 视图的作用？
-- 第一：视图可以屏蔽掉一些敏感字段
-- 第二：保证总部和分部数据及时统一

-- 索引
-- 索引的概念，索引就是在表的列上构建一个二叉树
-- 达到大幅度提高查询效率的目的，但是索引会影响增删改的效率 ->  每一次增删改都会改变这个二叉树，导致重新构建二叉树而影响效率

-- 单列索引
create index idx_ename on emp(ename);
-- 单列 索引触发规则，条件必须是索引列中的原始值
select ename from emp;
-- 但行函数，模糊查询，都会影响索引的触发
select * from emp where ename='SCOTT';

-- 复合索引
create index idx_enamejon on emp(ename, job);
select ename,job from emp;
-- 符合索引，第一列是优先检索列，上面这个例子，优先检索列是  ename
-- 如果要触发符合索引，必须要包含优先检索列中的原始值
select * from emp where ename = 'SCOTT' and job = 'xx'  -- 这里触发复合索引

select * from emp where ename = 'SCOTT'  -- 这里触发的是单列索引

select * from emp where ename = 'SCOTT' or job = 'xx'  -- 这里不触发索引，or 关键字比较特殊，
																											--  or 进行了两个查询，一个 ename 触发，一个 job 不触发，那就是不触发
																											



-- 游标：可以存放多个对象，多行记录。    类似于java 中的集合
-- 具体使用：输出 emp 表所有员工的姓名
DECLARE
	-- 把 emp 表中的所有数据，全部放进游标中
	cursor c1 is select * from emp;
	emprow emp%rowtype;
BEGIN 
	open c1;
		loop
			fetch c1 into emprow;
			exit when c1%notfound;
			dbms_output.put_line(emprow.ename);
		end loop;
	close c1;
END;

-- 给指定部门员工涨工资

select * from emp where deptno = 10;

DECLARE
	cursor c2(eno emp.deptno%TYPE) 
	is select empno from emp where deptno = eno;
	en emp.empno%TYPE;
BEGIN
	open c2(10);
		LOOP
			fetch c2 into en;
			exit when c2%notfound;
			update emp set sal=sal+100 where EMPNO = en;
			commit;
		END LOOP;
	close c2;
END;


-- 存储过程：就是提前已经编译好的一段 pl/sql 语言，放置在数据库，可以直接被调用，这一段pl/sql 一般都是固定步骤的业务

-- 语法：
-- create [or replace] PROCEDURE 过程名 [(参数名 in/out 数据类型)]
-- AS
-- begin
-- 		PLSQL 执行sql;
-- END;

-- 给指定员工 涨 100 块钱
create  or replace procedure p6(eno emp.empno%TYPE)
is
BEGIN
	update emp set sal=sal+100 where empno=eno;
	commit;
end;
-- replace 当创建存储过程出现错误的时候，会报错   在保证业务过程没问题的时候，就不加or 一般都是 加or 的
-- or replace 即使存储过程出错也不报错
-- 什么也不加，错误条件下，也能创建成功，但是不可用

SELECT * from EMP WHERE EMPNO = 7788;

-- 测试 p1 
DECLARE

BEGIN
	P6(7788);
END;



-- 存储函数
-- 语法： 

-- create or replace function 函数名 (Name in type,Name in type,...) return 数据类型 is  结果变量 数据类型
-- begin
--  return (结果变量)
-- end 函数名;

-- 通过存储函数，实现计算指定员工的年薪                        number 不能带长度 ,要返回值类型，
create or replace FUNCTION p_good1(eno emp.empno%type) return number
is 
	s number(11);
BEGIN
	SELECT sal*12 + nvl(comm,0) into s FROM emp WHERE EMPNO = eno;
	DBMS_OUTPUT.PUT_LINE('返回值+'||s);
	return s;
end;

-- 测试
-- 存储函数在调用的时候，必须接受返回值
DECLARE 
	nnn NUMBER(10);
BEGIN
	nnn:=p_good1(7788);
	dbms_output.put_line(nnn);
END;

-- out 类型参数如何使用
-- 使用存储过程来算年薪 																				这里的类型也不能放长度
create or replace PROCEDURE p_yearsal2(eno in emp.empno%TYPE,yearsal out number)
is
		s number(10);
		c emp.comm%type;
BEGIN
	select sal*12,NVL(comm , 0) into s,c from emp where empno = eno;
	-- 设置返回值 
	yearsal := s+c;
	DBMS_OUTPUT.PUT_LINE('返回值+'||yearsal);
end;

-- 测试 p_yearsal
declare 
	year number(10);
BEGIN
	P_YEARSAL2(7788,year);
	DBMS_OUTPUT.PUT_LINE(year);
end;

-- in 和 ou类型参数的区别是什么？
-- 凡是涉及到 into 查询语句赋值或者 := 赋值操作的参数，都必须用 out 来修饰，否则其余的都用 in
-- create or replace PROCEDURE p_yearsal(eno in emp.empno%TYPE,yearsal out number)
-- 从上面的这个案例来看 ，eno 和 emp.empno 没有:= 赋值操作 我们可以不写 in 及时是写了，也不会报错
-- 如果 把in 改成 out 那就会在 测试的时候报错
-- 相同的 第二个 yearsal 参数，在 begin 里用到 := 赋值，我们如果把 out 改成 in 那就报错了



----------------- 存储过程 和 存储函数的区别 -----------------------------
-- 语法区别：关键字不一样

-- 存储函数  比 存储过程多了两个 return
-- 本质区别：
-- 1、存储函数有返回值 而 存储过程没有返回值
-- 2、如果存储过程想实现有返回值的业务，我们就必须要使用 out 类型的参数即便是存储过程使用 out 类型的参数，其本质也不是真的有了返回值，而是在存储过程内部给 out 类型参数赋值，再执行完毕后，我们直接拿到输出类型参数的值。

-- 我们可以使用存储函数有返回值的特性，来自定义函数，而存储过程不能用来自定义函数

-- 举个栗子
-- 查询出员工姓名、员工所在部门名称
		-- 准备工作：把 scott 用户下的 dept 表复制到当前用户下
		create table dept as select * from scott.dept;
		-- 准备完毕
select  e.ename 员工姓名,d.dname 部门名称
from emp e,dept d
where e.deptno = d.deptno

-- 使用存储函数来提供部门编号，输出部门名称

-- 查询一个员工所在的部门名称  先提供 员工

-- |  员工表    |    部门表 |
-- | 名字   id  |  id   名字|
create or replace function fdna(dno in dept.deptno%TYPE) return dept.dname%type
is
	dna dept.dname%TYPE;
begin
	select dname into dna from dept where deptno = dno;
	return dna;
end;

-- 使用 fdna 存储函数来实现案例需求  查询出员工姓名、员工所在部门名称
select e.ENAME 员工姓名,FDNA(e.deptno) 部门名称
from emp e;


------------------------  触发器  ------------------------
-- 触发器,就是制定一个规则，在我们做增删改操作的时候，
---- 只要满足规则，自动触发，无需调用
---- 语句级触发器：不包含有 for each row 的触发器
---- 行级触发器：包含有 for each row 的就是行级触发器

-- 加 for each row 是为了使用：old 或者：new 对象或者一行记录

-- |  触发语句  |  :old            |   :new         | 
-- |  Insert    | 所有字段都是空   | 将要插入的数据 |
-- |  Update    | 更新以前该行的值 | 更新后的值     |
-- |  delete    | 删除以前该行的值 | 所有字段都是空 |

select * from PERSON
---- 插入一条记录，输出一个新员工入职
create or replace trigger t1
after
insert
on person
declare
	
begin
	DBMS_OUTPUT.PUT_LINE('一个新员工入职');
end;9

insert into PERSON(PID,PNAME) VALUES(3,'张三');

-- 行级触发器
-- 举个栗子，  不能给员工降薪
create or replace trigger t3
before
update
on emp
for each row
declare
-- 只能加薪，不能减薪
BEGIN
	if :old.sal<:new.sal then
	
	else
			-- raise_application_error(-20001 ~ -29999 不能重复,'错误信息）'
			raise_application_error(-20002,'不能给员工降薪');
	end if;
end;

-- 触发 t2

update emp set sal = sal+100 where empno = 7788;

select * from emp where empno=7788

commit




create or replace trigger t3
before
update
on emp
for each row
declare
-- 只能加薪/，不能减薪
BEGIN
	if :old.sal<:new.sal then
	dbms_output.put_line('加薪成功');
		ELSE
			-- raise_application_error(-20001 ~ -29999 不能重复,'错误信息）'
			raise_application_error(-20002,'不能给员工降薪');
	end if;
end;


update emp set sal = sal+100 where empno = 7788;








```

