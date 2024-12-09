## FactoryBean是什么

FactoryBean 是 Spring所提供的一种较灵活的创建Bean的方法，可以通过实现 FactoryBean接口中的getObject（）方法来返回一个对象，这个对象就是最终的Bean对象

+ Object getObject（）：返回Bean对象
+ boolean isSingleton（）：返回是否是单利bean对象
+ Class getObjectType（）：返回Bean对象类型



```java
@Component("zhouyu")
public class ZhouyuFactoryBean implement FactoryBean{
  
  @Override
  // Bean对象
  public Object getObjec() throuws Exception{
    return new User();
  }
    
  @Override
  // Bean对象的类型
  public Class<?> getObjectType(){
    return User.class;
  }
    
  @Override
  // 所定义的Bean是单利还是原型
  public boolean isSingleton(){
    return true;
  }
}
```

