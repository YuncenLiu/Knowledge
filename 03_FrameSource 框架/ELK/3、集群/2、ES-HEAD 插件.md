基于 Node 前端工程，需要 Node.js

#### 安装 Node

下载

```sh
wget https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.xz
```

解压

```sh
tar xf node-v10.15.3-linux-x64.tar.xz
```

移动目录

```sh
mv node-v10.15.3-linux-x64 /usr/local/node-v10.15.3
```

建立软链

```shell
ln -s /usr/local/node-v10.15.3/bin/node /usr/local/bin/
ln -s /usr/local/node-v10.15.3/bin/npm /usr/local/bin/
```





#### 安装  phantomjs

在 /usr/local 目录下操作

```sh
cd /usr/local 

wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2
```

安装 bzip2

```
yum install -y bzip2
```

解压

```
tar -jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2

mv phantomjs-2.1.1-linux-x86_64 phantomjs-2.1.1
```

配置环境变量

```
vim /etc/profile
```

```
export PHANTOMJS_HOME=/usr/local/phantomjs-2.1.1
export PATH=$PATH:$PHANTOMJS_HOME/bin
```

生效

```
source /etc/profile
```





#### 安装 grunt

这个步骤会有点慢

```sh
yum -y install git
git clone git://github.com/mobz/elasticsearch-head.git 

cd elasticsearch-head

npm install -g grunt-cli
npm install grunt
npm install grunt-contrib-clean
npm install grunt-contrib-concat
npm install grunt-contrib-watch
npm install grunt-contrib-connect
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

安装后会自动集成到 ES 里

如果跨域没有开启就要去 ES 的config 里设置上（设置了可以忽略）

```
http.cors.enabled: true
http.cors.allow-origin: "*"
```

```
npm run start
```



访问 http://192.168.58.175:9100/

链接 http://192.168.58.175:9200/



```
PUT /xiang-shards
{
  "settings": {
    "number_of_replicas": "2",
    "number_of_shards": "3"
  },
  "mappings": {
    "properties": {
      "name":{
        "type": "text"
      }
    }
  }
}
```

![image-20230423175118522](images/2%E3%80%81ES-HEAD%20%E6%8F%92%E4%BB%B6/image-20230423175118522.png)



