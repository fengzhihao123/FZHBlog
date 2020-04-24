# LearniOS

## Swift

### Methods

1、定义方法:Swift和Object-C最大的不同是，Swift中类、枚举、结构体都可以定义方法，而在Object-C中，只有类可以定义方法。
2、实例方法(Instance Methods)
实例方法指的是属于某个特定的类、结构体或者枚举的实例的方法(与Object-C中`-`开头的方法类似)，语法和函数一样。
Example:

```
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}

let counter = Counter()
// the initial counter value is 0
counter.increment()
// the counter's value is now 1
counter.increment(by: 5)
// the counter's value is now 6
counter.reset()
// the counter's value is now 0
```

3、一般情况下，在Swift中不需要显性的调用self，但是当名字重复时必须写self

Example: 

```
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
```

4、结构体和枚举是值类型，默认情况下，值类型的属性是不能在它的实例方法中修改的，但是如果你想修改的话，你可以在方法前加上`mutating`关键字。

Example:

```
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
```
注意:你不能用结构体类型的常量来调用mutating方法，因为常量的属性是不变的(值类型的实例，一旦你声明为常量，则它的属性都默认为常量，即使该属性声明为变量)。

Example:

```
let fixedPoint = Point(x: 3.0, y: 3.0)
fixedPoint.moveBy(x: 2.0, y: 3.0)
// this will report an error

```
5、在mutating方法给self分配值(Assigning to self Within a Mutating Method)

Example:

```
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}

var point = Point()
point.moveBy(x: 3, y: 4)
print(point)
//Point(x: 3.0, y: 4.0)
point.moveBy(x: 4, y: 5)
print(point)
//Point(x: 7.0, y: 9.0)
```
6、类型方法(Type Methods)

与实例方法不同的是，类型方法只能由类型调用(类、结构体和枚举都可以创建类型方法，类型方法和Object-C中的类方法类似)。

Example:

```
class SomeClass {
    class func someTypeMethod() {
        // type method implementation goes here
    }
}
SomeClass.someTypeMethod()
```
