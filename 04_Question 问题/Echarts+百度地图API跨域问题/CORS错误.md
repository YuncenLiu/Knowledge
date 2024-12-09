> 创建于2022年5月16日

​		在使用 Echarts+百度地图API时，出现了 CORS 错误

![image-20220516105716259](images/image-20220516105716259.png)

查证后发现 CORS 其实就是跨域错误

解决办法：

使用谷歌浏览器访问

```url
chrome://flags/#block-insecure-private-network-requests
```

![image-20220516105827391](images/image-20220516105827391.png)

重启浏览器访问后，修复CORS问题