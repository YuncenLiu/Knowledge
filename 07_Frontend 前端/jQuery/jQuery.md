## 1、jQuery 与 原生 js

> 项目路径：F:/study/JQuery
>
> 相对于 jQuery 和原生 js 相对比

+ jQuery 代码更简洁
+ js 只能写一个入口函数，后面再写入口函数的话，会把前面的都覆盖掉
+ jQuery 入口函数要快于 window.onload
     + jQuery 入口函数要等待页面上 dom 树加载完后执行
     + window.onload 要等待页面上所有资源（外部css/js 连接，图片）都加载完后执行

如果传递参数是一个匿名函数-入口函数

如果参数传递的是一个字符串-选择器/创建一个标签

如果参数的一个dom对象，那就会吧dom对象转换成jQuery 对象

### 1.1、jQuery对象 与 dom对象

dom 对象就是由 document.getXxxx 获取到的对象，只能使用dom的方法和属性

jQuery 对象是由 $('')  jQuery 选择器选择的对象，同样的，也只能使用 jQuery的方法和属性，二者不能乱用，jQuery 对象是一个伪数组，是dom对象的包装集

```js
// 4.dom 对象转为 jQuery对象，
        var div = document.getElementById("one");
        var $div = $(div);	// 用$ 包裹即可
        console.log($div);
// 5.jQuery对象转为 dom 对象
		var $div = $('div');
		var div1 = $div[0];		// 下标取出
		var div2 = $div.get(1); // get 下标
		console.log(div1);
		console.log(div2);

```

### 1.2、text()  获取和设置文本

+ 不给参数，就是获取文本，给参数就是设置

+ 如果设置的文本中包含标签，也是不会标签给解析出来的

+ 包含了多个dom元素的jQuery对象，通过text方法设置文本，会把所有的dom元素都设置上

### 1.3、css() 获取和设置

+ 分单行和多行

     ```js
     $('div').css({
         width:300,
         height:'300px',
         backgroundColor:'#9f9f9f',
         'margin-top':'10px',
         border:'10px solid green'
     });
     ```

+ 多行的话，属性名可以采用驼峰命名法，值如果是整数，可以不用引号，如果加了  px  ，要加引号，否则报错

+ 获取包含多个dom元素的jQuery对象的样式，只能获取第一个dom对象

## 2、选择器

### 2.1、jQuery基本选择器

| 名称       | 用法              | 描述                               |
| ---------- | ----------------- | ---------------------------------- |
| ID选择器   | $('#id')          | 获取指定ID元素                     |
| 类选择器   | $('.class')       | 获取同一类class元素                |
| 标签选择器 | $('div')          | 获取同一类标签的所有元素           |
| 并集选择器 | $('div,p,li')     | 使用逗号分隔，只要符合条件之一就可 |
| 交集选择器 | $('div.redClass') | 获取class为redClass的div元素       |

总结：跟css下选择器一致

### 2.2、jQuery层级选择器

| 名称       | 用法       | 描述                                                         |
| ---------- | ---------- | ------------------------------------------------------------ |
| 子代选择器 | $('ul>li') | 使用 - 号，获取儿子层级的元素，注意，并不会获取孙子层级的元素 |
|            | $('ul li') | 使用空格，代表后代选择器，获取ul下所有li元素，包括孙级等     |

### 2.3、过滤选择器

| 名称       | 用法                             | 描述                                                        |
| ---------- | -------------------------------- | ----------------------------------------------------------- |
| :eq(index) | $('li:eq(2)').css('color','red') | 获取到li元素中，选择索引号为2的元素，索引号index从0开始算的 |
| :odd       | $('li:odd').css('color','red')   | 获取到的li元素中，选择索引号位奇数的元素                    |
| :even      | $('li:even').css('color','red')  | 获取到的li元素中，选择索引号为偶数的元素                    |

### 2.4、jQuery筛选选择器（方法）

| 名称               | 用法                       | 描述                              |
| ------------------ | -------------------------- | --------------------------------- |
| children(selector) | $('ul').cildren('li')      | 相当于$('ul-li'),子代选择器       |
| find(selector)     | $('ul').find('li')         | 相当于$('ul li'),后代选择器       |
| siblings(selector) | $('#first').siblings('li') | 查找兄弟节点，不包括自己本身      |
| parent()           | $('#first').parent()       | 查找父亲                          |
| eq(index)          | $('li').eq(2)              | 查找于$('li:eq(2)')，index从0开始 |
| next()             | $('li').next()             | 查找下一个兄弟                    |
| prev()             | $('li').prev()             | 查找上一个兄弟                    |

## 3、操作样式

### 3.1、class操作

+ 添加类

     ```
     $('#div1').addClass('fontSize30 width200');
     ```

+ 移除类

     ```
     $('#div1').removeClass();
     ```

+ 判断类

     ```
     console.log($('#div1').hasClass('fontSize30'));
     ```

+ 切换类

     ```
     $('#div1').toggleClass('fontSize30');
     ```





