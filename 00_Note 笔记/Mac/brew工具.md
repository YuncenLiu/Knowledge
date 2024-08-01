> 创建于2021年10月8日
> 作者：想想

[toc]



## brew是什么

官网地址：[Homebrew](https://brew.sh/index_zh-cn)

Linux 系统有，yum包管理器，针对Mac系统，量身定制打造的 brew 工具

### Mac 环境如何安装

```sh
~/.zshrc -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```



#### Linux 环境如何安装

```sh
/bin/bash -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```



## 关闭 Nginx 服务

```sh
xiang@xiaocencen ~ % sudo brew services stop nginx
Stopping `nginx`... (might take a while)
==> Successfully stopped `nginx` (label: homebrew.mxcl.nginx)
```





```sh
//查看brew的版本
brew -v

//更新homebrew自己，把所有的Formula目录更新，并且会对本机已经安装并有更新的软件用*标明
brew update

//查看命令帮助：
brew -help

//查看那些已安装的程序需要更新
brew outdated

//更新单个软件：
brew upgrade [包名]
例：brew upgrade git

//更新所有软件：
brew upgrade 

//安装软件
brew install [包名]@版本
例：brew install git

//卸载
brew uninstall [包名]
例：brew uninstall git

//清理所有包的旧版本 （安装包缓存）
brew cleanup 
例：brew cleanup -n  //显示要删除的内容，但不要实际删除任何内容
例：brew cleanup -s  //清理缓存，包括下载即使是最新的版本
例：brew cleanup --prune=1     //删除所有早于指定时间的缓存文件（天）

//清理单个软件旧版本
brew cleanup [包名]
例：brew cleanup git 

//查看需要更新的包
brew outdated

//查看可清理的旧版本包，不执行实际操作
brew cleanup -n 

//锁定某个包
brew pin $FORMULA  

//取消锁定
brew unpin $FORMULA  

//查看包信息
brew info [包名]
例:brew info git

//查看安装列表
brew list

//查询可用包
brew search [包名]
例：brew search git

//显示包依赖
brew deps [包名]
例: brew deps git

```

