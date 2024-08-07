

## Ping 服务器端口

```sh
nc -vz -w 2 [ip] [port]
```

> nc -vz -w 2 192.144.233.95 3388



## 刷新DNS命令

> 来源 [CSND](https://blog.csdn.net/allway2/article/details/106251981/)

```sh
sudo killall -HUP mDNSResponder
```

