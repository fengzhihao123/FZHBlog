## Unsafe Swift

### 开胃菜 - unsafelyUnwrapped
相信大家对于如何解包都已经烂熟于心，比如以下的代码：
```
var name: String? = "Swift"
if let n = name {
    print(n)
}
```
那么关于强制解包，不知道大家知不知道 `unsafelyUnwrapped` （反正看WWDC之前我是不知道🤦‍）? 下面看一下 `!` 与该属性有何不同：
```
var str: String?
print(str.unsafelyUnwrapped)
print(str!)
```
* `unsafelyUnwrapped` 的作用也是强制解包。在 optimized builds (-O)模式下，它不会去检查当前实例是否有值，如果访问的当前实例为 nil，则会触发无法预知的行为或者运行时错误；在 debug builds (-Onone)模式下，与 `!` 的行为一致。
* 当调用 [unsafeBitCast(_:)](https://developer.apple.com/documentation/swift/1641250-unsafebitcast) 函数时，推荐使用 `unsafelyUnwrapped`，因为该属性的限制性更强，而且在 debug builds 时访问该属性仍会进行检查。
* 该属性属于以安全性换取性能，谨慎使用。


总结：在日常开发中除极特殊情况，根本用不到😂。

### 何为 unsafe，何为safe
众所众知，Swift 是一门安全的编程语言，那么如何理解 unsafe 和 safe 呢？

safe ：系统会对所有的操作负责，并不是代表不会产生 crash，即 Safe code ≠ no crashes。在标准库中，很多操作在执行之前就会被检查是否有错误。比如下面的代码在编译期间就会报错：
```
var age: Int
age = ""
// Cannot assign value of type 'String' to type 'Int'
```
对于强制解包(!)来说，它也是安全的，因为我们都能预知它产生什么行为-> Fatal error: Unexpectedly found nil while unwrapping an Optional。

unsafe：系统假定程序员对所有的操作负责，所以它不会再进行检查。比如上述提到的`unsafelyUnwrapped`。

### 为什么需要 unsafe
* 与 C 或者 OC 的代码进行交互
* 控制 runtime 的性能

### unsafe pointer
官方例子：
```
let ptr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
ptr.initialize(to: 42)
print(ptr.pointee) // 42
ptr.deallocate()
ptr.pointee = 23 // UNDEFINED BEHAVIOR，输出为 23。
```
关于 UNDEFINED BEHAVIOR 自己的理解：在逻辑上 ptr 已经被释放，后面再引用该指针导致该指针不能被正常释放，造成内存泄漏。这种预期与代码逻辑的预期不一致：`ptr 并没有被释放`。

#### 基于闭包 VS 隐式指针
```
var value = 42
withUnsafeMutablePointer(to: &value) { p in
  p.pointee += 1
}
print(value)  // 43
```
基于闭包的优点：使 p 的生命周期更加明确，从而避免生命周期相关的问题。

```
var value2 = 42
let p = UnsafeMutablePointer(&value2) // BROKEN -- dangling pointer!
p.pointee += 1
print(value2)
```
隐式指针的缺点：p 的声明周期未控制，可能会造成无法预知的问题。比如下面的代码会造成 crash：
```
p.deallocate() // malloc: *** error for object 0x10000d668: pointer being freed was not allocated
```
因为 p 已经被释放，所以在调用 deallocate() 会造成crash。
 
推荐使用基于闭包的方式。

#### C 与 Swift 的指针映射
Example：
```
// C:
void process_integers(const int *start, size_t count);

// Swift:
func process_integers(_ start: UnsafePointer<CInt>!, _ count: Int)
```

![map](https://github.com/fengzhihao123/FZHBlog/blob/master/images/c-swift-map.png)
### Array 和 String 新增两个 unsafe 的初始化方法
![New API](https://github.com/fengzhihao123/FZHBlog/blob/master/images/new_api.png)
### 总结
* 尽量少使用 unsafe，若使用 unsafe 的接口，谨遵规则每个接口的规则
* 多测试


* [WWDC - Video](https://developer.apple.com/videos/play/wwdc2020/10648)
* [](https://wwdcnotes.com/notes/wwdc20/10648/)
