> 创建于2021年10月8日
> 作者：xiang想

[toc]



### 请求资源带https

```html
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
```

添加此头文件，即可将所有 静态资源都转化为 https~

### 解决图片防盗链

```html
<meta name="referrer" content="no-referrer"/>
```

`referrer` 只能省略，不能修改，省略后服务端不校验，从而实现修复防盗链