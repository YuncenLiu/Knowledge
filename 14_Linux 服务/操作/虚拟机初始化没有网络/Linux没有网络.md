> 创建于2022年8月29日

# Could not resolve host: mirrorlist.centos.org； Unknown error 的解决方法 

初始化的Linux服务器没有网络出现

![image-20220829220649495](images/Linux没有网络/image-20220829220649495.png)

**本机无法连接网络的网络设置**

## 解决方案

输入 `nmcli d`，`ens33` 处于 disconnected 状态

![image-20220829220922111](images/Linux没有网络/image-20220829220922111.png)

修改网卡配置

```sh
cd /etc/sysconfig/network-scripts
vi ifcfg-ens33
```

![image-20220829221138114](images/Linux没有网络/image-20220829221138114.png)

重启网络

```sh
systemctl restart network
```

重新查看网卡状态

![image-20220829221432919](images/Linux没有网络/image-20220829221432919.png)

```sh
ping www.baidu.com
```

![image-20220829222159410](images/Linux没有网络/image-20220829222159410.png)

大功告成