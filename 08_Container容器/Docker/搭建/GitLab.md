```sh
docker run -itd -p 8080:80 -p 8022:22 -u root -v /data/docker/gitlab/data/log:/var/log/gitlab -v /data/docker/gitlab/data/opt:/var/opt/gitlab -v /data/docker/gitlab/data/etc:/etc/gitlab --privileged=true --name=gitlab gitlab/gitlab-ce:latest
```





```sh
# 进入容器
docker exec -it gitlab /bin/bash

# 查看密码
cat /etc/gitlab/initial_root_password
```

