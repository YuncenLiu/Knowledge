> IK分词器介绍
>
> https://github.com/medcl/elasticsearch-analysis-ik

集成到 ElasticSearch 中





### 安装方式一

在 ElasticSearch 的 bin 目录下执行以下命令，ElasticSearch 会自动帮我们安装

这里用 root 进行安装

```
./elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.3.0/elasticsearch-analysis-ik-7.3.0.zip
```

![image-20230412153242371](images/3%E3%80%81%E9%9B%86%E6%88%90IK%E5%88%86%E8%AF%8D%E5%99%A8/image-20230412153242371.png)



此时重启 ElasticSearch、Kibana



Kibana 用root 启动，这里用非root启动可能报错，文件权限问题，到时候重启就可以



### 安装方式二

在 elasticsearch 安装目录的 plugins 目录下新建  `analysis-ik` 目录手工把压缩包解压进去，就可以了





##  测试案例

ik_max_word  将文本做最细粒度拆分

ik_smart 	做最粗力度的拆分



```
POST _analyze
{
	"analyzer": "ik_max_word",
	"text": "南京市长江大桥"
}
```

![image-20230412155348186](images/3%E3%80%81%E9%9B%86%E6%88%90IK%E5%88%86%E8%AF%8D%E5%99%A8/image-20230412155348186.png)



```
POST _analyze
{
	"analyzer": "ik_smart",
	"text": "南京市长江大桥"
}
```

![image-20230412155428168](images/3%E3%80%81%E9%9B%86%E6%88%90IK%E5%88%86%E8%AF%8D%E5%99%A8/image-20230412155428168.png)





### 扩展词典

假如想让 ik 分成  南京市长，江大桥，则需要使用自定义扩展词典



+ 如果是插件安装 进入 config/analysis-ik/
+ 如果是安装包安装 进入 plugins/analysis-ik/config/

```
vim xiang_ext_dict.dic
```

输入："江大桥"



```sh
[xiang@es analysis-ik]$ cat xiang_ext_dict.dic 
江大桥
```



然后配置 IKAnalyzer.cfg.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
        <comment>IK Analyzer 扩展配置</comment>
        <!--用户可以在这里配置自己的扩展字典 -->
        <entry key="ext_dict">xiang_ext_dict.dic</entry>
         <!--用户可以在这里配置自己的扩展停止词字典-->
        <entry key="ext_stopwords"></entry>
        <!--用户可以在这里配置远程扩展字典 -->
        <!-- <entry key="remote_ext_dict">words_location</entry> -->
        <!--用户可以在这里配置远程扩展停止词字典-->
        <!-- <entry key="remote_ext_stopwords">words_location</entry> -->
</properties>
```



+ 扩展词
+ 停词
+ 相近词





```
GET _search
{
  "query": {
    "match_all": {}
  }
}

POST _analyze
{
	"analyzer": "ik_max_word",
	"text": "南京市长江大桥"
}

POST _analyze
{
	"analyzer": "ik_smart",
	"text": "南京市长江大桥"
}

POST _analyze
{
  "analyzer": "ik_smart",
  "text": "想想是中国最没用的开发人员"
}

PUT /xiang-es-synonym
{
  "settings": {
    "analysis": {
      "filter": {
        "word_sync": {
          "type": "synonym",
          "synonyms_path": "analysis-ik/synonym.txt"
        }
      },
      "analyzer": {
        "ik_sync_max_word": {
          "filter": [
            "word_sync"
          ],
          "type": "custom",
          "tokenizer": "ik_max_word"
        },
        "ik_sync_smart": {
          "filter": [
            "word_sync"
          ],
          "type": "custom",
          "tokenizer": "ik_smart"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "name": {
        "type": "text",
        "analyzer": "ik_sync_max_word",
        "search_analyzer": "ik_sync_max_word"
      }
    }
  }
}

POST /xiang-es-synonym/_doc/1
{
  "name": "想想是中国最没用的开发人员"
}


POST /xiang-es-synonym/_doc/_search
{
  "query": {
    "match": {
      "name": ""
    }
  }
}
```

