# LearniOS

## Swift

### Properties

1、计算属性(Computed properties)由类、结构体和枚举提供，存储属性(Stored properties)只能由类和结构体提供(存储属性是存储实例的一个常量或者变量的值，而计算属性则是计算一个值，而不是存储)。

2、当一个值类型(value type)的实例被声明为常量时，它的所有属性也会自动变为常量而不可更改。如果你声明一个引用类型(reference type)的实例，你仍然可以修改它的可变属性。

Example:

```
struct FixedLengthRange {
    var firstValue = 3
}

class Student {
    var age = 3
}

let john = Student()
john.age = 4
let range = FixedLengthRange()
range.firstValue = 3//这句代码报错
```
3、Lazy Stored Properties

lazy property:当该属性第一次被调用时，才会计算它的初始值。用`lazy`标识。

作用:

* 当一个属性的初始值是取决于一直到实例初始化完成才知道值的外部元素的时候(when the initial value for a property is dependent on outside factors whose values are not known until after an instance’s initialization is complete.)。
* 当属性的初始值需要复杂或者大量的计算，可以在需要它的时候再初始化它(when the initial value for a property requires complex or computationally expensive setup that should not be performed unless or until it is needed)。

注意事项:

* 你必须用var关键字将lazy property声明为变量, 因为它的初始值可能在实例初始化完成才会得到。常量属性必须在初始化完成之前就有值，所以它不能用lazy声明。
* 如果一个被标记为lazy的属性在初始化完成之前被多个线程同时访问，则不能保证该属性只被初始化一次。

Example:

```
class DataImporter {
    /*
     DataImporter is a class to import data from an external file.
     The class is assumed to take a non-trivial amount of time to initialize.
     */
    var fileName = "data.txt"
    // the DataImporter class would provide data importing functionality here
}
 
class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // the DataManager class would provide data management functionality here
}
 
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
```
4、计算属性(computed property)

* 一个计算属性(computed property)如果只有getter方法而没有setter方法，那该属性就为只读计算属性。一个只读的计算属性总是返回一个值，它可以通过点语法来访问，但是不能被设置为不同的值。
* 你必须用var关键字将计算属性(包括只读计算属性)声明为变量，因为它们的值不是固定的。let关键字只能适用于常量属性，去说明这些属性一旦被初始化就不会被改变值。

5、属性观察者(property observers)

* 你可以给你定义的任意存储属性添加属性观察者，lazy存储属性除外。
* `willSet`在值被存储前调用。
* `didSet` 在新值被存储之后立刻调用。
* 当一个属性在子类中被设置时，父类的`willSet`和`didSet`也会被调用，子类在父类之后调用。

Example:

```
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps
```

6、全局变量和局部变量(global and local variable)

* 全局变量:定义在任何函数、方法、闭包或者任何类型之外的变量
* 局部变量:定义在函数、方法、闭包里面的变量
* 全局变量或者常量总是被延迟计算，和延迟存储属性不同的是，它不需要lazy关键词修饰。
* 局部常量或者变量永远不会延迟计算。

7、类型属性(type properties)

* 类型属性:为类型本身定义属性，无论创建了多少个该类型的实例，这些属性都只有唯一一份。这种属性就是类型属.请注意它和实例属性是不一样的。实例属性是实例的一种特殊的类型，当你创建每一个实例的时候它的属性都是独立的。

* 比如下面的例子，每个Size的实例的属性都是相对独立的，你可以分别给它们赋值。但是Point则不能，因为它是类型属性(由static关键字修饰)，你只能通过(type)Point来访问它。

Example:

```
struct Size {
    var width = 0.0
    var height = 0.0
}

struct Point {
   static var x = 0.0
   static var y = 0.0
}

var size1 = Size()
size1.width = 10
var size2 = Size()
size2.width = 20
print(size1,size2)
//Size(width: 10.0, height: 0.0) Size(width: 20.0, height: 0.0)
Point.x = 10
Point.y = 20
print(Point.x, Point.y)
//10.0 20.0
```

* 你要通过`static`关键字来定义类型属性。对于类的计算类型属性，你可以使用`class`关键字来支持子类对父类的重写。下面的例子是声明的只读计算属性，你也可以定义为读写属性，语法和计算属性的定义语法一样。

Example:

```
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```

* 这是官方文档上类型属性的一个例子:

代码解读:`thresholdLevel`表示的最大阈值,`maxInputLevelForAllChannels`表示最大的输入值。当你输入的`currentLevel`大于`thresholdLevel`时，`thresholdLevel`会将本身的值赋给`currentLevel`(如第一个if语句)。如果`currentLevel`值大于`maxInputLevelForAllChannels`，`currentLevel`会将本身的值赋给`maxInputLevelForAllChannels`(如第二个if语句)

Example:

```
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // cap the new audio level to the threshold level
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // store this as the new overall maximum input level
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

leftChannel.currentLevel = 7
print(leftChannel.currentLevel)
// Prints "7"
print(AudioChannel.maxInputLevelForAllChannels)
// Prints "7"

rightChannel.currentLevel = 11
print(rightChannel.currentLevel)
// Prints "10"
print(AudioChannel.maxInputLevelForAllChannels)
// Prints "10"
```

参考:

* [StackoverFlow](http://stackoverflow.com/questions/38010936/why-constant-constraints-the-property-from-a-structure-instance-but-not-the-clas)
