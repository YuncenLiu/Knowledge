>  2024-04-26

学习 Vue 之前必须要掌握的 JavaScript 基础知识

+ ES6 语法规范
+ ES6 模块化
+ 包管理器
+ 原型、原型链
+ 数组常用方法
+ axios
+ promise...





Vue2 的官方文档：https://v2.cn.vuejs.org/v2/guide/



## HelloWorld



### 数据绑定

单向绑定 `v-bind`

```html
<a :href="url" v-bind:href="url">Xiang想</a>
```

双向绑定 `v-model`

只能用于表单类元素（输入类元素上）

```html
<input type="text" v-model:value="name" />
<!-- 简写 -->
<input type="text" v-model="name" />
```





### Dom绑定

el 的两种写法

```js
const v = new Vue({
    el: '#root',
})
```

```js
const v = new Vue({
})
v.$mount("#root")
```



### Data 返回

对象式写法

```js
const v = new Vue({
    el: '#root',
    data: {
        name: 'Xiang 想'
    }
})
```

函数式写法

```js
new Vue({
    el: '#root',
    data() {
        return {
            name: 'Xiang 想'
        }
    }
})
```

后续使用组件式的适合，必须使用函数式



### MVVM

1. M 模型：data中的数据
2. V 视图：代码模板
3. VM 视图模型：Vue实例

data 中所有属性，最后都出现在了VM身上

vm身上所有属性，及 Vue原型上所有属性，再Vue模板中都可以使用



### defineProperty

数据代理技术

```js
// 数据代理，不可以不枚举，不参与遍历
Object.defineProperty(person, 'age', {
    // value: 19,
    // enumerable: true, // 控制属性是否可以枚举，默认是 false
    // writable: true, // 控制数据是否可以被修改,默认为 false
    // configurable: true // 控制属性是否可以被删除，默认是 false

    // 不可以和 value 同时存在
    get(){
        console.log("有人读取 age 属性了");
        return number
    },
    set(value){
        console.log("有人修改 age 属性了",value);
        number = value
    }
})
```

通过代理一个对象代理对另一个对象中属性的操作 读/写



### 事件

```html
<button v-on:click="showInfo">点击事件</button>
<!-- 可以用 @ 代替 v-on:-->
<button @click="showInfo">点击事件</button>
<button v-on:click="putParm($event,6)">传入参数</button>
```



```js
const vm = new Vue({
    el: '#root',
    methods:{
        showInfo(event){
            // console.log(event.target);
            // console.log(this === vm) // 此处this就是vm
        },
        putParm(event,v){
            console.log(event,v);
        }
    }
})
```

使用 v-on:xxx 或 @xxx 绑定事件，其中 xxx 是事件名

事件的回调需要配置再 methods 中，最终会在 vm 上，这里为什么不放在 data 里呢？其实放在 data 里也可以用，但是 Vue 会将 data 的数据进行代理，那这样就多出了很多 getter、setter 代理对象。因为我们不需要对方法进行修改，所以徒增损耗，不建议放在 data 中。

methods 中配置的函数，不要用箭头函数，否则 this 就不是 vm 了

methods 中配置的函数，都是被 Vue 所管理的函数，this 是指vm或组件实例对象

**@click="demo"  和 @click="demo($evnet)"效果是一致的，但后者可以传参**



#### Vue 事件修饰符

1. prevent 阻止默认事件
2. stop 阻止事件冒泡
3. once 事件只触发一次
4. capture 使用事件的描述模式
5. self 只有 event.targe 是当前操作的元素时才触发返回
6. passive 事件的默认行为立即执行


