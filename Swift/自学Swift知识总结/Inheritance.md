# LearniOS

## Swift

### Inheritance

1、没有继承任何类的类被称为基类，Swift中的类没有继承一个共有的基类(Object-C中所有的类继承NSObject)，如果你定义的类没有继承任何类，那么它将自动成为基类。 

2、定义类的示例:

```
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}
```
3、声明子类的格式:

```
class SomeSubclass: SomeSuperclass {
    // subclass definition goes here
}
```
4、重写父类的方法要使用override关键字

```
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
```

5、重写父类的属性

* 你可以将继承的只读属性重写为读写属性，通过提供getter和setter方法。但是你不能将继承的读写属性重写为只读属性。
* 如果你在重写属性中提供了setter，那么你也一定要提供getter。如果你不想在重写版本中的getter里修改继承来的属性值，你可以直接通super.someProperty来返回继承来的值，其中someProperty是你要重写的属 性的名字

Example:

```
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
```

6、重写属性观察器

* 你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。这些属性的值是不可以被设置的，所以，为它们提供 willSet 或 didSet 实现是不恰当。此外还要注意，你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的setter，那么你在setter 中就可以观察到任何值变化了

Example:

```
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")
// AutomaticCar: traveling at 35.0 miles per hour in gear 4
```

7、你可以通过final关键字来禁止重写，如 final var, final func, final class func, 和final subscript等。

Example:

```
final class Car {
    var name: String = ""
}
```
