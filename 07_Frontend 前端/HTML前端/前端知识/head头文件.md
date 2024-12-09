> 创建于2021年10月8日
> 作者：xiang想

[toc]



### 请求资源带https

```html
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
```

添加此头文件，即可将所有 静态资源都转化为 https~





### 解决防盗链问题

有时候就是没办法从前端角度解决这个问题

就是用 Java 技术，获取图片数据，再转换成 二进制 base64 文件。