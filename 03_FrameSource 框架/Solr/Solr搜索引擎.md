## 1、Solr 简介

+ Solr 是Apache 下的一个顶级开源项目，采用 Java 开发，它是基于 Lucene 的全文搜索服务器。Solr 提供了比 Lucene 更为丰富的查询语句，同时实现了可配置、可扩展，并对索引、搜索性能进行了优化
+ Solr 可以独立运行，运行在 Jetty、Tomact 等这些 Servlet 容器中，Solr 索引的实现方式很简答，用Post 方法向 Solr 服务器发送一些描述 Field 及其内容的 XML 文档，Solr 根据XML 文档添加、删除、更新索引。Solr索引只需要发送 HTTP GET 请求，然后对 Solr 返回 xml，json 等格式的查询结果进行解析，组织页面布局。Solr 不提供构建 UI 的功能。Solr 提供一个管理界面，通过管理界面可以查询到 Solr 的配置的和运行情况

### 1.1、Solr 下载与安装

1. Solr 下载地址：[http://archive.apache.org/dist/lucene/solr/](http://archive.apache.org/dist/lucene/solr/)

2. 安装 Solr 与 Tomcat 集成

     1. 解压 Solr   

          ```
          tar  -zxvf solr-4.10.3.tgz.tar
          ```

     2. 进入目录

          ```
          cd solr-4.10.3/example/webapps
          ```

     3. 拷贝 webapps 文件下的 war文件 到tomcat 的webapps 中

          ```
          cp solr.war /usr/local/solr-tomcat/webapps/
          ```

     4. 删掉 webapps 除 solr.war 之外的所有文件夹

     5. 配置 刚刚移进去的 solr/WEB-INF/web.xml 文件 （把41-45行注释放开）

          > /usr/local/solr-4.10.3/example/solr   solr移动之前的位置

          ```xml
          <env-entry>
              <env-entry-name>solr/home</env-entry-name>
              <env-entry-value>/usr/local/solr-4.10.3/example/solr</env-entry-value>
              <env-entry-type>java.lang.String</env-entry-type>
          </env-entry>
          ```

     6. 复制 solr-4  的 lib下 jar 包到  tomcat lib 里去

          ```
          cd /usr/local/solr-4.10.3/example/lib/ext
          cp * /usr/local/solr-tomcat/lib/
          ```

     7. 启动tomat

     8. 担心报错，查看一下后500行日志

          ```
          tail -f -n 500 /usr/local/solr-tomcat/logs/catalina.out 
          ```

     9. 启动成功后，访问 tomcat 依赖的 solr

          ![image-20200728184537075](images/Solr%E9%A6%96%E6%9C%88.png)

     ### 1.2、Java-API实现功能

     1. 需要的jar:

          1. commongs-logging
          2. solr-solrj-4.10.3.jar

     2. 测试代码：

          ```java
          public class Test {
              private static String URL = "http://47.107.189.111:12080/solr/";
              private static SolrServer solrServer = new HttpSolrServer(URL);
          
              public static void main(String[] args) throws IOException, SolrServerException {
                  del();
          
              }
          
              public static void add() throws IOException, SolrServerException {
                  SolrInputDocument doc1 = new SolrInputDocument();
                  doc1.setField("id","1001");
                  doc1.setField("name","iphone6s");
                  doc1.setField("price","3000");
                  doc1.setField("url","/img/01.jpg");
                  solrServer.add(doc1);
                  solrServer.commit();
              }
          
              public static void query() throws SolrServerException {
                  SolrQuery solrQuery = new SolrQuery();
                  solrQuery.set("q","title:张");
                  QueryResponse response = solrServer.query(solrQuery);
                  SolrDocumentList list = response.getResults();
                  long num = list.getNumFound();
                  System.out.println("======\t条数："+num+"\t=====");
                  System.out.println(list);
              }
          
              public static void del() throws IOException, SolrServerException {
                  solrServer.deleteByQuery("id:1");
                  solrServer.commit();
              }
          }
          
          ```

## 2、全文检索

1. 信息源 -》 本地（进行加工和处理） -》 建立索引库（信息集合，一组文件的集合）
2. 搜索的时候从本地的（索引库）信息集合中搜索
3. 文本在建立索引和搜索时，都会先进行分词（使用分词器）
4. 索引的结构：
     1. 索引表（存放具体的词汇，那些词汇再那些文档里储存，索引里存储的就是分词器分词后的结果）
     2. 存放数据（文档信息集合）
5. 用户索引时，首先找到分词器进行分词，然后再索引表里查找对应的词汇（利用倒序索引），再找到对应的文档集合
6. 索引库位置（Directory）
7. 信息集合里的每一条数据都是 document （存储所有的信息，他是一个 Filed 属性的集合）
8. sotre 是否进行存储（可以不存储，也可以存储）
9. index 是否进行存储（可以不索引，也可以索引，索引的话分为 分词后索引，或直接索引）
10. 无论是 Solr 还是 lucene ，都对中文分词不太友好，所以我们一般索引中文的话需要使用 IK 中文分词器

### 2.1、下载并使用 IK 分词器

1. 下载 IK Analyzer 2012FF_hf1,zip

2. 在windows 下解压，获取到
     1. stopword.dic
     2. IKAnalyzer.cfg.xml
     3. IKanalyzer2012FF_u1.jar
     
3. 先把  IKanalyzer2012FF_u1.jar 上传到  solr-tomcat 服务器的 /webapps/solr/WEB-INF/lib 文件夹下

4. 在 WEB-INF 下创建 classes 文件夹，把  stopword.dic  和   IKanalyzer.cfg.xml  放到classes文件夹内

5. 修改 solr core 的 schema 文件，

     ```
     /usr/local/solr-4.10.3/example/solr/collection1/conf/schema.xml
     ```

6. 在  447 行添加

     ```xml
     <fieldType name="text_ik" class="solr.TextField">
         <!-- 索引时候的分词 -->
         <analyzer type="index" isMaxWordLength="false" class="org.wltea.analyzer.lucene.IKAnalyzer"/>
         <!-- 查询时候的分词 -->
         <analyzer type="query" isMaxWordLength="true" class="org.wltea.analyzer.lucene.IKAnalyzer"/>
     </fieldType>
     ```

7. 启动 solr

     ```
     /usr/local/solr-tomcat/bin/startup.sh
     ```

8. 老规矩，查看日志

     ```
     tail -f -n 500 /usr/local/solr-tomcat/logs/catalina.out
     ```

### 2.2、自定义词库

1. 修改 /usr/local/solr-tomcat/webapps/solr/WEB-INF/classes/IKAnalyzer.cfg.xml

2. 放开注释

     ```xml
     <entry key="ext_dict">ext.dic;</entry> 
     ```

3. 新建 ett.dic 文件

     ```
     互联网应用架构师
     ```

4. 启动 solr 分词， 这个词会被组成一个词组



## 3、JavaBean 与 Solr 注解使用

1. 先配置自定义类型和名称

     ```
     \usr\local\solr-4.10.3\example\solr\collection1\conf\schema.xml
     ```

2. 添加自定义字段名和类型

     ```xml
     <field name="user_name" type="string" indexed="true" stored="true" required="true" multiValued="false" /> 
     <field name="user_age" type="string" indexed="true" stored="true" required="true" multiValued="false" /> 
     <field name="user_like" type="string" indexed="true" stored="true" required="true" multiValued="true" /> 
     ```

3. 写 实体类

     ```java
     public class User implements Serializable {
     
         @Field("id")
         private String id;
         @Field("user_name")
         private String name;
         @Field("user_age")
         private int age;
         @Field("user_like")
         private String[] like;
         
         // getter/setter
     }
     ```

4. 测试类

     ```java
     public class Test2 {
         private static String URL = "http://47.107.189.111:12080/solr/";
         private static SolrServer solrServer = new HttpSolrServer(URL);
     
         public static void main(String[] args) throws IOException, SolrServerException {
             query();
         }
     
         public static void add() throws IOException, SolrServerException {
             User u = new User();
             String prefix = "user_";
     
             String id = prefix+ UUID.randomUUID().toString().substring(4).substring(prefix.length());
             System.out.println(id);
             u.setId(id);
             u.setName("李四");
             u.setAge("40");
             u.setLike(new String[]{"玩游戏"});
             solrServer.addBean(u);
             solrServer.commit();
             id = prefix+ UUID.randomUUID().toString().substring(4).substring(prefix.length());
             u.setId(id);
             u.setName("王明");
             u.setAge("30");
             u.setLike(new String[]{"足球","游戏"});
             solrServer.addBean(u);
             solrServer.commit();
         }
     
         public static void query() throws SolrServerException {
             SolrQuery solrQuery = new SolrQuery();
             solrQuery.set("q","user_name:明");
             QueryResponse response = solrServer.query(solrQuery);
             SolrDocumentList solrList = response.getResults();
             long name = solrList.getNumFound();
             System.out.println("条数: \t"+name);
             for (SolrDocument entries : solrList) {
                 User u =  solrServer.getBinder().getBean(User.class,entries);
                 System.out.println(u.toString());
             }
         }
     }
     ```

## 4、Solr 集群搭建

[http://blog.csdn.net/xyls12345/article/details/27504965](http://blog.csdn.net/xyls12345/article/details/27504965)

http://segmentfault.com/a/1190000000595712





## 5、Solr 7.x 版本 Linux 安装

[https://lucene.apache.org/solr/downloads.html](https://lucene.apache.org/solr/downloads.html)    下载 、解压

### 5.1、启动

1. 进入 solr 主目录下的 bin   ,启动solr

```
solr start -force
```

2. 启动后，进入 网页 ，solr 默认端口 8983 

```
47.107.189.111/8983/solr
```

3. 新建一个 核心，起名为 xiang， 在solr的  server 下面的 solr 出现一个 xiang 的文件夹   以后这个`xiang` 就是我的核心名称

```
/usr/local/solr-8.6.0/server/solr/xiang
```

​				这个路径就是我们核心的物理路径

4. 进入 默认配置文件，把默认的配置复制进我们刚刚创建的 xiang 里面，

```
默认配置文件位置
/usr/local/solr-8.6.0/example/example-DIH/solr/solr          
```

5. 使用命令复制       cp -r 迭代复制，可以复制文件夹

```
cp -r * /usr/local/solr-8.6.0/server/solr/xiang
```

> 如果报错了，我们进入  
>
> ```
> /usr/local/solr-8.6.0/server/solr/configsets/_default/conf/lang
> ```
>
> 这个文件，把里面所有的文件拷贝到
>
> ```
> /usr/local/solr-8.6.0/server/solr/xiang/conf/lang
> ```



### 5.2、Solr 7.x 版本配置ik分词器

> 前言：在solr7以下，ik分词器版本可以使用 IKAnalyzer2012FF_u1.jar，但是很早之前就已经不提供更新了，在solr7以上就导致不兼容，无法使用，可以换成 ik-analyzer-solr7-7.x.jar 

1、下载Ikanalyzer7.x分词器的jar文件，下载地址：https://search.maven.org/search?q=com.github.magese

2、将下载的ik-analyzer-solr7-7.x.jar文件拷贝至:solr-8.6.0/server/solr-webapp/webapp/WEB-INF/lib

3、打开solr-8.6.0/server/solr/xiang/conf/managed-schema文件，添加如下代码：

```xml
<!-- ik分词器 -->
<fieldType name="text_ik" class="solr.TextField">
    <analyzer type="index">
        <tokenizer class="org.wltea.analyzer.lucene.IKTokenizerFactory" useSmart="false" conf="ik.conf"/>
        <filter class="solr.LowerCaseFilterFactory"/>
    </analyzer>
    <analyzer type="query">
        <tokenizer class="org.wltea.analyzer.lucene.IKTokenizerFactory" useSmart="true" conf="ik.conf"/>
        <filter class="solr.LowerCaseFilterFactory"/>
    </analyzer>
</fieldType>

<!--自定义字段-->
<!--IKAnalyzer Field-->
<!-- type="text_ik"代表使用了Ik中文分词器。 -->
<!-- indexed="true"代表进行索引操作。 -->
<!-- stored="true"代表将该字段内容进行存储。 -->
<field name="product_name" type="text_ik" indexed="true" stored="true" />
<field name="product_price" type="string" indexed="true" stored="true" />
<field name="product_picture" type="string" indexed="false" stored="true" />
<field name="product_description" type="text_ik" indexed="true" stored="true" />
<field name="product_catalog_name" type="string" indexed="true" stored="false" />
```



## 6、solr 连接数据库

### 6.1、编写 solr-data-config.xml 数据源

先在数据库创建表，确保能查下出数据出来

打开 /server/solr/xiang/conf/solr-data-config.xml 进入，编辑，一定要确保查下语句能生效

```xml
<dataConfig>
  <dataSource type="JdbcDataSource" driver="com.mysql.jdbc.Driver"
  url="jdbc:mysql://127.0.0.1:3306/solr"
  batchSize="-1"
  user="root"
  password="root"/>
  <document>
	<entity name="user" query="
		select
		p.id,
		p.name,
		p.price,
		m.name merchant,
		c1.shortname city,
		c2.shortname province
		from product p
		left join merchant m on p.merchant_id = m.id
		left join city c1 on m.city_id = c1.id
		left join city c2 on c1.pid = c2.id;
		"
		
		deltaQuery="
		select
		p.id,
		p.name,
		p.price,
		m.name merchant,
		c1.shortname city,
		c2.shortname province
		from product p
		left join merchant m on p.merchant_id = m.id
		left join city c1 on m.city_id = c1.id
		left join city c2 on c1.pid = c2.id;
		">
		<field column="id" name="id"/>
		<field column="name" name="name"/>
		<field column="price" name="price"/>
		<field column="merchant" name="merchant"/>
		<field column="city" name="city"/>
		<field column="province" name="province"/>
	</entity>
  </document>
</dataConfig>
```

### 6.2、放jar包

把  mysql-connection-java   的jar包放进

```
 /server/solr-webapp/webapp/WEB-INF/lib 
```

### 6.3、添加未知字段

solr默认提供了 id、name、price 等字段，如果查询语句中，你写的字段在 managed-schema 中未提供，你需要在里面添加字段

```xml
<field name="product_name" type="text_ik" indexed="true" stored="true" />
```

上面使用了tesk_ik  前提要有哦，如果没有，数据会插不进 solr 库的

### 6.4、打开网页端

![image-20200826102349885](images/Solr2%E6%9C%88.png)



上面报红可以忽略，版本问题....  建议你提高版本.....   我不接受他的建议。

我们看到  feched：25  表示抓取到 25条数据

processed ：25 插入了 25条数据，  出现了这两条就说明成功了