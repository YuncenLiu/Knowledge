## 浏览器请求返回 415 错误

:red_circle:415 Unsupported Media Type

排查请求头 （Request Headers)

```
Content-Type: text/html;charset=utf-8
```

这种请求头被能被使用 @RequestBody 所接受，所以需要在 ajax 请求中添加

```
contentType: 'application/json;charset=utf-8',
```





案例代码：

```js
<script>
    $(function () {
        $("#ajaxBtn").bind("click",function () {
            // 发送ajax请求
            $.ajax({
                url: '/demo/handle07',
                type: 'POST',
                data: '{"id":"1","name":"李四"}',
                contentType: 'application/json;charset=utf-8',
                dataType: 'json',
                success: function (data) {
                    alert(data.name);
                }
            })
        })
    })
</script>
```

