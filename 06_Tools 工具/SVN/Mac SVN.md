### 安装 svn

```sh
brew install subversion
```



### 找到所有 .DS_Store 文件并删除

```sh
find . -name ".DS_Store" -print0 | xargs -0 svn delete --keep-local
```

### 直接使用 SVN 命令提交

```sh
svn commit -m "Removed .DS_Store files"
```

![image-20240923103606668](images/Mac%20SVN/image-20240923103606668.png)



