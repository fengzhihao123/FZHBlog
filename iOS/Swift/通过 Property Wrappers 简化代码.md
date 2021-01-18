### 什么是 Property Wrappers
属性包装器，Swift 的特性之一。用来修饰属性，它可以抽取关于属性重复的逻辑来达到简化代码的目的。比如线程安全检查、将数据存到数据库等。

### 如何使用
通过 `@propertyWrapper` 来标识。下面通过一个例子来说明它是如何使用的。

#### 基本使用
假设有一个 SmallRectangle 的结构体，它有 height 和 width 两个属性，需要将两个属性的值都限制在 12 以下。

根据上述的需求，先创建一个 TwelveOrLess 限制条件的结构体：
```
@propertyWrapper
struct TwelveOrLess {
    private var number: Int
    init() { self.number = 0 }
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}
```

在 SmallRectangle 结构体上使用：
```
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Prints "0"

rectangle.height = 10
print(rectangle.height)
// Prints "10"

rectangle.height = 24
print(rectangle.height)
// Prints "12"
```

通过上面的代码可以看出，使用 @TwelveOrLess 修饰的属性可以自动将值限制在 12 及以下。

那么，当使用 `@TwelveOrLess var height: Int` 这句代码时，实际发生了什么呢？
```
// 这句代码 @TwelveOrLess var height: Int 相当于下面的代码（编译器会自动转为下面的代码）：
private var _height = TwelveOrLess()
var height: Int {
    get { return _height.wrappedValue }
    set { _height.wrappedValue = newValue }
}
```

`rectangle.height = 24` 这句代码的调用路径：

* 调用 SmallRectangle height 的 set 函数。
* 调用 TwelveOrLess wrappedValue 的 set 函数。
* 调用 `number = min(newValue, 12)` 来保证新设置的值小于等于 12。

#### 设置初始值
将上面的 SmallRectangle 改写为下面的代码你会发现报错 - `Argument passed to call that takes no arguments`：
```
struct SmallRectangle {
    @TwelveOrLess var height: Int = 1
    @TwelveOrLess var width: Int = 1
}
```

这是因为我们的 TwelveOrLess 并没有提供有参的初始化函数。在 TwelveOrLess 添加有参的初始化函数即可解决：
```
init(wrappedValue: Int) {
    number = min(12, wrappedValue)
}
```

假如我们的条件变量 12 也是可以动态的设置，可以再添加一个初始化函数，用来设置条件变量：
```
init(wrappedValue: Int, maximum: Int) {
    self.maximum = maximum
    number = min(maximum, wrappedValue)
}
```

使用 init(wrappedValue: Int, maximum: Int) 初始化属性：
```
struct NarrowRectangle {
    @TwelveOrLess(wrappedValue: 2, maximum: 5) var height: Int
    @TwelveOrLess(wrappedValue: 3, maximum: 4) var width: Int
}

var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)
// Prints "2 3"

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)
// Prints "5 4"
```

`Tips：当没有给 @TwelveOrLess 修饰的变量赋初始值时，默认使用 init() 初始化。`
```
struct ZeroRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)
// Prints "0 0"
```

#### ProjectedValue
projectedValue 用来获取你定义逻辑的一些额外状态值。

比如在上面的例子中，你想获取你设置的值是否超过了限定的最大值，这个就可以用 projectedValue 来获取。
```
@propertyWrapper
struct TwelveOrLess {
    private var number: Int
    private var maximum: Int
    var projectedValue: Bool
    
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
    
    init() {
        projectedValue = false
        self.number = 0
        self.maximum = 12
    }
    
    init(wrappedValue: Int) {
        projectedValue = false
        maximum = 12
        number = min(maximum, wrappedValue)
    }
    
    init(wrappedValue: Int, maximum: Int) {
        projectedValue = false
        self.maximum = maximum
        number = min(maximum, wrappedValue)
    }
}
```

获取状态值：
```
struct SomeStructure {
    @TwelveOrLess var someNumber: Int
}
var someStructure = SomeStructure()

someStructure.someNumber = 4
print(someStructure.$someNumber)
// Prints "false"

someStructure.someNumber = 55
print(someStructure.$someNumber)
// Prints "true"
```
`通过 $+属性名的方式来获取 projectedValue.`

当设值为 4 的时候，没有大于 12，没有触发条件，所以 `$someNumber` 为 false；当设值为 55 的时候，大于 12，触发了条件，所以 `$someNumber` 为 true。

### 实际项目应用

* 将字符串字符全部小写:
```
@propertyWrapper
struct LowerLetter {
    private var value = ""
    var wrappedValue: String {
        set {
            value = newValue.lowercased()
        }
        get { return value}
    }
    
    init(wrappedValue: String) {
        value = wrappedValue.lowercased()
    }
}

struct Person {
    @LowerLetter var name: String
}

let p = Person(name: "ABCd")
p.name // abcd
```
* [自动 weak self](https://github.com/dreymonde/Delegated)：
```
// 声明
@propertyWrapper
public final class Delegated1<Input> {
    public init() { self.callback = { _ in } }
    private var callback: (Input) -> Void
    public var wrappedValue: (Input) -> Void { return callback }
    public var projectedValue: Delegated1<Input> { return self }
}

public extension Delegated1 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input) -> Void) {
        self.callback = { [weak target] input in
            guard let target = target else {
                return
            }
            return callback(target, input)
        }
    }
}

// 使用
final class TextField {
    @Delegated1 var didUpdate: (String) -> ()
}

let textField = TextField()

textField.$didUpdate.delegate(to: self) { (self, text) in
    // `self` is weak automatically!
    self.label.text = text
}
```