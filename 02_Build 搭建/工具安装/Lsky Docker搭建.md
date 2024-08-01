> 参考：https://blog.csdn.net/qq_24583853/article/details/127268142



```shell
docker run -d 
	--name lsky 
	--restart unless-stopped 
	-p 8790:80 
	-v /root/docker/lsky:/var/www/html
	itwxe/lskypro:2.0.4
```

```sh
docker run -d --name lsky -p 8790:80 -v /root/docker/lsky:/var/www/html 	itwxe/lskypro:2.0.4
```

