### 服务器作用

+ 部署项目
+ 需要保持长时间的运行

> 任务1： 安装windows 镜像，下载QQ 并登陆

### 打开Linux

+ 方式
     + Xshell
     + 官网


## Linux 相关命令



### linux 根目录文件

bin 		作为基础系统所需要的最基础的命令就放在这里

boot		引导程序将内核加载到内存里

dev		设备文件目录，加载磁盘、键盘、鼠标、网卡驱动

etc 		全局的配置文件

+ passwd 放了用户名、密码
+ fstab 启动需要自动安装的文件系统列表
+ group  组的信息，各种数据，类似于 passwd
+ inittab    初始化的 init 配置文件

home 	 家目录，用户之间的配置文件，定制文档，数据等

lib		共享库 和 windows的  System32 目录差不多

media 	挂载媒体设备  u盘插进去，数据就会在这里的 disk文件下面

mnt		临时目录，设备光驱，

opt		安装包、放这里

root       管理员的家

sys		系统文件



## 命令

> find 查询    【 路径 相关命令  参数】

==查询文件名==

find /  -name bin			查询   根目录（下面）  文件名 （为）  bin

find . -name bin               查询   当前目录     文件名（为）   bin

==按时间查询==

find / -mtime 0    		  查询  根目录  最近 0+（1）天 修改过的文件 

==按权限来查==

find /  -perm  0777     查询 根目录  权限（为）   0777 的所有文件

> ls 展示文件内容 【相关命令】

-a          全部文档，包括开头的`. ` 连同隐藏文件也显示

-A         全部文档，包括隐藏文件

-l           文档属性

-R         连同字目录一起列出来

-S		 以档案容量大小排序

-t 		依时间排序

> cd 切换 【路径】

cd /    											切换到根目录

cd /www/server/tomact			切换到tomcat

cd ../ 												返回上一级

> tree 树形目录结构   （不是linux自带）

+ 下载：

```
wget http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz
```

+ 解压

```
tar zxvf tree-1.7.0.tgz
```

+ 进入目录，安装

```
cd tree-1.7.0
make
```

+ 放到bin目录下

```
cp tree /bin
```

==tree 【路径】==      例如:                  tree /     

> cp 复制 【-相关命令   路径A  路径B】

-a      把文件的属性也一起复制

-i       如果目的地有相同文件，者提示是否继续，如果没有，直接复制过去

-r      复制文件夹

-u      目标文件与源文件有差异的时候才复制

> rm 删除 【-相关命令 路径】

==要非常小心==

-f     不出现警告删除

-r    删除文件夹

> mv  移动文件夹 【-相关命令  路径A  路径B】

-f     不出现警告，如果原来文件存在，直接覆盖（强制性）

-i	  如果文件存在，会询问

-u     只有改动了，才会更新

> pwd 显示当前路径

> tar 解压命令  【-相关命令  路径】

tar zxvf 				 解压

> mkdir  创建文件夹  【-相关路径  目录】

mkdir -m 【权限】 -p  【文件夹名】

mddir -m 777 -p 123    在当前路径下创建名‘123’的文件夹



### 部署

##### 1、war包

把war包丢进tomcat 服务器路径下的webapps 里，自动解压

访问 http:// [服务器ip] ：[tomcat端口号]/[war包文件名]

##### 2、文件方式

把 index.jsp、WEB-INF、META-INF 这类文件的文件夹上传到服务器

##### 3、执行jar包的方式

打成jar包，在宝塔终端执行  java -jar 即可部署项目 （不推荐，毕竟没有tomcat稳定，服务器不稳定下，jar 包就会崩）