```
docker pull sonatype/nexus3:3.58.1
```

```
docker run -d -p 8081:8081 --name nexus -e INSTALL4J_ADD_VM_PARAMS="-Xms512m -Xms512m -XX:MaxDirectMemorySize=1200m" -v /Users/xiang/xiang/docker/nexus:/nexus-data sonatype/nexus3:3.58.1
```

运行后会有点慢`docker logs -f nexus` 查看日志。

默认 admin 用户，密码在挂载目录下 又个 admin.password 文件。