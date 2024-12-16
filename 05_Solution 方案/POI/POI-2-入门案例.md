[toc]

## POI 入门案例

POI 封装对象：

​	XSSF Workbook :工作簿

​	XSSF Sheel：工作表

​	Row：行

​	Cell：单元格

### 1、从 Excel 文件读取数据

+ 创建工作簿

```java
XSSFWorkbook workbook = new XSSFWorkbook(filePath);
```

+ 获取工作表

```java
XSSFSheet sheet = workbook.getSheetAt(0);
```

+ 遍历工作表获得行对象
+ 遍历对象获取单元格对象
+ 获取单元格对象中的值

```java
// 获取行对象
for (Row row : sheet) {
            // 获取单元格
            for (Cell cell : row) {
                // 获取单元格中的内容
                String value = cell.getStringCellValue();
                System.out.println(value);
            }
        }
```

> 注意事项，关闭工作流
>
> ```java
> workbook.close();
> ```

除了增强for循环可以通过遍历获取到值，也可以用普通循环获取

```java
public static void forRead(XSSFSheet sheet){
    // 获取最后一行
    int lastRowNum = sheet.getLastRowNum();
    for (int i = 0; i <= lastRowNum; i++) {
        XSSFRow row = sheet.getRow(i);
        if (row!=null){
			// 获取最后一个单元格
            short lastCellNum = row.getLastCellNum();
            for (int j = 0; j <= lastCellNum; j++) {
                XSSFCell cell = row.getCell(j);
                if (cell!=null){
                    String value = cell.getStringCellValue();
                    System.out.println(value);
                }
            }
        }
    }
}
```

### 2、向 Excel 文件写入数据

+ 创建一个Excel 工作簿

```java
 // 创建工作簿
 XSSFWorkbook workbook = new XSSFWorkbook();
```

+ 创建工作表

```java
// 创建工作表
XSSFSheet sheet = workbook.createSheet("工作表");
```

+ 创建行

```java
 // 创建行
XSSFRow row = sheet.createRow(0);
```

+ 创建单元格赋值

```java
for (int i = 0; i < message.size(); i++) {
    XSSFCell cell = row.createCell(i);
    cell.setCellValue(message.get(i));
}

```

+ 通过输出流将对象下载到磁盘

```java
FileOutputStream out = new FileOutputStream(filePath)
// 写入到 FileOutPutStream 流中
workbook.write(out);
out.flush();
```

> 注意事项：
>
> 关闭 out 流、关闭 workbook 流

### 3、代码案例

#### 1、读取

```java
package com.boxuegu.poi;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.IOException;

/**
 * @author Xiang想
 * @title: Demo
 * @projectName POITest
 * @description: TODO
 * @date 2020/11/29  1:21
 */
public class Demo {

    public static void main(String[] args) throws IOException {
        String homePath = System.getProperty("user.dir");
        String filePath = File.separator + "src" + File.separator + "main" +
                File.separator + "resources" + File.separator;
        String path =  homePath+filePath+"1.xlsx";
        readExcel(path);
    }

    public static void readExcel(String filePath){
        XSSFWorkbook workbook = null;
        XSSFSheet sheet = null;
        try {
            // 获取工作簿
            workbook = new XSSFWorkbook(filePath);

            // 获取工作表
            sheet = workbook.getSheetAt(0);

//            forEachRead(sheet);
            forRead(sheet);



        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if (workbook!=null){
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void forEachRead(XSSFSheet sheet){
        // 获取行
        for (Row row : sheet) {
            // 获取单元格
            for (Cell cell : row) {
                // 获取单元格中的内容
                String value = cell.getStringCellValue();
//                    if (value.equals("")){
//                        continue;
//                    }
                System.out.println(value);
            }
        }
    }

    public static void forRead(XSSFSheet sheet){
        int lastRowNum = sheet.getLastRowNum();
        for (int i = 0; i <= lastRowNum; i++) {
            XSSFRow row = sheet.getRow(i);
            if (row!=null){
                short lastCellNum = row.getLastCellNum();
                for (int j = 0; j <= lastCellNum; j++) {
                    XSSFCell cell = row.getCell(j);
                    if (cell!=null){
                        String value = cell.getStringCellValue();
                        System.out.println(value);
                    }
                }
            }
        }
    }
}
```

#### 2、写入

```java
package com.boxuegu.poi;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Xiang想
 * @title: Demo2
 * @projectName POITest
 * @description: TODO
 * @date 2020/11/29  2:01
 */
public class Demo2 {
    public static void main(String[] args) {
        String homePath = System.getProperty("user.dir");
        String filePath = File.separator + "src" + File.separator + "main" +
                File.separator + "resources" + File.separator;
        String path =  homePath+filePath+"4.xlsx";
        write(path);

    }

    public static List<String> getMessage(){
        List<String> list = new ArrayList<>();
        list.add("传智播客");
        list.add("黑马程序员");
        list.add("博学谷");
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date = simpleDateFormat.format(new Date());
        list.add(date);
        return list;
    }


    public static void write(String filePath){

        List<String> message = getMessage();

        // 创建工作簿
        XSSFWorkbook workbook = new XSSFWorkbook();
        // 创建工作表
        XSSFSheet sheet = workbook.createSheet("工作表");
        // 创建行
        XSSFRow row = sheet.createRow(0);
        // 创建单元格
        for (int i = 0; i < message.size(); i++) {
            XSSFCell cell = row.createCell(i);
            cell.setCellValue(message.get(i));
        }

        // 创建输出流对象
        try (FileOutputStream out = new FileOutputStream(filePath)) {

            workbook.write(out);
            out.flush();

        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if (workbook!=null){
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

```

> 提示：maven坐标如下：
>
> ```xml
> <dependency>
>     <groupId>org.apache.poi</groupId>
>     <artifactId>poi</artifactId>
>     <version>3.17</version>
> </dependency>
> 
> <!-- https://mvnrepository.com/artifact/org.apache.poi/poi-ooxml -->
> <!-- 支持后缀xlsx -->
> <dependency>
>     <groupId>org.apache.poi</groupId>
>     <artifactId>poi-ooxml</artifactId>
>     <version>3.17</version>
>     <exclusions>
>         <exclusion>
>             <groupId>xml-apis</groupId>
>             <artifactId>xml-apis</artifactId>
>         </exclusion>
>     </exclusions>
> </dependency>
> ```

><center><b><font color=blue >好了到这我们的分享也就结束了😉</font></b></center>
>
><center><b><font color=blue >希望以上方法可以帮到您，祝您工作愉快！💖</font></b></center>
>
><center>👇</center>
><center><b><font color=pink >对您有帮助的话记点赞得收藏哦！👍</font></b></center>
><center><font color=blue>我是</font>       <font color=red>Xiang想</font>     <font color=blue>从一个小白一步一步地变成工具人 😛</font></center>

