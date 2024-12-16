## 四台服务器ssh互通

配置 hosts

```
192.168.58.195 mysql-01
192.168.58.196 mysql-02
192.168.58.197 mysql-03
192.168.58.198 mysql-mha
```

修改hosts-name

```sh
hostnamectl set-hostname mysql-01
```

做免密

```sh
ssh-keygen -t rsa
# 四台服务器分别执行
ssh-copy-id mysql-01
ssh-copy-id mysql-02
ssh-copy-id mysql-03
ssh-copy-id mysql-mha
```

时间同步

```sh
yum install -y ntpdate
# 同步阿里云时间
ntpdate -u ntp.aliyun.com

# 做定时任务 避免虚拟机挂起导致的延迟
crontab -e
* * * * * /usr/sbin/ntpdate -u ntp.aliyun.com > /dev/null 2>&1
```



## 下载工具

```
https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm
https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
```



### 安装 Node

> 4台服务器 都执行

**三台 MySQL 数据库需要安装 Node**

**MHA 需要安装 Manager 和 Node**

传输命令：`scp mha4mysql-node-0.58-0.el7.centos.noarch.rpm mysql-01:~/`

Node 依赖于 perl-DBD-MySQL 需要先安装

```sh
yum install -y perl-DBD-MySQL
```

确保4台服务器上都有 `yum install -y perl-DBD-MySQL` （安装很快）

```sh
[root@mysql-01 ~]# rpm -ivh mha4mysql-node-0.58-0.el7.centos.noarch.rpm
准备中...                          ################################# [100%]
正在升级/安装...
   1:mha4mysql-node-0.58-0.el7.centos ################################# [100%]
```

### 安装 Manager

Manager 依赖的东西蛮多，我们挨个下载并安装

```sh
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch perl-Parallel-ForkManager -y
# 之前下载好了得
rpm -ivh mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
```

> 提示：由于perl-Log-Dispatch和perl-Parallel-ForkManager这两个被依赖包在yum仓库找不到，因此安装epel-release-latest-7.noarch.rpm。在使用时，可能会出现下面异常：**Cannot retrieve metalink for repository: epel/x86_64**。可以尝试使用/etc/yum.repos.d/epel.repo，然后注释掉metalink，取消注释baseurl。



## MHA 配置

MHA Manager 服务器需要为每个监控的 Master 、Slave 集群提供一个专用的配置文件，而所有的 Master、 Slave 集群也可以共享全局配置

```sh
#目录说明 #/var/log (CentOS目录) 
# 	/mha (MHA监控根目录) 
# 		/app1 (MHA监控实例根目录)
# 			/manager.log (MHA监控实例日志文件)
mkdir -p /var/log/mha/app1
touch /var/log/mha/app1/manager.log
```

配置监控全局配置文件

`vi /etc/masterha_default.cnf`

```properties
[server default]
#主库用户名，在master mysql的主库执行下列命令建一个新用户
#create user 'mha'@'%' identified by '123456';
#grant all on *.* to mha@'%' identified by '123456';
#flush privileges;
user=mha
password=123456
port=3306
#ssh登录账号
ssh_user=root
#从库复制账号和密码
repl_user=root
repl_password=123456
port=3306 
#ping次数
ping_interval=1
#二次检查的主机
secondary_check_script=masterha_secondary_check -s mysql-01 -s mysql-02 -s mysql-03
```

配置监控实例配置

```sh
mkdir -p /etc/mha
vi /etc/mha/app1.cnf
```

`app1.cnf`

```properties
[server default]
#MHA监控实例根目录
manager_workdir=/var/log/mha/app1
#MHA监控实例日志文件
manager_log=/var/log/mha/app1/manager.log
#[serverx] 服务器编号
#hostname 主机名
#candidate_master 可以做主库
#master_binlog_dir binlog日志文件目录

[server1]
hostname=mysql-01
candidate_master=1
master_binlog_dir="/var/lib/mysql"

[server2]
hostname=mysql-02
candidate_master=1
master_binlog_dir="/var/lib/mysql"

[server3]
hostname=mysql-03
candidate_master=1
master_binlog_dir="/var/lib/mysql"
```

### 测试

测试 SSH 连通性，在 MHA 服务器上执行

```sh
masterha_check_ssh --conf=/etc/mha/app1.cnf
```

![image-20230811162141112](images/3%E3%80%81MHA%E9%AB%98%E5%8F%AF%E7%94%A8%E6%90%AD%E5%BB%BA/image-20230811162141112.png)

测试主从复制

```sh
masterha_check_repl --conf=/etc/mha/app1.cnf
```

![image-20230811162305505](images/3%E3%80%81MHA%E9%AB%98%E5%8F%AF%E7%94%A8%E6%90%AD%E5%BB%BA/image-20230811162305505.png)

最后一句出现了：**MySQL Replication Health is  OK!**  就OK啦

> 像我这样，最后发生了个 Not OK ，去主库执行一下，重新执行一边就ok了
>
> ```sh
> mysql> reset slave all;
> Query OK, 0 rows affected (0.01 sec)
> ```

### 启动监控

```sh
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &
```

查看监控状态

```sh
masterha_check_status --conf=/etc/mha/app1.cnf
```

查看日志

```sh
tail -f /var/log/mha/app1/manager.log
```

手动切换主从节点（运维）

```sh
masterha_master_switch --conf=/etc/mha/app1.cnf --master_state=alive --new_master_host=mysql-02 --orig_master_is_new_slave
```















### 配置邮件脚本

`/etc/mha/send_mail.sh`

```sh
#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use Mail::Sender;
use Getopt::Long;
 
#new_master_host and new_slave_hosts are set only when recovering master succeeded
my ( $dead_master_host, $new_master_host, $new_slave_hosts, $subject, $body );
 
my $smtp='smtp.163.com';
my $mail_from='array_xiangxiang@163.com';
my $mail_user='array_xiangxiang@163.com';
my $mail_pass='CUKITZKHAIEZUCPA';
#my $mail_to=['xxx@qq.com'];
my $mail_to='1850697175@qq.com';
 
GetOptions(
  'orig_master_host=s' => \$dead_master_host,
  'new_master_host=s'  => \$new_master_host,
  'new_slave_hosts=s'  => \$new_slave_hosts,
  'subject=s'          => \$subject,
  'body=s'             => \$body,
);
 
# Do whatever you want here
mailToContacts($smtp,$mail_from,$mail_user,$mail_pass,$mail_to,$subject,$body);
 
sub mailToContacts {
        my ($smtp, $mail_from, $mail_user, $mail_pass, $mail_to, $subject, $msg ) = @_;
        open my $DEBUG, ">/var/log/mha/app1/mail.log"
                or die "Can't open the debug    file:$!\n";
        my $sender = new Mail::Sender {
                ctype           => 'text/plain;charset=utf-8',
                encoding        => 'utf-8',
                smtp            => $smtp,
                from            => $mail_from,
                auth            => 'LOGIN',
                TLS_allowed     => '0',
                authid          => $mail_user,
                authpwd         => $mail_pass,
                to              => $mail_to,
                subject         => $subject,
                debug           => $DEBUG
        };
        $sender->MailMsg(
                {
                        msg => $msg,
                        debug => $DEBUG
                }
        ) or print $Mail::Sender::Error;
        return 1;
}
 
exit 0;
```

`app1.cnf`

```sh
report_script=/etc/mha/send_mail.sh
```

