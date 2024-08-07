启动Docker

```sh
systemctl start docker
```

删除镜像（慎用）

```sh
docker rmi -f 镜像id   # 删除指定的镜像
docker rmi -f 镜像id  镜像id  镜像di  # 删除多个镜像
docker rmi -f $(docker images -aq)   # 删除全部镜像
```

以交互方式启动

```sh
docker run -it centos bash
```

删除容器

```sh
docker rm  容器id				# 删除指定镜像   不能删除正在运行的容器，如果要强制删除  rm -f
docker rm -f $(docker ps -aq)  # 删除所有容器
docker ps a -q|xargs rm			# 删除所有容器  （未尝试过）
```

停止容器

```sh
docker restart 容器id		# 重启容器
docker stop 容器id		# 停止当前正在运行的容器
docker kill 容器id		# 强制停止当前运行的容器
```

进入当前正在运行的容器

```sh
docker exec -it 【容器id】  bash
```

```sh
docker attach 【容器id】
```

启动命令

```sh
-d  		# 后台启动
-p  		# 暴露端口
-t  		# 日志
-it 		# 进入交互
--name   	# 别名

--privileged=true # 拥有真正的 root 权限

```

```sh
docker run -d --name nginx01 -p 3344:80 nginx
```



> docker 命令大全
>
> [这20个Docker Command，有几个是你会的？](https://mingongge.blog.csdn.net/article/details/80524241?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6.no_search_link&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7Edefault-6.no_search_link)

