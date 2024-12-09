![image-20200712134602907](images/%E9%A1%B9%E7%9B%AE.png)

> 创建数据库
>
> ```sql
> create table airport(
> 	id int(10) primary key auto_increment,
> 	portname varchar(20),
> 	cityname varchar(20)
> )
> 
> INSERT into airport values(default,'首都机场','北京');
> INSERT into airport values(default,'南苑机场','北京');
> INSERT into airport values(default,'虹桥机场','上海');
> 
> CREATE TABLE airplane(
> 	id int(10) primary key auto_increment,
> 	airno varchar(20),
> 	time int(5) comment '单位分钟',
> 	price double,
> 	takeid int(10) comment '起飞机场',
> 	landid int(10) comment '降落机场'
> )
> 
> insert into airplane values(default,'播音747',123,100,1,3);
> insert into airplane values(default,'播音858',56,300,3,2);
> ```
>
> 

 ![image-20200712135449377](images/%E9%A1%B9%E7%9B%AE2.png)                                                                           ![image-20200712135550642](C:/Users/Array/AppData/Roaming/Typora/typora-user-images/image-20200712135550642.png)

> 项目  airplane