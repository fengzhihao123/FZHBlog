# LearniOS

## Swift

### let&var

#### 1、let

1)let代表什么

在Swift中let表示你声明的是一个常量，在你给该常量赋值后就不能改变它的值。(`The value of a constant cannot be changed once it is set`)

Example:

```
let maximumNumberOfLoginAttempts = 10
```

上面代码的含义:声明了一个新的常量叫做`maximumNumberOfLoginAttempts`，并且给它赋初值为10。

2)理解let

* `let`和C中的`const pointer`有一点像。如果你用let创建了一个对象常量，你可以修改该对象的属性或者调用该对象的相关方法，但是你不能再分配另一个对象给该常量，因为它是不可变的。

Example:

```
class Student{
    var name = ""
    var age = 0
}

let stu = Student()
//虽然stu是常量，但是我们可以修改它的属性。(前提：使用var声明属性，如果用let，stu的属性是不可改变的)
stu.name = "joy"
stu.age = 18
```

* let同样作用于集合类型和基本类型。如果你创建一个结构体常量，你不能改变它的属性也不能调用任何改变它值的方法。

Example:

```
struct Student{
    let name: String = ""
    var age: Int = 0
}

let student = Student()
//该句会报错
//虽然你在结构体内部用vard声明的age，但是你将student定义为常量，所以你不能改变age的值
student.age = 5
```

* 如果你用let声明一个数组/字典，你是不能改变它的内部元素的，如果你想改变集合的内部元素必须将其声明为var。

Example:

```
let array = [1,2,3,4]
//该句会报错,将let改为var就会修复该错误
array[0] = 4
```

#### 2、var

1)var代表什么

在Swift中用var声明的是一个变量，它的值是可以随时更改的。(`whereas a variable can be set to a different value in the future`)

```
var currentLoginAttempt = 0
```

上面代码的含义:声明一个叫`currentLoginAttempt`的变量，并且给它赋初值为0

#### 3、总结

* 如果你代码中存储的值不会改变，你应该用let将它声明为常量
* 仅在存储的值需要改变的时候使用var
* 在你的代码中，如果声明的变量的值在其生命周期中没有改变，编译器会建议将其换为常量。

#### 4、参考：
* [How exactly does the “let” keyword work in Swift?](http://stackoverflow.com/questions/24002999/how-exactly-does-the-let-keyword-work-in-swift)
* [apple](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309)
* [Swift中的let和var背后的编程模式](http://www.infoq.com/cn/articles/programming-model-behind-let-and-var-in-swift)
