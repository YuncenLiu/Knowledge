> 创建于2021年10月10日
> 作者：想想
>
> [docker.hub](https://hub.docker.com/_/nginx?tab=description)

[toc]



### 下拉

`docker pull nginx`

```sh
[root@Xiang nginx-1.6.2]# docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
07aded7c29c6: Pull complete 
bbe0b7acc89c: Pull complete 
44ac32b0bba8: Pull complete 
91d6e3e593db: Pull complete 
8700267f2376: Pull complete 
4ce73aa6e9b0: Pull complete 
Digest: sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
```



运行：

```sh
docker run -d -p 80:80 
--name nginx 
-v /Users/xiang/xiang/docker/nginx/www:/usr/share/nginx/html 
-v /Users/xiang/xiang/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf 
-v /Users/xiang/xiang/docker/nginx/logs:/var/log/nginx 
nginx 
f8f4ffc8092c


docker run -d -p 80:80 --name nginx --net host 
-v /Users/xiang/xiang/docker/nginx/www:/usr/share/nginx/html 
-v /Users/xiang/xiang/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf 
-v /Users/xiang/xiang/docker/nginx/logs:/var/log/nginx 
nginx
```



```sh
docker run -d -p 80:80 --name nginx -v /Users/xiang/xiang/docker/nginx/www:/usr/share/nginx/html -v /Users/xiang/xiang/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /Users/xiang/xiang/docker/nginx/logs:/var/log/nginx f8f4ffc8092c



docker run -d -p 80:80 --name nginx --net host -v /Users/xiang/xiang/docker/nginx/www:/usr/share/nginx/html -v /Users/xiang/xiang/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf  f8f4ffc8092c
```

本地路径：/Users/xiang/xiang/docker/nginx

