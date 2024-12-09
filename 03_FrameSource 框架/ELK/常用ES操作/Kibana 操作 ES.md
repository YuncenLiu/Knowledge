
> 2024-07-05 基于 Mac 虚拟机环境 xiang@192.168.58.175
> 启动脚本配方见 `/home/xiang/shell` 
### 查看所有索引

概念类似于MySQL里的表概念

```
GET /_cat/indices?v
```

查询某个索引下的所有数据

```
POST /{index索引}/_search
{
  "query": {
    "match_all": {}
  }
}
```

