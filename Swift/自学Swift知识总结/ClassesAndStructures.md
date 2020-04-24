# LearniOS

## Swift

### Classes and Structures

1、类的实例通常被看做一个对象。然而，Swift中的类和结构体在功能上比其他语言更加相似，本章所讨论的大部分实例都可以应用在类和结构体类型。因此，我们会主要使用实例。

2、当结构体类型在你的代码中传递的时候，它们总是会拷贝。它不会使用引用计数。

3、Classes和Structure的声明语法:

```
class SomeClass {
    
}
struct SomeStructure {

}
```
4、当你定义一个新的类或者结构体的时候，你实际上就是在定义一种新的Swift类型。你应该使用`UpperCamelCase`(eg:SomeClass/SomeStructure)这种命名方式来符合Swift的命名标准(eg:String/Int/Bool)。相反的，你应该用`lowerCamelCase`来个属性或者方法来命名(eg:frameRate/incrementCount)，以便和类型名区分。

```
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
```

5、不像Object-C，Swift可以直接设置结构体属性的子属性的值。如下面的例子，someVideoMode的resolution的属性width的值可以直接设置，而不需要你在给resolution整个赋一个新值。

```
struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someVideo = VideoMode()

someVideo.resolution.width = 200
```

6、结构体另一种初始化方式:

```
let vga = Resolution(width: 640, height: 480)
```

类的实例不能这样初始化。

7、值类型(Value Types):结构体、枚举、其它基本数据类型等都是值类型。当它在赋值给常量/变量或者传递给函数的时候，会拷贝值。通过下面的例子我们可以发现，虽然cinema的width值变了，但hd的width值并没有变。那是因为Resolution是一个结构体，在进行`var cinema = hd`这一句的时候，系统会拷贝一份hd的值赋给cinema。它们两个是独立的两个结构体实例，所以改变cinema的值时，并不会影响hd。枚举同上。

```
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2000
print(hd,cinema)
//Resolution(width: 1920, height: 1080) Resolution(width: 2000, height: 1080)
```

8、引用类型(Reference Types):当它们在赋值或者传递给函数的时候不会拷贝值，因此，应用的是已存在的实例本身，并没有拷贝。通过下面的例子我们可以看出，修改了alsoTenEighty的frameRate的值，tenEighty的frameRate的值页跟着改变了。因为类是引用类型，tenEighty和alsoTenEighty其实引用的是同一个VideoMode实例。实际上，它们只是同一个实例的两个不同的名字。

```
let tenEighty = VideoMode()
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print(tenEighty.frameRate,alsoTenEighty.frameRate)
//30.0 30.0
```

9、通过`===`和`!==`来判断两个实例是否为同一个类。

```
if tenEighty === alsoTenEighty {
    print("yes")
}
//yes
```

`===`和`==`是不同的，`===`代表两个类类型的常量或者变量引用同一个类的实例，而`==`代表两个常量或者变量的值相等。

10、在Swift中String、Array、Dictionary均已结构体的形式实现；Object-C中NSString、NSSArray、NSDictionary均已类的形式实现。

11、在你的代码中，拷贝行为看起来似乎总会发生。然而，Swift在幕后只在绝对必要时才执行实际的拷贝。Swift管理所有的值拷贝以确保性能最优化，所以你没必要去回 避赋值来保证性能最优化。
