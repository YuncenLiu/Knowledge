# 标准化 Linux 搭建

[toc]



### 1、初始化网络

修改 网络配置

```sh
vi /etc/sysconfig/network-scripts/ifcfg-ens33 
```



```sh
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none

DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=fce20d77-4f54-4352-a03c-2fce19243003
DEVICE=ens33
ONBOOT=yes

IPADDR=192.168.58.3
PREFIX=24
GATEWAY=192.168.58.2
NETMASK=255.255.255.0
DNS1=119.29.29.29
DNS2=8.8.8.8
```

重启网络

```sh
systemctl restart network
```



### 2、此时可以用 CRT、XShell 工具进行连接

### 3、测试链接网络

```sh
ping baidu.com
```

### 4、设置 yum 源头

备份

```sh
mv /etc/yum.repos.d /etc/yum.repos.d.backup
```

设置新目录

```sh
mkdir -p /etc/yum.repos.d 
```

下载阿里yum配置到该目录中，选择对应版本 

```sh
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo 
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

重建缓存 

```sh
yum clean all 
yum makecache
```

更新源（时间比较长 大概10分钟）

```sh
yum -y update
```

### 5、基础配置

关闭防火墙

```sh
systemctl stop firewalld
systemctl disable firewalld

systemctl stop --now firewalld  # 等同于上面两个命令
```

关闭 selinux

```sh
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0
```

网络桥段

```sh
vi /etc/sysctl.conf

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.ipv4.ip_forward=1
net.ipv4.ip_forward_use_pmtu = 0

# 生效命令
sysctl --system 

# 查看效果
sysctl -a|grep "ip_forward"
```

开启 IPVS

```sh
# 安装IPVS
yum -y install ipvsadm ipset sysstat conntrack libseccomp

# 编译ipvs.modules文件
vi /etc/sysconfig/modules/ipvs.modules

# 文件内容如下 
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack

# 赋予权限并执行
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules &&lsmod | grep -e ip_vs -e  nf_conntrack

# 重启电脑，检查是否生效
reboot
lsmod | grep ip_vs_rr
```



同步时间

```sh
# 安装软件
yum -y install ntpdate

# 向阿里云服务器同步时间
ntpdate time1.aliyun.com

# 删除本地时间并设置时区为上海
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

crontab -e

0 */1 * * * ntpdate time1.aliyun.com

# 查看时间
date -R || date
```

命令补全

```sh
# 安装bash-completion
yum -y install bash-completion bash-completion-extras

# 使用bash-completion
source /etc/profile.d/bash_completion.sh
```

关闭 swap 分区

```sh
# 临时关闭： 
swapoff -a

# 永久关闭：
vi /etc/fstab

# 将文件中的/dev/mapper/centos-swap这行代码注释掉
#/dev/mapper/centos-swap swap swap defaults 0 0 

# 确认swap已经关闭：若swap行都显示 0 则表示关闭成功
free -m
```



### 6、升级内核

从百度网盘下载 安装资源 > Linux > Kernel

```sh
-rw-r--r--. 1 root root 71885940 Jan  7 15:46 kernel-ml-6.9.7-1.el7.elrepo.x86_64.rpm
-rw-r--r--. 1 root root 16151996 Jan  7 15:46 kernel-ml-devel-6.9.7-1.el7.elrepo.x86_64.rpm
-rw-r--r--. 1 root root  1823400 Jan  7 15:46 kernel-ml-headers-6.9.7-1.el7.elrepo.x86_64.rpm
```

执行

```sh
rpm -ih kernel-ml-6.9.7-1.el7.elrepo.x86_64.rpm

rpm -ih kernel-ml-devel-6.9.7-1.el7.elrepo.x86_64.rpm
```

查看安装的内核版本

```sh
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
```

设置为最新版本

```sh
grub2-set-default 0
```

生成 grub 配置文件

```sh
grub2-mkconfig -o /boot/grub2/grub.cfg
```

重启

```sh
reboot
```

卸载旧内核

```sh
yum remove -y kernel-headers
```

最后安装，重启后需要重新进入到对应目录

```sh
rpm -ih kernel-ml-headers-6.9.7-1.el7.elrepo.x86_64.rpm
```

把删除的依赖重新安装回来

```sh
yum install -y gcc glibc-devel glibc-headers
```



### 7、修改 Vim 编辑器

将文件放在 ~/.vimrc 文件中，如果报错，用编辑器改成   LF 再上传

```sh
set tabstop=4
set backspace=2
set shiftwidth=4
set softtabstop=4
set noexpandtab
set nowrap
set nu
syntax on                       " 语法高亮
set ruler                       " 显示标尺
set showcmd                     " 输入的命令显示出来，看的清楚些
set cmdheight=1                 " 命令行（在状态行下）的高度，设置为1
set scrolloff=3                 " 光标移动到buffer的顶部和底部时保持3行距离
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   " 状态行显示的内容
set laststatus=2                " 启动显示状态行(1),总是显示状态行(2)
set nocompatible                " 去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
 
" 设置当文件被改动时自动载入
set autoread
" 代码补全
set completeopt=preview,menu
" 突出显示当前行
set cursorline
" 在处理未保存或只读文件的时候，弹出确认
set confirm
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
au BufRead,BufNewFile *  setfiletype txt
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call SetTitle()"
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G
""定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\#    File Name: ".expand("%"))
        call append(line(".")+1, "\#    Author: eight")
        call append(line(".")+2, "\#    Mail: 18847097110@163.com ")
        call append(line(".")+3, "\#    Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "RED='\\E[1;31m'")
        call append(line(".")+7, "GREEN='\\E[1;32m'")
        call append(line(".")+8, "RES='\\E[0m'")
        call append(line(".")+9, "")
    endif
    if &filetype == 'python'
        call setline(1,"\#########################################################################")
        call append(line("."), "\#    File Name: ".expand("%"))
        call append(line(".")+1, "\#    Author: eight")
        call append(line(".")+2, "\#    Mail: 18847097110@163.com ")
        call append(line(".")+3, "\#    Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/usr/bin/env python")
        call append(line(".")+6, "\# -*- coding: utf-8 -*-")
        call append(line(".")+7, "")
    endif
endfunc
 
 
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口
let Tlist_Compart_Format = 1    " 压缩方式
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer
let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags
let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树
let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags
set tags=tags
"set autochdir
```



### 8、SSH 连接慢

快速替换

```sh
sudo sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
```

重启

```sh
systemctl restart sshd
```



