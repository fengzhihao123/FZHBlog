### Delegated - 自动 weak self
* [Delegated 项目地址](https://github.com/dreymonde/Delegated)

Closure，在日常代码中会经常使用到。使用它时，为了防止可恶的内存泄漏，要时常记得写 `[weak self]` 这样的代码。但对于程序员来说写这种模板代码是很枯燥的，所以， Delegated 就应运而生了。通过它注册过后的 Closure，可以自动的 weak self。下面就来看一下它的基本使用吧。

#### 基本使用

它的使用很简单，通过下面两个步骤就可以实现自动的 weak self：
* 使用 @Delegated 声明 Closure。
* 使用 delegate() 函数来调用 Closure。

来看一个具体的例子：
```
final class TextField {
    // 第一步：使用 @Delegated 声明 Closure。
    @Delegated var didUpdate: (String) -> ()
}

// 第二步：使用 delegate() 函数来调用 Closure。
textField.$didUpdate.delegate(to: self) { (self, text) in
    // `self` is weak automatically!
    self.label.text = text
}
```

通过上面的两步就实现了自动 weak self，没有循环引用，没有内存泄漏，没有 `[weak self]`!🎉

#### 实现原理
掌握了它的使用方法之后，下面来看一下它的实现原理。它的代码很简单，只有一个 Delegated.swift 文件，代码只有 410 行。

所有类的说明：
* Delegated0：对应无返回值，无参数的 Closure。
* Delegated1：对应无返回值，一个参数的 Closure。
* Delegated2：对应无返回值，两个参数的 Closure。
* Delegated3：对应无返回值，三个参数的 Closure。
* ReturningDelegated0：对应有返回值，无参数的 Closure。
* ReturningDelegated1：对应有返回值，一个参数的 Closure。
* ReturningDelegated2：对应有返回值，两个参数的 Closure。
* ReturningDelegated3：对应有返回值，三个参数的 Closure。

虽然代码包含上面 8 个类，但实质上只要理解了其中的任意一个类即可，因为其他的类只是参数和有无返回值的不同而已。

在这里，拿 Delegated1 来举例说明一下它的实现原理。
```
@propertyWrapper
public final class Delegated1<Input> {
    public init() { self.callback = { _ in } }
    private var callback: (Input) -> Void
    public var wrappedValue: (Input) -> Void { return callback }
    
    public var projectedValue: Delegated1<Input> {
        return self
    }
}

public extension Delegated1 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input) -> Void
    ) {
        self.callback = { [weak target] input in
            guard let target = target else {
                return
            }
            return callback(target, input)
        }
    }
    
    func manuallyDelegate(with callback: @escaping (Input) -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { _ in }
    }
}
```

首先，来分析一下 Delegated1 类。可以看到它使用了 @propertyWrapper 关键字来修饰，@propertyWrapper 的作用简单来说就是用来封装平常的模板代码。[关于@propertyWrapper更详细的介绍可以看这里](https://github.com/fengzhihao123/FZHBlog/blob/master/iOS/Swift/通过%20Property%20Wrappers%20简化代码.md)。

接着，它通过定义 Input 来实现参数支持泛型，然后声明了 callback 属性来存储 Closure。对于 wrappedValue 和 projectedValue 则是重写的 @propertyWrapper 的内置参数。

接着，来看一下 extension 中的 delegate 函数。delegate 函数接受两个参数：
* target：需要 weak 的对象。
* callback：实际用到的 closure。

可以看到，在 delegate 函数体内，就是自动 weak self 的关键部分。对 callback 进行了重新赋值：
```
self.callback = { [weak target] input in
    // 通过这里实现自动 weak self
    guard let target = target else {
        return
    }
    return callback(target, input)
}
```
extension 中还有两个函数，它们的代码也很好理解：
* manuallyDelegate：手动管理，即不使用自动 weak self。通过代码也可以看出它是直接给 callback 赋值，没有进行上面的 weak self 操作。
* removeDelegate：移除代理。

至此，源码就分析完了。可以看到这个库的代码还是非常短小精悍的。

#### 总结
* 通过 @propertyWrapper 来进行模板代码封装。
* 通过 callback 的重新赋值来实现自动 weak self。
