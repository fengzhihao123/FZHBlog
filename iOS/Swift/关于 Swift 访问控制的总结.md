### 为什么需要访问控制（Access Control）
访问控制可以限制别的源文件或者模块来访问你的代码。该特性可以让你隐藏代码的具体实现，从而使代码有更好的`封装性`。

### 5 个关键字
对于访问控制，Swift 提供了五个关键字。根据可访问的优先级，从高到低依次为：open、public、internal、fileprivate、private。

下面来总结一下这几个关键字的区别：
* open：本模块和其他模块都能访问，只能应用在类或者类成员上。允许其他模块继承或重写。
* public：本模块和其他模块都能访问，不允许其他模块继承或重写。
* internal：本模块能访问。不写访问控制关键字，默认为 internal。
* fileprivate：当前源文件访问。
* private：只允许在当前定义体内使用。

关于 public 还有一点值得注意：当使用 public 去修饰一个类型的时候，该类型是 public，但其成员、方法默认是 internal 的。如果你想要使其可以让其他模块调用，必须要显式的用 public 修饰。这样做的目的是防止该类型中 internal 的代码被当做 public 公开。


### 指导准则
来自官方文档的指导原则：`No entity can be defined in terms of another entity that has a lower (more restrictive) access level.`

翻译：一个实体不可以被更低访问级别的实体多定义。

代码举例：
```
fileprivate class Student { }
// Error: Constant cannot be declared public because its type 'Student' uses a fileprivate type
public let stu = Student()
```
如上述代码所示，stu 用 `public` 修饰，而 Student 使用 `fileprivate`。这样就导致了 stu 的访问权限比 Student 的`高`，从而造成编译器错误。将 Student 改为 public 或 open 即可消除编译器错误。

代码示例：
```
public class SomePublicClass {                  // explicitly public class
    public var somePublicProperty = 0            // explicitly public class member
    var someInternalProperty = 0                 // implicitly internal class member
    fileprivate func someFilePrivateMethod() {}  // explicitly file-private class member
    private func somePrivateMethod() {}          // explicitly private class member
}
```
虽然 SomePublicClass 为 public，但 someInternalProperty 是 internal ，即别的模块无法调用，只能访问显式 public 的 somePublicProperty。

### 元组（Tuple）
元组类型的访问控制 ≤ 元组类型中最小的。

```
struct Dog { }
fileprivate struct Cat { }

fileprivate var ani: (Dog, Cat)
```
因为 fileprivate 小于 internal，所以 ani 只能使用 `fileprivate` 或者 `private` 修饰，否则会有编译器错误。

### 泛型
泛型类型的访问控制须 ≤ `类型访问级别` 以及 `所有泛型类型参数的访问级别`的最小值。
```
struct Dog { }
fileprivate struct Cat { }
public struct Person<T1, T2> { }

fileprivate var p = Person<Cat, Dog>()
```

上述代码，虽然 Person 使用 public 修饰，但 Cat 使用的 fileprivate， fileprivate 小于 public 和 internal。所以 p 的访问权限修饰符只能使用 `fileprivate` 或者 `private` 修饰，否则会有编译器错误。

### 成员与嵌套类型
类型的访问控制会影响到成员（属性、方法、构造器、下标）、嵌套类型的访问控制。
* 一般情况下，类型为 fileprivate 或 private，那么成员和嵌套类型也默认为 fileprivate 或 private。
* 一般情况下，类型为 internal 或 public，那么成员和嵌套类型默认为 public。

```
public class SomePublicClass {                  // explicitly public class
    public var somePublicProperty = 0            // explicitly public class member
    var someInternalProperty = 0                 // implicitly internal class member
    fileprivate func someFilePrivateMethod() {}  // explicitly file-private class member
    private func somePrivateMethod() {}          // explicitly private class member
}

class SomeInternalClass {                       // implicitly internal class
    var someInternalProperty = 0                 // implicitly internal class member
    fileprivate func someFilePrivateMethod() {}  // explicitly file-private class member
    private func somePrivateMethod() {}          // explicitly private class member
}

fileprivate class SomeFilePrivateClass {        // explicitly file-private class
    func someFilePrivateMethod() {}              // implicitly file-private class member
    private func somePrivateMethod() {}          // explicitly private class member
}

private class SomePrivateClass {                // explicitly private class
    func somePrivateMethod() {}                  // implicitly private class member
}
```

### 成员的重写
* 子类重写成员的访问控制须 ≥ 子类，或者 ≥ 父类被重写成员。
* 父类的成员不能被成员作用域外定义的子类重写。

```
public class Person {
    private var age = 0
}
// Error: Property does not override any property from its superclass
class Student: Person {
    override var age: Int {
        set {}
        get { 10 }
    }
}
```
因为子类中的 age 访问控制为 internal，而父类中的 age 访问控制为 private， internal ≥ private （子类的重写成员访问控制≤ 父类被重写成员，不符合👆的第一条），因此造成编译器错误。将 private 删除即可消除错误。

若不想删除 private 也可做以下修改：
```
public class Person {
    private var age = 0
    
    class Student: Person {
        override var age: Int {
            set {}
            get { 10 }
        }
    }
}
```
因为 age 的作用域就是 Person 的整个大括号，所以这样符合👆的第二条。

### Getter、Setter
get/set 的访问控制默认与所属环境一致，即该类型为 private ，则get/set 也为 private。

在日常开发中，我们经常会碰到这样一个问题：允许别人读取该属性的值，但`不允许修改`。如何实现这个呢？答案就是使用 `private(set)`。

```
public class Person {
    private(set) var age = 0
}
```
age 外部可读但不可写。

### 构造器
* 如果别的模块想要调用 public 修饰的类的默认构造器，则需用 public 显式的修饰默认构造器。因为默认构造器是 internal。
* 如果结构体中有 fileprivate、private的存储属性，那么成员构造器也需预期保持一致。

### Enum
* 所有 case 自动与 enum 的访问控制保持一致。
* case 不能单独设置访问控制。

```
public enum CompassPoint {
    case north // public
    case south // public
    case east // public
    case west // public
}
```
CompassPoint 的所有 case 都为 public，不能给他们设置别的访问控制。

### Protocol
协议中定义的内容自动与类型的访问控制保持一致，不可单独设置访问控制。

大家可以看一下下面的代码是否能编译通过：
```
public protocol PublicProtocol {
    func test() // public
}

public class PublishClass: PublicProtocol {
    func test() { }
}
```

答案是不能，因为 public 修饰的 PublishClass，它的 test() 默认是 internal，而 PublicProtocol 的 test() 是 public，所以报错。正确代码如下：
```
public class PublishClass: PublicProtocol {
    public func test() { }
}
```
### Extension
* 如果显式的设置了 extension 的访问控制，extension 的成员自动接收 extension 的访问控制。

```
struct Student { }
private extension Student {
    func run() { } // private
}
```
* 若没有显式设置，则 extension 中的成员与类型中定义的成员访问控制一致。
```
extension Student {
    func write() { } // internal
}
```
* 可以单独给 extension 中的成员设置访问控制。
```
extension Student {
    private func eat() { } // private
    func read() { } // internal
}
```
* 不能给用于遵守协议的 extension 显式设置 extension 的访问控制。
```
protocol TestProtocol {
    func test()
}

// Error: 'internal' modifier cannot be used with extensions that declare protocol conformances
internal extension Student: TestProtocol {
    func test() { }
}
```

* [Apple Document](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html)