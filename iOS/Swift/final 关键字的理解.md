### final 的作用
final 关键字的作用：使用它修饰的变量、方法、类不可继承。

整个类不可继承，若有类想继承 Animal，则编译器会报错：
```
final class Animal {
    let name: String
    init(name: String) {
        self.name = name
    }
    
    func eat() { }
}
```
属性不可继承：
```
class Animal {
    final let name: String
    init(name: String) {
        self.name = name
    }
    
    func eat() { }
}
```
方法不可继承：
```
class Animal {
    let name: String
    init(name: String) {
        self.name = name
    }
    
    final func eat() { }
}
```
总结：但凡用 final 修饰的都不可继承，它可以修饰 属性、方法、类。

### 有何好处
使用 final 可以提高性能。使用 final 修饰可以避免系统的动态派发(Dynamic Dispatch)。关于 Dynamic Dispatch 的更多优化可以参见[此处](https://developer.apple.com/swift/blog/?id=27)。