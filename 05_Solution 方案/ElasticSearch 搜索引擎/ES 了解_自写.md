---
2020年8月29日上午  
---

[TOC]

## ElasticSearch 认知

> 环境  jdk 1.8+    ElasticSearch 7.3.2（ElasticSearch 官网可以下载）   [https://www.elastic.co/cn/](https://www.elastic.co/cn/)



### 1、配置  （默认配置可以不用修改，直接跳过此段）

> 了解即可

进入  config 目录

`elasticsearch.yml `

```
network.host: 192.168.0.1     # 本地使用， 改成 0.0.0.0  接入局域网，别人也可以访问
http.port: 9200				  # 默认端口  9200

discovery.seed_hosts: ["host1", "host2"]      # 多台服务器配置 分布式，各个IP
```

`jvm.options`

-Xms  堆内存的最小大小，默认为物理内存的1/64

-Xmx  堆内存的最大大小，默认为物理内存的1/4

```
-Xms1g
-Xmx1g    # 这里默认分配了 1G 内存
```

### 2、启动

解压安装包，双击 bin 目录下 `elasticsearch.bat`  启动 elasticsearch     ==如果出现cmd 闪退现象，可以在cmd内 启动==

#### 2.1、查看信息

> 启动后，打开浏览器

```
# GET
localhost:9200
```

返回

```JSON
{
    "name": "ARRAY",						  # 计算机名称
    "cluster_name": "elasticsearch",			 # 分片名称
    "cluster_uuid": "yAzZFpkrSXSDYwVp4rCkrQ",	 # 分片 ID 
    "version": {
        "number": "7.3.2",					# ES 版本
        "build_flavor": "default",			# 默认风格
        "build_type": "zip",
        "build_hash": "1c1faf1",			# hascode  内存地址
        "build_date": "2019-09-06T14:40:30.409026Z",
        "build_snapshot": false,			# 非 快照 版本
        "lucene_version": "8.1.0",			# lucene 班本
        "minimum_wire_compatibility_version": "6.8.0",
        "minimum_index_compatibility_version": "6.0.0-beta1"
    },
    "tagline": "You Know, for Search"
}
```

#### 2.2、创建索引【数据库】

```
# PUT
localhost:9200/helloes
```

返回:

```
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "helloes"
}
```

> 创建一次后，不能再创建同名的索引名
>
> ```
> put 插入
> 格式：
> :9200/索引名/表名/数字
> 插入相同数字，将会覆盖
> 
> get 获取
> 格式：
> :9200/索引名/表名/数字
> ```

#### 2.4、增加数据

> ==这一过程 请在   PostMan 环境下进行，否则数据无法在浏览器插入==

```
# PUT
localhost:9200/helloes/hello/2
```

Body：选择  ==raw==    ==JSON==     输入JSON数据

```
{
	"name":"小肖肖",
	"age":"19"
}
```

返回：

```JSON
{
    "_index": "helloes",     # 库名
    "_type": "hello", 		# 表名
    "_id": "2",				# 第  2 个ID
    "_version": 1,			# 第一版本
    "result": "created",	# 创建   如果是第二次 put 此 Id 的话, 就是 update 了
    "_shards": {
        "total": 2,			# 2 条数据
        "successful": 1,	# 成功
        "failed": 0			# 失败
    },
    "_seq_no": 2,
    "_primary_term": 2
}
```

> 【error】2020-8-29   ：一个 helloes 库里，只能新增一个 hello 表，如果创建其他 类，则报错
>
> ​								例如：  localhost:9200/helloes/good/2    ，结论：一个库只能存在一个类  
>
> 【solve】：此字段无其他作用，一个索引中只能产生一个，第二个无法创建，在 Es 7.6.0+ 会取消该字段

#### 2.4、获取数据

```
# GET
localhost:9200/helloes/hello/2
```

返回：

```JSON
{
    "_index": "helloes",
    "_type": "hello",
    "_id": "2",
    "_version": 1,
    "_seq_no": 2,
    "_primary_term": 2,
    "found": true,
    "_source": {
        "name": "小肖肖",
        "age": "19"
    }
}
```

####  2.5、查看状态

```
# GET
localhost:9200/_cat/indices?v
```

+ cat 在 linus 中，是查看的意思

返回：

```
health status index   uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   rsdoct  uZMoPK_oS0uWhkszW6BjqQ   5   1          5            0     14.8kb         14.8kb
yellow open   helloes cp88BoRrSb2Hzpck26uVgg   1   1          1            0        4kb            4kb
```

+ health  
     + yellow   只有主服务器可以查询到，备份服务器查询不到
     + green   主服务器、备份服务器都可以查询到
     + red        主服务器、备份服务器都查询不到
+ status  状态，open 开启   close 关闭
+ index   索引【其实就是数据库 库名】
+ rep  type 类【表，一个索引只有一个 表，在 7.6以后，这个类型就取消了】
+ docs.count   字段
+ docs.deleted  删除字段



### 3、工具（内附源码）

> ==项目源码、GItHub、gitee  均可下载==    原本针对   rsdoct  索引进行操作，执行从数据库查询数据转存到 Es 前，确保ES 有  ==rsdoct== 索引

```
https://github.com/Xiangxiang-Array/elasticsearch_demo_api
https://gitee.com/Array_Xiang/elasticsearch_demo_api
```

#### 3.1、把数据库数据插入到 ES 中

> 创建一个 SpringBoot 项目

==项目：elasticsearch_demo==

思想：

1. 把数据库数据全部查询出来，List<T> 形式保存

2. 再插入到Es中

     ```
     public interface EsDao extends CrudRepository<Students,Long> {
     
     }
     ```

     这里esDao要继承 CrudRepository<Students,Long>，泛型 第一参数是 实体类、第二参数是 字段，类似于    `localhost:9200/helloes/hello/2`  最后的 2

     ```java
     Long i = 1L;
     for (Students student : students) {
         student.setId(i);
         i++;
     }
     esDao.saveAll(students);
     ```

#### 3.2、高级查询 权重查询 高亮字段

思想：

1. 构建 指定的索引、类型

     ```
     // 构建 es 搜索请求
     SearchRequest searchRequest = new SearchRequest("rsdoct");
     // 指定类型
     searchRequest.types("rsbean");
     // 构造搜索源对象
     SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
     ```

2. 添加查询条件

     1. 配置权重

          ```
          MultiMatchQueryBuilder matchQueryBuilder = QueryBuilders.multiMatchQuery(text,"name")
                  .field("name",10)
                  .field("desc",5);
          ```

     2. 配置高亮

          ```java
          // 配置高亮查询
          HighlightBuilder highlightBuilder = new HighlightBuilder();
          // 高亮前缀
          highlightBuilder.preTags("<span style='color:red'>");
          // 高亮后缀
          highlightBuilder.postTags("</span>");
          ```

3. 使用 StringBuffer 拼接高亮部分



### 4、思想

1. 高可用：

     高可用就是可持续维持高访问量的请求，如果服务器存在宕机问题，会有备份服务器继续进行服务，保证服务不断

2. 分片：

     在集群环境下，请求会发给每一台服务器进行索引，最终把所有索引数据返回，经过权重进行输出

3. 水平扩展

     开箱即用、配置集群，可以在conf 文件下的 `elasticsearch.yml`  文件配置IP地址，再把此文件复制到 其他服务器的此文件目录即可

4. REST ful

     接口风格，put 添加 get 查看  post 修改 delete 删除等