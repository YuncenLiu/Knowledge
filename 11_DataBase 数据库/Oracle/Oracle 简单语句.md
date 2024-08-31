### 1、PL / SQL

> PL / SQL 初始化模板

```sql
-- PL / SQL 可以直接通过 PL / SQL 完成简单的业务逻辑，具有编程语言语法结构
DECLARE 
		-- 例子
		DECLARE variable_name [constant] type [not null] [:=vales]
		-- 语法结构 ：变量名  [是否常量] 类型 [是否为空] [ 赋 值 ]
-- 声明变量 / 游标
BEGIN
-- 程序的开始
		-- 控制台输出
		dbms_output.put_line(v_s_id)
EXCEPTION
-- 异常处理
END;

-- 结束
```

举个栗子吧：

```sql
select * from student;
-- 简单的demo
DECLARE
	v_s_id NUMBER(11):=3;
BEGIN
	dbms_output.put_line(v_s_id+4);
END;
```

#### 1.1、变量名规范：

+ 变量名首字母必须是英文 ，其后可以是 数字、特殊符号 # 、 $ 、_(下划线)
+ 最大长度为 30

#### 1.2、%TYPE

调用 原表的字段类型

```sql
-- %TYPE
-- 变量名 表名.列名%TYPE 使用表中字段类型当做数据类型
DECLARE
	v_s_id STUDENT.S_ID%TYPE:=3;
	v_s_name STUDENT.S_NAME%TYPE;
BEGIN
	SELECT s_name into v_s_name FROM student WHERE s_id=v_s_id;
	dbms_output.put_line('s_name 为 3 的同学，姓名为：'|| v_s_name);
END;
```

#### 1.3、 %ROWTYPE 

调用 原表字段类型基础上，进行批量处理

```sql
-- %ROWTYPE 
-- 变量名 表名%ROWTYPE
DECLARE
	v_pro student%rowtype;
	v_s_id NUMBER(11):=3;
BEGIN
	SELECT s_id,s_name,s_sex
	into v_pro.s_id,v_pro.s_name,v_pro.s_sex
	FROM student where s_id = v_s_id;
	dbms_output.put_line('学生 id:'||v_pro.s_id);
	dbms_output.put_line('学生 name:'||v_pro.s_name);
	dbms_output.put_line('学生 sex:'||v_pro.s_sex);
END;
```

## 2、IF 结构

>```sql
>-- IF - ELSE 
>-- if 的语法结构 
>IF 条件 THen
>	执行 sql ;
> ELSE
>	执行 sql ;
>END IF;
>```

举个栗子 

```sql
-- 举个栗子:插入一名学生，如果一年级的人数小于4 则插入，否则插入到二年级中
DECLARE
	-- 变量 储存一年级的人数
	v_count NUMBER(11);
BEGIN
	-- 模拟 s_sex 为年级， 男为1年级   女为2年级
	SELECT COUNT(1) into v_count FROM STUDENT WHERE S_SEX='男';
	-- 判断人数是否小于 4 
	IF v_count<4 then
		INSERT INTO STUDENT(S_ID,S_NAME,S_BIRTH,S_SEX) 
		VALUES (9,'郝建',TO_DATE('1999-02-20', 'yyyy-mm-dd'),'男');
	ELSE
		INSERT INTO STUDENT(S_ID,S_NAME,S_BIRTH,S_SEX) 
		VALUES (9,'郝建',TO_DATE('1999-02-20', 'yyyy-mm-dd'),'女');
	END IF;
END;
```

>  ==简化==

```sql
-- 简化
DECLARE
	v_count NUMBER(11);
	v_sex student.S_SEX%TYPE;
BEGIN
	-- 模拟 s_sex 为年级， 男为1年级   女为2年级
	SELECT COUNT(1) into v_count FROM STUDENT WHERE S_SEX='男';
	-- 判断人数是否小于 4 
	IF v_count<4 then
		v_sex :='男';
	ELSE
		v_sex :='女';
	END IF;
		INSERT INTO STUDENT(S_ID,S_NAME,S_BIRTH,S_SEX) 
		VALUES (10,'郝帅',TO_DATE('1990-02-20', 'yyyy-mm-dd'),v_sex);
END;
```

> 题目     -- 计算语文成绩的平均分，如果平均分小于70，则认定此次考试过难，则语文成绩加10分     ==（下面是一大堆笔记，自己看吧）==

```sql
select avg(S_SCORE) ag from score where c_id = (select c_id from course where c_name='语文') group by score.s_id

select avg(ag) from 
(select avg(S_SCORE) ag from score where c_id = (select c_id from course where c_name='语文') group by score.s_id);

select * from score

-- 创建视图
create VIEW v_score as  select score.S_ID,avg(S_SCORE) ag from score where c_id = (select c_id from course where c_name='语文') group by score.s_id;
select * from V_score;

DECLARE
		avg_score SCORE.S_SCORE%TYPE;
		--s_add_score SCORE.S_SCORE%TYPE;
BEGIN
		select avg(ag) into avg_score FROM V_score;
		--SELECT S_SCORE  into s_add_score  from score;
	IF avg_score < 70 then
		update SCORE set S_SCORE = S_SCORE+10;
		dbms_output.put_line('太难了，所有科目加10分');
	ELSE
		dbms_output.put_line('语文平均分大于10分');
	END IF;
END;

select * from v_score
select * from SCORE;
update score set s_score = s_score-11;
update v_score set ag = ag+10;
--UPDATE V_EMP set job='good' where ename = 'ALLEN';


create view v_score as select s_id,s_score from score where c_id =1
select avg(s_score) from v_score

select * from v_score;
COMMENT；
-- 测试视图进行批量增加
update v_score set s_score = s_score+10
rollback;
```

























































