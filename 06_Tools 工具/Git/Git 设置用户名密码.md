> 创建于2021年11月10 日
> 作者：想想

[toc]



## 一、查看Git用户名及邮箱

```sh
git config user.name
```

```sh
git config user.email
```

## 二、设置 git 的user name 和 emial

```sh
git config --global user.name "xxx"
```

```sh
git config --global user.email "xxx@xxx.com"
```



## 三、生成 SSH 密钥过程

1. 查看是否已经 ssh 密钥：

```sh
cd ~/.ssh
```

如果没有则不会存在此文件夹，有则备份删除

2. 生成密钥

ssh-keygen -t rsa -C "邮箱"



### 四、永久保存 git 密码

```shell
git config --global credential.helper store
```

