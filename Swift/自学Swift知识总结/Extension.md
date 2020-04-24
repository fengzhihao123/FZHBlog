请在阅读本文章时，顺手将文中的示例代码在playground中敲一遍，这样能加深理解！！！
阅读该文章大约需要:15分钟
读完之后你能获得:
1、Extension是什么
2、它能做什么

## 本文全部内容基于Swift版本:3.0.1

## Extension的基本语法

```
extension SomeType {
    // new functionality to add to SomeType goes here
}
```

Tip:`扩展可以为一个类型添加新的功能，但是不能重写已有的功能。`

```
struct Student {
    var name = ""
    var age = 1
    func print() {
        
    }
}

extension Student {
    //改行会报错`invalid redeclaration print()`重复声明print()，重写变量也是不行的。
    func print() {
    }
}
```

## Swift中的Extension可以做什么

我们想知道Extension在Swift中能做些什么，最直接的方法就是查看Swift的官方文档了。下面是文档中指出Extension能做的六个方面。

* 添加计算型实例属性和计算型类型属性
* 定义实例方法和类型方法
* 提供新的构造器
* 定义下标
* 定义和使用新的嵌套类型
* 使已存在的类型遵守某个协议

看完上面Extension能做的六个方面，我们来逐条解释说明一下:

### 添加计算型实例属性和计算型类型属性

首先我们要了解什么是计算型属性，计算型属性(computed property)不直接存储值，而是提供一个`getter`和一个可选的`setter`，来间接获取和设置其他属性或变量的值。关于更多的计算型属性的内容请自行查看[官方文档](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID254)，在此不再赘述。那么我们什么场景可以用到这个功能呢？举一个最常见的例子，当你想访问某个view的width的时候，通常情况下你会这么写:

```
view.frame.size.width
```

但是这样写很长很不方便，作为一个懒惰的程序员，这时候你就要想我能不能缩短访问该属性的代码。不要犹豫了骚年，这时候你只需要写一个UIView的Extension就可以达到你的目的。

```
extension UIView {
    var x: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.size.width
        }
    }
    var height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.size.height
        }
    }
}
```

这样你就可以通过来访问该属性。怎么样，有没有感受到Extension的便利之处。

```
view.width
```

### 定义实例方法和类型方法

在你辛辛苦苦写完一个Student类后，万恶的产品过来告诉你需求改了，这时虽然你心中有一万只草泥马在奔腾，但是为了心中那份神圣的程序员的责任感(当然还有糊口的工资)，你还是要修改代码。如果你想在不改变原始类的基础上添加功能，那你可以给Student类添加Extension来解决问题。

Tip:`这里值得注意的一点是在Swift中，Extension可以给类和类型添加，比如你也可以给一个struct添加Extension，而在Objective-C中，你只能给类添加Extension。`

```
class Student {
    var name = ""
    var age = 1
}

extension Student {
    func printCurrentStudentName() {
        print(self.name)
    }
}

var jack = Student()
jack.name = "jack"
jack.printCurrentStudentName()
```

### 提供新的构造器(Initializers)

最常见的Rect通常由`origin`和`size`来构造初始化，但是如果在你写完Rect的定义后，你偏偏想要通过center和size来确定Rect(作为一个程序员就要有一种作死的精神)，那你就要用Extension来给Rect提供一个新的构造器。关于更多关于构造器的信息，请参考[官方文档](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID203)

`本例子来源官方文档`

```
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                          size: Size(width: 5.0, height: 5.0))
```

通过Extension来给Rect添加一个新的构造器。

```
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

这样你就可以通过新的构造器来初始化Rect。

```
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)
```


### 定义下标

通过Swift中的Extension，你可以给已知类型添加下标。例如下面的例子就是给`Int`类型添加一个下标，该下标表示十进制数从右向左的第n个数字。

`本例子来源官方文档`

```
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
// 5
746381295[1]
// 9
```

### 定义和使用新的嵌套类型(nest type)

Extensions可以给已知的类、结构体、枚举添加嵌套类型。下面的例子是给Int类型添加一个判断正负数的Extension，该Extension嵌套一个枚举。

`本例子来源官方文档`

```
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
// Prints "+ + - 0 - 0 + "
```


### 使已存在的类型遵守某个协议

编写使该类型遵守某个协议的Extension的语法如下:

```
extension SomeType: SomeProtocol, AnotherProtocol {
    // implementation of protocol requirements goes here
}
```

示例代码:

```
protocol StudentProtocol {
    var address: String { get }
}

struct Student {
    var name = ""
    var age = 1
    
}

extension Student: StudentProtocol {
    var address: String {
        return "address"
    }
}

var jack = Student()
jack.address
//输出 address
```

若添加Extension的类型已经实现协议中的内容，你可以写一个空的Extension来遵守协议:

```
protocol StudentProtocol {
    var address: String { get }
}

struct Student {
    var address: String {
        return "address"
    }
    var name = ""
    var age = 1
}

extension Student: StudentProtocol {}

var jack = Student()
jack.address
//输出 address
```

## 总结

* Extension可以为一个已有的类、结构体、枚举类型或者协议类型添加新功能。
* 可以在没有权限获取原始源代码的情况下扩展类型的内容
* Extendion和Objective-C中的Category类似。(OC中的Category有名字，Swift中的扩展没有名字)

下篇预告:Swift-Protocol

若本文有何错误或者不当之处，还望不吝赐教。谢谢！

[Swift-Extension的官方文档](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html#//apple_ref/doc/uid/TP40014097-CH24-ID151)