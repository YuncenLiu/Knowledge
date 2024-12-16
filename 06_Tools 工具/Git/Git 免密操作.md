

### 服务器每次下拉代码都要输入密码

解决办法：

```sh
git config --global credential.helper store
```

执行一遍后，再拉一次代码，以后就不用一直输入了

![image-20220226132953476](images/image-20220226132953476.png)



相关文章：

https://www.cnblogs.com/flyingsir/p/17677133.html