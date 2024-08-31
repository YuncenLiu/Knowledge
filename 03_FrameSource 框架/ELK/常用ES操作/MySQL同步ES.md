
使用 `logstash`

logstash 下载地址：`elastic` 组件所有组件下载地址

```
https://www.elastic.co/cn/downloads/past-releases
```

参考 Mac 虚拟机环境 `192.168.58.175`

```
/usr/local/logstash
```

路径下创建文件夹 `mysqletc` 

```
./mysqletc/
├── mysql.conf
├── mysql-connector-java-5.1.46.jar
└── mysql-connector-java-8.0.17.jar
```


### mysql.conf

```conf
input {
  
    # 多张表的同步只需要设置多个jdbc的模块就行了
    jdbc {
        # mysql 数据库链接,shop为数据库名
        jdbc_connection_string => "jdbc:mysql://39.105.177.10:3388/cloud?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&rewriteBatchedStatements=true"
        # 用户名和密码
        jdbc_user => "cloud"
        jdbc_password => "cloud"
  
        # 驱动
        jdbc_driver_library => "/usr/local/logstash/mysqletc/mysql-connector-java-8.0.17.jar"
  
        # 驱动类名
        jdbc_driver_class => "com.mysql.jdbc.Driver"
  
        #是否分页
        jdbc_paging_enabled => "true"
        # 每次单次同步查询最大条数
        jdbc_page_size => "50000"
  
        #直接执行sql语句
        statement =>"select * from s_subject"
        # 执行的sql 文件路径+名称
        # statement_filepath => "/usr/local/logstash-6.6.0/mysql/item.sql"
        
        # 默认列名转换为小写
        lowercase_column_names => "false"
  
        #设置监听间隔  各字段含义（由左至右）分、时、天、月、年，全部为*默认含义为每分钟都更新
        schedule => "* * * * *"
  
        # 索引类型
        #type => "jdbc"
      }

  }
  
  
  output {
    elasticsearch {
          #es的ip和端口
          hosts => ["http://192.168.58.175:9200"]
          #ES索引名称（自己定义的）
              index => "s_subject"
          #文档类型
          document_type => "subject"
          #设置数据的id为数据库中的字段
          document_id => "%{id}"
      }
      stdout {
          codec => json_lines
      }
  
  }
```



## 启动执行

```sh
logstash -f ../mysqletc/mysql.conf
```

