## Query DSL

#### 查询全部

```json
POST /xiang-company-index/_search
{
  "query": {
    "match_all": {}
  }
}
```



#### 匹配搜索 match

```
POST /xiang-property/_search
{
  "query": {
    "match": {
      "title": "小米电视4A"
    }
  }
}
```

`match` 类型查询，会把查询条件进行分词，然后进行查询,多个词条之间是or的关系

![image-20230420112732881](images/2%E3%80%81Query%20DSL/image-20230420112732881.png)

如果想要 and 条件

```
POST /xiang-property/_search
{
  "query": {
    "match": {
      "title": {
        "query": "小米电视4A",
        "operator": "and"
      }
    }
  }
}
```



#### 短语搜索 

指定 analyzer、slop移动因子

```
GET /lagou-property/_search
{
  "query": {
    "match_phrase": {
      "title": {
        "query": "小米 4A",
        "slop": 2
      }
    }
  }
}
```

