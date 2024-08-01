[toc]

## Maven 常用命令

### 1、将本地jar包打进Maven仓库

```sh
mvn install:install-file -Dfile=/usr/local/apache-maven-3.5.0/my-repoistory/org/bouncycastle/bcprov-jdk15to18/1.66/bcprov-jdk15to18-1.66.jar -DgroupId=org.bouncycastle -DartifactId=bcprov-jdk15to18 -Dversion=1.66 -Dpackaging=jar -DgeneratePom=true -Dmaven.repo.local=/usr/local/apache-maven-3.5.0/repository
```

详解

```sh
mvn install:install-file 
 -Dfile=/Users/xiang/Desktop/fastjson-1.2.35.jar 
 -DgroupId=com.alibaba 
 -DartifactId=fastjson 
 -Dversion=1.2.35 
 -Dpackaging=jar 
 -DgeneratePom=true 
 -Dmaven.repo.local=/usr/local/apache-maven-3.5.0/my-repoistory
```

> **若是本地有多个仓库，则可通过 -Dmaven.repo.local=D:\mvn\localRepo来指定**



```sh
mvn install:install-file  -Dfile=easyopt.jar  -DgroupId=press.xiang  -DartifactId=easyopt   -Dversion=1.0.0  -Dpackaging=jar  -DgeneratePom=true  -Dmaven.repo.local=/usr/local/apache-maven-3.5.0/repoistory
```





### maven 下载

[manven下载路径](https://maven.apache.org/download.cgi) ： https://maven.apache.org/download.cgi



跳过测试将包打到maven本地仓库

```sh
mvn clean install -Dmaven.test.skip=true
```

打source包

```sh
mvn clean install -Dmaven.test.skip=true source:jar
```





```xml
<profile>
  <id>develop</id>
  <build>
    <plugins>
      <!-- 打source包 -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-source-plugin</artifactId>
        <version>3.0.1</version>
        <configuration>
          <attach>true</attach>
        </configuration>
        <executions>
          <execution>
            <phase>compile</phase>
            <goals>
              <goal>jar</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
</profile>
```

