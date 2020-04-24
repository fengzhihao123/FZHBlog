# LearniOS

## Swift

### Automatic Reference Counting

#### 循环引用(strong reference cycles)

1、代码示例:

```
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}
 
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
//虽然你置为nil，但是这两个类的实例并没有释放内存，没有执行print语句
john = nil
unit4A = nil
```

2、两种解决办法:

* 当其他的实例有更短的生命周期的时候，使用weak
* 当其他的实例有相同的或者更长的生命周期的时候，使用unowened

3、weak和unowened的使用

* weak的使用

将上述代码的Apartment中的Person实例前添加weak关键字，在运行上述代码就会执行print

```
weak var tenant: Person?
```

* unowened的使用

```
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}
 
class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john: Customer?
john = Customer(name: "John Appleseed")
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
john = nil
// Prints "John Appleseed is being deinitialized"
// Prints "Card #1234567890123456 is being deinitialized"
```

#### 闭包的循环引用(strong references for closures)

```
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
paragraph = nil//不会执行print
```

可以定义capture list来解决

```
//有参数
lazy var someClosure: (Int, String) -> String = {
    [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
    // closure body goes here
}
//无参数
lazy var someClosure: () -> String = {
    [unowned self, weak delegate = self.delegate!] in
    // closure body goes here
}
```

修改上述例子后的代码:

```
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
paragraph = nil//执行print
```

Tip:

* ARC只是用于类，不适用于结构体和枚举
* 当ARC设置的weak引用指为nil时，属性观察者不会被调用
* 当你在确定引用的实例永远不会销毁的时候，使用unowened，如果你想访问被释放的owened属性，你会遇到运行时错误。
* owened有安全和不安全两种模式，上面示例中为安全模式，你可以使用unowned(unsafe)来实现不安全模式。如果你试图访问被释放的不安全指向的实例，你的程序将会访问该实例曾经存储的内存地址，这是一个不安全的操作
