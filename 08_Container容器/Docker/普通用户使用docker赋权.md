
## 检查Docker用户组

```sh
grep docker /etc/group
```

如果没有的话再创建 `groupadd docker`

给用户名 `xiang` 添加到组

```sh
usermod -aG docker xiang
```

添加完成后，需要对该账户重新登录操作， `bash` 没有
