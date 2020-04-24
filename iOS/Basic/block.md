# LearniOS
## Block

* [blcok test](http://blog.parse.com/learn/engineering/objective-c-blocks-quiz/)

### 关于__block
对于 block 外的变量引用，block 默认是将其复制到其数据结构中来实现访问的,对于用 __block 修饰的外部变量引用，block 是复制其引用地址来实现访问的
### 不用修饰__block可以访问的类型
* 静态变量
* 静态全局变量
* 全局变量


### Tip
* 在 Swift 闭包中使用的所有外部变量，闭包会自动捕获这些变量的引用。这就像是在 Objective-C 中外部变量都用 __block 修饰了。
* 在闭包执行时，闭包会根据这些变量引用得到它当前指向的对象的具体值。
* 我们可以在闭包内部修改外部变量的值，因为闭包捕获的是变量的引用而不是引用指向的值，当然这种情况下这个外部变量要声明为 var，而不能是 let。
* 如果你想要捕获闭包创建时变量对应的值，可以使用带中括号的捕获列表，在其中将变量对应的值存储到闭包的本地常量中。

### 参考链接
* [Swift 中的闭包捕获语义](http://www.samirchen.com/closures-capture-cemantics-in-swift/)
* [谈Objective-C block的实现](http://blog.devtang.com/2013/07/28/a-look-inside-blocks/)
* [apple Document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Blocks/Articles/bxGettingStarted.html#//apple_ref/doc/uid/TP40007502-CH7-SW1)
