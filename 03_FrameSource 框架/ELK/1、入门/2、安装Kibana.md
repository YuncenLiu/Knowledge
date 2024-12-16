### 初始化

下载 Kibana

```
https://artifacts.elastic.co/downloads/kibana/kibana-7.3.0-linux-x86_64.tar.gz
```



解压到 /usr/local 下

```sh
tar -zxvf kibana-7.3.0-linux-x86_64.tar.gz -c /usr/local
```

重命名

```sh
cd /usr/local
mv kibana-7.3.0-linux-x86_64 kibana
```

修改访问权限

```
chown -R xiang:xiang kibana/
```





### 修改配置

/usr/local/kibana/config/kibana.yml

```yaml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://192.168.58.175:9200"]
```



### 启动

最好是不要用root启动

如果用root 启动需要加命令

```
/usr/kibana/bin/kibana --allow-root
```



![image-20230412151835553](images/2%E3%80%81%E5%AE%89%E8%A3%85Kibana/image-20230412151835553-1283938.png)

![image-20230412151900344](images/2%E3%80%81%E5%AE%89%E8%A3%85Kibana/image-20230412151900344.png)



### 测试

![image-20230412152151939](images/2%E3%80%81%E5%AE%89%E8%A3%85Kibana/image-20230412152151939.png)

如果能查出数据，说明已经安装好了

这里记录两个快捷键

```
ctrl i 格式化
ctrl Enter 执行查询
```





将 Kibana 7.3 改成中文的方法与上述安装中文版 Kibana 的步骤类似，需要修改配置文件并重启 Kibana。

以下是在 Linux 平台下将 Kibana 7.3 改成中文的简要步骤：

1. 进入 Kibana 安装目录，在 config/kibana.yml 配置文件中添加如下配置：

```
i18n.locale: "zh-CN"
```

1. 启动 Kibana：进入 Kibana 目录，执行 bin/kibana 命令。

这样就可以启动中文版的 Kibana 7.3 了。

如果您已经安装了英文版的 Kibana 7.3，并且想切换到中文版，只需要按照上述步骤修改 kibana.yml 文件即可。需要注意的是，Kibana 7.3 中的某些界面可能无法完全翻译成中文，但大部分内容应该都可以显示为中文。