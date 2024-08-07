## ThreadLocal

threadlocal 的使用方式很简单

```
public class Test_03 {
    static final ThreadLocal t = new ThreadLocal();

    public static void main(String[] args) {
        int a = 1;
        t.set(a);
        Object o = t.get();
        System.out.println(o);
    }
}
```

threadlocal 是一个线程内部的存储类，可以在指定线程内存储数据。数据存储以后，只有指定线程可以得到存储数据

