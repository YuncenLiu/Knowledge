## WebLogic 访问地址

一般端口为 7001 端口尾缀带 `/console/login/LoginForm.jsp`  即可访问控制台



### 启动命令

通过查找 `stopWebLogic.sh` 命令所在位置

一般上下文路径为：`weblogic/domains/xxx/bin/stopWebLogic.sh`

启动形式为 前台启动，需要后台运行，例如

```sh
sh /data/weblogic/domains/kunlunwls-report/bin/startWebLogic.sh > /data/weblogic/domains/kunlunwls-report/bin/nohup.out 2>&1 &
```



### 停止命令

运行 stopWeblogic.sh

```sh
/data/weblogic/domains/kunlunwls-report/bin/stopWebLogic.sh
```

也可以暴力停止



## 忘记密码重置密码

### 1.备份

备份项目，一般备份 domains 下的项目例如  

```sh
cp -r /data/weblogic/domains/xxx  /data/back/xxx_time
```

### 2.项目运行状态下初始化密码

一定要在系统运行状态下执行

```sh
java -classpath /data/weblogic/Middleware/wlserver_10.3/server/lib/weblogic.jar weblogic.security.utils.AdminAccount  weblogic WebLogic2024 .
```

> 不建议用符号，因为会报错

会生成 DefaultAuthenticatorInit.ldift 文件，这个文件在命令执行地方生成

### 3.停机

修改  /boot.properties，修改是密文状态，会在第一次系统启动后，将明文加密

```sh
/data/weblogic/domains/kunlunwls-report/servers/AdminServer/security/boot.properties

username=weblogic
password=WebLogic2024
```

保持和上面的命令一致



### 4.启动

