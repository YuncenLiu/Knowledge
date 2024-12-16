

### 环境准备

Hadoop01 服务器执行 `nc -lk 17777` 

```sh
[xiang@hadoop01 ~]$ nc -lk 17777
```

#### 程序打包

pom.xml 中添加如下配置

```xml
<build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.2.4</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <artifactSet>
                                <excludes>
                                    <exclude>com.google.code.findbugs:jsr305</exclude>
                                    <exclude>org.slf4j:*</exclude>
                                    <exclude>log4j:*</exclude>
                                    <exclude>org.apache.hadoop:*</exclude>
                                </excludes>
                            </artifactSet>
                            <filters>
                                <filter>
                                    <!-- Do not copy the signatures in the META-INF folder.
                                    Otherwise, this might cause SecurityExceptions when using the JAR. -->
                                    <artifact>*:*</artifact>
                                    <excludes>
                                        <exclude>META-INF/*.SF</exclude>
                                        <exclude>META-INF/*.DSA</exclude>
                                        <exclude>META-INF/*.RSA</exclude>
                                    </excludes>
                                </filter>
                            </filters>
                            <transformers combine.children="append">
                                <transformer
                                        implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer">
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

在 dependencies 中，建议生产使用 provided

```xml
 <!-- 建议在生产运行使用 -->
<scope>provided</scope>
```

但这样的后果很有可能是本地运行时候报错

![image-20231017161701901](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017161701901.png)

但我们可以通过设置勾选

![image-20231017161724959](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017161724959.png)

即可解决错误。



打好包之后，就构建 Jar 包，上传到 Flink 页面中，http://hadoop01:8081

```
com.liuyuncen.wordCount.WordCountStreamUnboundedDemo
```

![image-20231017175101445](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017175101445.png)

在 Submit 提交前，确认我们 `nc -lk 17777` 程序已经开启

![image-20231017175224264](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017175224264.png)

![image-20231017175247027](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017175247027.png)

验证结果，最后关闭程序

![image-20231017175328809](images/3%E3%80%81WebUI%20%E6%8F%90%E4%BA%A4%E4%BD%9C%E4%B8%9A/image-20231017175328809.png)

