# SpringBoot 集成 GBase 8A



### 打包 maven 依赖

```sh
mvn install:install-file \
-Dfile=/Users/xiang/Desktop/gbase-connector-java-9.5.0.7-build1-bin.jar \
-DgroupId=liuyuncen.com \
-DartifactId=gbase-connector-java \
-Dversion=9.5.0.7-build1-bin \
-Dpackaging=jar \
-Dmaven.repo.local=/usr/local/apache-maven-3.5.0/my-repoistory 
```

