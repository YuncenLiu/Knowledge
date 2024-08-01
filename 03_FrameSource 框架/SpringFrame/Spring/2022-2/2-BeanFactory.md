# 什么是BeanFactory

BeanFactory 是一种“spring容器”

BeanFactory 翻译过来就是Bean工厂

顾名思义，他可以用来创建Bean、获取Bean

BeanFactory是Spring中非常核心的组件



### BeanDefinition、BeanFactory、Bean对象之间的关系

BeanFactory将利用BeanDefinition来生成Bean对象

BeanDefinition相当于BeanFactory的原材料

Bean对象就相当于BeanFactory所生成出的产品



### BeanFactory的核心子接口和实现类

+ ListableBeanFactory
+ ConfigutableBeanFactory
+ AutowireCapableBeanFactory
+ AbstractBeanFactory
+ DefaultListableBeanFactory

### DefaultListableBeanFactory的功能

支持单利Bean、支持Bean别名、支持父子BeanFactory、支持Bean类型转换、支持Bean后置处理、支持FactoryBean、支持自动装配等等