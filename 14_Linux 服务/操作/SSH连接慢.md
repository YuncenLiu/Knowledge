## SSH连接慢

```sh
vim /etc/ssh/sshd_config
```

![image-20250107003400167](images/Untitled/image-20250107003400167.png)



快速替换

```sh
sudo sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
```





重启

```sh
systemctl restart sshd
```



