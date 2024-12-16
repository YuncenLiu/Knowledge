> 创建于2021年11月12日
> 作者：想想
> 来源：[CSDN](https://hbiao68.blog.csdn.net/article/details/100569408?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-3.no_search_link&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-3.no_search_link)

[toc]



## 关闭 eslint

在项目根目录创建 `vue.config.js` 文件

```js
module.exports = {
  outputDir: 'dist',  //build输出目录
  assetsDir: 'assets', //静态资源目录（js, css, img）
  lintOnSave: false, //是否开启eslint
}
```

重启服务，即可成功！

