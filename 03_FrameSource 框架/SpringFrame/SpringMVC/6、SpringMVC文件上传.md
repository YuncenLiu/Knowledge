

前后端代码示例

```html
<form method="post" enctype="multipart/form-data" action="/demo/upload">
  <input type="file" name="uploadFile"/>
  <input type="submit" value="上传"/>
</form>
```

```java
@RequestMapping(value = "/upload")
    public ModelAndView upload(MultipartFile uploadFile,HttpSession session) throws IOException {
        // 处理上传文件
        // 重命名，原名123.jpg ，获取后缀
        String originalFilename = uploadFile.getOriginalFilename();// 原始名称
        // 扩展名  jpg
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length());
        String newName = UUID.randomUUID().toString() + "." + ext;

        // 存储,要存储到指定的文件夹，/uploads/yyyy-MM-dd，考虑文件过多的情况按照日期，生成一个子文件夹
        String realPath = session.getServletContext().getRealPath("/uploads");
        String datePath = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        File folder = new File(realPath + "/" + datePath);

        if(!folder.exists()) {
            folder.mkdirs();
        }
        // 存储文件到目录
        uploadFile.transferTo(new File(folder,newName));

        // 跳转到对应页面
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("success");
        return modelAndView;
    }
```

注意 SpringMVC 可以对 multipartResolver 进行配置，修改文件上限大小

```xml
<!--多元素解析器
        id固定为multipartResolver
    -->  
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
  <!--设置上传文件大小上限，单位是字节，-1代表没有限制也是默认的-->
  <property name="maxUploadSize" value="5000000"/>
</bean>
```

假设我设置为1，超出大小则会报错

```
HTTP Status 500 - Request processing failed; nested exception is org.springframework.web.multipart.MaxUploadSizeExceededException: Maximum upload size of 1 bytes exceeded; nested exception is org.apache.commons.fileupload.FileUploadBase$SizeLimitExceededException: the request was rejected because its size (1297) exceeds the configured maximum (1)
```

