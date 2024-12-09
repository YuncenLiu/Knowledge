> 创建于 2021年11月7日
> 作者：想想

[toc]



## sudo取消sudo 密码

给文件赋予写权限

```
chmod +w /etc/sudoers
```



需要 root 权限操作

```sh
vi /etc/sudoers
```

在倒数几行，可以看到类似于这种结构的配置

```
root    ALL=(ALL)       ALL
...
%wheel ALL=(ALL)       ALL
```

`%` 代表组  

我现在需要让我的另外一个用户 `Xiang`  在使用sudo的时候不需要输入密码，这时，可以这样配置

```
%xiang ALL = (ALL)NOPASSWD:ALL
```


这样，保存即可有效