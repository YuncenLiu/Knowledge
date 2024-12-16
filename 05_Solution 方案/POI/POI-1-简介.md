[toc]

## POI 文档操作

### 1、简介

1. 由apache 公司提供
2. Java编写的免费开源的跨平台 Java API
3. 提供 API 给 Java 程序对 Microsoft Office 格式档案读写的功能

### 2、使用前提

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>3.17</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.apache.poi/poi-ooxml -->
<!-- 支持后缀xlsx -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.17</version>
    <exclusions>
        <exclusion>
            <groupId>xml-apis</groupId>
            <artifactId>xml-apis</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

### 3、POI包结构

+ HSSF   ==>  读写 Microsoft Excel XLS
+ XSSF   ==>  读写 Microsoft Excel OOXML XLSX
+ HWPF    ==>  读写 Microsoft Word DOC
+ HSLF   ==> 提供读写 Microsoft PowerPoint

### 4、优劣势

> Jxl  ：消耗小，图片和图形支持有限
>
> Poi：功能更加完善

><center><b><font color=blue >好了到这我们的分享也就结束了😉</font></b></center>
>
><center><b><font color=blue >希望以上方法可以帮到您，祝您工作愉快！💖</font></b></center>
>
><center>👇</center>
><center><b><font color=pink >对您有帮助的话记点赞得收藏哦！👍</font></b></center>
><center><font color=blue>我是</font>       <font color=red>Xiang想</font>     <font color=blue>从一个小白一步一步地变成工具人 😛</font></center>