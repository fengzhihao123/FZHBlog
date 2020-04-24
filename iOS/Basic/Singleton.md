### Singleton

#### Intro
一个单例的类，无论你创建多少次它都只返回一个实例。它提供了对其类的资源的全局访问

Tip:因为单例对象一旦创建，对象指针是保存在静态区的，单例对象在堆中分配的内存空间只有在程序终止后才会释放，过多的单例必定会增大我们消耗的内存，所以只有当我们确实需要唯一的使用对象时才需要考虑单例模式，切勿滥用单例，引用开头的话：单例应该只用来保存全局的状态，并且不能和任何作用域绑定。如果这些状态的作用域比一个完整的应用程序的生命周期要短，那么这个状态就不应该使用单例来管理

#### Code
* Objective-C

```
+ (instancetype)shareInstance {
    static TestClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TestClass alloc]init];
    });
    return sharedInstance;
}

```

* Swift

```
final class TheOneAndOnlyKraken {
    static let sharedInstance = TheOneAndOnlyKraken()
    private init() {}
}
```

Apple中的singleton: NSNotificationCenter, UIApplication, and NSUserDefaults

#### 参考资料
* [apple document](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Singleton.html)
* [print memory address in swift](http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
* [单例的使用及避免对单例的滥用](http://www.jianshu.com/p/09cb4c59c8da)
