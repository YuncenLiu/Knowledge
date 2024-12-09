[TOC]

## 一、初始JQuery

### 1、静态方法

#### 1、each方法

> 原生：
>
> ​	原生的 forEach 方法只能遍历数组，不能遍历伪数组

```javascript
var arr = [1, 3, 5, 7, 9];
arr.forEach(function (value, index) {
    console.log(value,index)
})
```

>利用 jQuery each静态方法遍历

```javascript
$.each(arr, funcation(index,value){
	console.log(index,value);
})
```

==区别==

​	jQuery 的each可以遍历伪数组

#### 2、map方法

> 原生：
>
> ​	arr1:当前遍历到的元素
> ​	arr2:当前遍历到的索引
> ​	arr3:当前被遍历到的数组

```javascript
arr.map(function(value,index,array){
    console.log(value,index,array);
})
```

> JQuery:
>
> ​	arr1:要遍历的函数
> ​	arr2:每遍历一个元素执行的回调函数
> ​			arr2.1:遍历到的元素
> ​			arr2.2:遍历到的索引
>
> ==可以遍历伪数组==

```javascript
$.map(arr,funcation(value,index){
      console.log(value,index);
});
```

#### 3、总结：map与each

jQuery 中的 each 静态方法和 map 静态方法的区别

+ each 
     + 静态方法默认的返回值就是，遍历谁就返回谁
     + 不支持对回调函数中对遍历的数组进行处理
+ map 
+ 静态方法默认的返回值就是一个空数组
+ 支持对回调函数中通过return对遍历的函数进行处理，并返回一个新的数组



#### 4、trim 方法

> 去除字符串两端的空格，去除后的字符串应返回一个新的字符串。不对参数字符串进行处理

```javascript
var str = "  Inj  ";
var res = $.trim(str);
```



#### 5、判断 方法

$.isWindow();

判断传入的参数，是否是window对象

返回值：true/false

------

$.isArray();

只有真数组才会返回 true

------

$.isFuncation();

判断传入的值是否是方法



#### 6、holdReady方法

> 暂停ready执行；  暂停入口函数执行

```javascript
$.holdReady(true);
```

 

### 2、选择器

#### 1、：empty

找到既没有文本内容，也没有子元素的指定元素

```javascript
$("div:empty")
```



#### 2、：parent

找到有文本元素或有子元素

```javascript
$("div:parent")
```



#### 3、：contains（text）

找到包含text文本内容的指定元素

```javascript
$("div:contains('Hello')")
```



#### 4、：has（selector）

找到包含子元素的指定元素

```javascript
$("div:has('span')");
```



### 3、属性和属性节点

1、什么是属性
		对象身上保存的变量就是属性

2、如何操作属性
		对象.属性名称 = 值；
		对象.属性名称；
		对象["属性名称"] =值；
		对象["属性名称"]；

3、什么是属性节点
		在编写HTML代码时，在HTML标签中添加的属性就是属性节点
		在浏览器中找到 span 这个 DOM 元素之后，展开看到的都是属性
		==在 attributes 属性中保存的都是内容中的属性节点==

4、操作属性节点    ==原生==
	DOM元素.setAttributes("属性名称","值")；
	DOM元素.getAttributes("属性名称")；

```javascript
var span = document.getElementsByTagName("span")[0];
sapn.setAttribute("name","Hello");
```

5、属性和属性节点有什么区别？
		任何对象都有属性，但是只有DOM对象才有属性节点



### 4、attr | prop方法

#### 1、attr(name|pro|key,val|fn)

作用：获取或设置属性节点的值
可以传递一个参数，也可以传递两个参数，传递一个，代表获取节点的值，传递两个，代表设置节点的值；

> 注意：
> 			如果是获取 无论找到多个元素，都只会返回第一个元素指定的属性节点的值
> 			如果是设置：找到多个元素，就会设置多少个元素
> 									如果设置的属性节点不存在，系统会自动新增！

```javascript
$("span").attr("class","box");

```



#### 2、removeAttr(name)

> 要删除多个元素，参数中空格隔开

```javascript
$("span").removeAttr("class name");
```



#### 3、prop 方法

操作属性节点值。

可以传入一个参数，也可以传入两个参数，一个参数代表取值，两个参数代表设置值。

prop方法和 attr 方法大致相同，获取时，只会返回第一个元素指定的属性节点值



> ==官方推荐==：
>
> ​		具有 true 和 false 两个属性的属性节点，如checked，selected 或者 disable 使用 prop（），其他使用 attr（）



### 5、操作类

+ addClass

     添加类， $("div").addClass("class1 class2")； 添加多个以空格隔开

+ removeClass

     移除类，删除多个，以空格隔开

+ toggleClass

     切换，有就删除，没有就添加



### 6、操作CSS

逐个设置：  ==$("div").css("width","100px");==

链式设置：  ==$("div").css("width","100px").css("hight","100px");==

批量设置：  ==$("div").css({ ... })==



获取：   ==$("div").css("width")==



### 7、scoll 定位

获取滚动条距顶端的值

```javascript
$("div").scrollTop();
```

设置滚动条距顶端的值

```javascript
$("div").scrollTop("300px");
```

==因为IE和其他浏览器不兼容问题，获取 和 设置网页滚动的偏移位需要按照如下写法==

```javascript
$("body").scrollTop()+$("html").scrollTop();

$("body,html").scrollTop(300)
```



### 8、事件绑定

#### 1、eventName(fn);

```javascript
$("button").click(function (){

})
```

> 编码效率率高
> 部分事件jQuery 没有实现，所以不能添加

#### 2、on(eventName,fn);

```javascript
$("button").on("click",function(){
    
})
```

> 编码效率率低
> 所有 jQuery 事件都可以添加

> ==注意点：==
>
> ​			可以添加多个相同或者不同类型的事件，且不会覆盖
>
> 