maven 高级应用：

1） maven 基础回顾

2）maven 传统的 web 工程做一个数据查询查询

3）maven 工程拆分与聚合的思想    ==重要==

4)   把第二阶段做到的 web 工程修改成 maven 拆分与聚合的形式

5） 私服【远程仓库】。

6） 如何安装 第三方 jar 包。【把第三方jar包安装到本地仓库，把第三方jar包安装到私服】

```shell
mvn install:install-file -Dfile=east.jar -DgroupId=test.test -DartifactId=base-common-web -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar



mvn install:install-file 
-Dfile=east.jar 
-DgroupId=test.test 
-DartifactId=base-common-web 
-Dversion=0.0.1-SNAPSHOT 
-Dpackaging=jar 
-Dmaven.repo.local=D:\Program Files\repository

mvn install:install-file 
-Dfile=F:\work\project\east\east-manage\target\east.war 
-DgroupId=net.gbicc 
-DartifactId=base-common-web 
-Dversion=0.0.1-SNAPSHOT 
-Dpackaging=war
-Dmaven.repo.local=D:\Program Files\repository
```







## maven 基础知识的回顾

maven 是一个 项目管理工具。

+ 依赖管理：maven 对项目中 jar  包的管理过程。传统工程把 jar 包放在项目中
     			 	  maven 工程真正的 jar 包放置在仓库中，项目中只用放置 jar 包的坐标

     + 仓库的种类：

          + 本地仓库
          + 远程仓库【私服】
          + 中央仓库

          仓库之间的关系：

          + 当我们启动一个 maven 工程的时候，maven 工程会通过 pom 文件中 jar 包的坐标去本地仓库找对应 jar 包
          + 默认情况下，如果本地仓库没有对应 jar 包，maven 工程会自动去中央仓库下载 jar 包到本地仓库
          + 在公司中，如果本地没有对应 jar 包，会先从 私服 jar 包
          + 如果私服没有 jar 包，可以从中央仓库下载，也可以从本地上次

+ 一键构建：maven 自身继承了 tomcat 插件，可以对项目进行编译，测试，打包，安装，发布操作
     + maven常用命令
          + clean 、compile、test、package、install、deploy。
     + maven 三套生命周期
          + 清理生命周期， 默认生命周期， 站点生命周期



| 直接依赖\传递依赖 | compile  | provided | runtime  | test |
| ----------------- | -------- | -------- | -------- | ---- |
| compile           | compile  | -        | runtime  | -    |
| provided          | provided | provided | provided | -    |
| runtime           | runtime  | -        | runtime  | -    |
| test              | test     | -        | test     | -    |

实际开发中，如果依赖丢失，表现形式就是jar包的坐标导不进去，我们的做法就是再导一次



## 安装私服

卸载，cmd 管理员身份 进入到 nexus bin目录下， `nexus.bat uninstall`

安装  一样，  `nexus.bat install` 

启动 	`nexus.bat start`

