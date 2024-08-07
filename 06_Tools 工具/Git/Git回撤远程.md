

## Git 回撤远程记录



切换到 main 分支

```sh
git checkout master
```

回退 3个 commit

```sh
git reset HEAD~5
```



`--force-with-lease` 命令将本地仓库当前版本强制推送到远程仓库

```sh
git push --force-with-lease origin main
```



如果出现无法推送情况，查看是否分支受保护无法强制推送

