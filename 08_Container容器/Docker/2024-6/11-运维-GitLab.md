# 搭建 GitLab

官方：https://hub.docker.com/r/gitlab/gitlab-ce



基础镜像

官方：gitlab/gitlab-ce

汉化的 GitLab 社区版 Docker Image: twang2218/gitlab-ce-zh



讲师推荐：gitlab/gitlab-ce:12.7.6-ce.0

我使用的是：gitlab/gitlab-ce:17.7.0-ce.0



运行容器

```sh
docker run -itd --name gitlab -p 443:443 -p 80:80 -p 222:22 -m 4GB -v /data/gitlab/config:/etc/gitlab -v /data/gitlab/logs:/var/log/gitlab -v /data/gitlab/data:/var/opt/gitlab -e TZ=Asia/Shanghai  registry.cn-beijing.aliyuncs.com/yuncenliu/gitlab-ce:12.7.6-ce.0
```



配置 gitlab， `/conf/gitlab.rb`

```
# 配置项目地址
external_url 'http://192.168.111.120'

配置 ssh 协议所使用的访问地址和端口
gitlab_rails['gitlab_ssh_host'] = '192.168.111.120'
gitlab_rails['time_zone'] = 'Asia/Shanghai'
gitlab_rails['gitlab_shell_ssh_port'] = 222


# 17.7.0 版本
gitlab_rails['initial_root_password'] = "Gitlab123"
```

重启容器 docker restart gitlab

登录 http://192.168.111.120 要求重置密码 

root/Gitlab123



权限分配：

1. Guest 发表评论，无法读取
2. Reporter：可以克隆，但是无法提交（测试人员）
3. Developer：可以克隆，可以提交
4. Maintainer：可以创建项目，分配权限
5. Owner：最大权限



运行新版本gitlab

```sh
docker run -itd --name gitlab-17.7 -p 443:443 -p 80:80 -p 222:22 -m 8GB -v /data/gitlab-17.7/config:/etc/gitlab -v /data/gitlab-17.7/logs:/var/log/gitlab -v /data/gitlab-17.7/data:/var/opt/gitlab -e TZ=Asia/Shanghai gitlab/gitlab-ce:17.7.0-ce.0
```





```sh
docker tag registry.cn-beijing.aliyuncs.com/yuncenliu/gitlab-ce:17.7.0-ce.0 harbor.liuyuncen.com/yun/gitlab-ce:17.7.0-ce.0

docker push harbor.liuyuncen.com/yun/gitlab-ce:17.7.0-ce.0
```

