本文主要用于需要快速了解 Swift 的基础知识。包含五大块：

* 变量常量
* if、for、while
* 函数
* 集合
* struct 与 class

推荐大家用 Xcode 的 Playground 来了解、练习 Swift 的基础知识。

`本文内容基于 Swift 5.3.`

### 变量常量
在 Swift 中，通过 let 来声明常量，var 来声明变量。

#### let
用 let 修饰的常量赋值后不可修改。
```
let name = "Swift"
// 这句代码会报错：Cannot assign to value: 'name' is a 'let' constant
name = "Objective-C"
```

#### var
用 var 修饰的变量在赋值后仍可以修改它的值。
```
var age = 2012
age = 2011
```
Tips: `Swift 是可以自动进行类型推断的，Compiler 会根据你的赋值自动推断其类型。所以在声明常量或变量的时候可以不写其类型。`

比如下面的代码是等效的：
```
var age = 2012
var age: Int = 2012
```

#### 如何选择使用
* 如果代码中存储的值不需要改变，则使用 let。
* 如果代码中存储的值需要改变，则只用 var。
* 如果代码中存储的值不确定是否需要改变，优先使用 let，后续变更可再改为 var。因为这样能更好的保持代码的健壮性。

### if、for、while

#### if
if 后的判断条件不需要写小括号。
```
let age = 18
if age < 18 {
    print("Denied")
} else {
    print("Allow")
}
```

#### for
在 Swift 中，弃用了 for(int i = 0; i <= 10, i++) 这种方式，而是采取了更加简洁的 for-in 。
```
// 0...10 等价于 [0...10]
for i in 0...10 {
    print(i)
}

// 0...10 等价于 [0...10)
for i in 0..<10 {
    print(i)
}
```

#### while
```
var count = 10
while count > 0 {
    print(count)
    count -= 1
}
```
需要特别指出的是：Swift 不支持 `count--` 或 `--count` 这种语法，因为这种代码比较容易出错，且不易于阅读。

### 函数
通过 func 关键字来声明函数。
```
// 无参无返回值
func doSomething() { }
// 有参无返回值
func doSomething(parameter: Int) { }
// 多个参无返回值。parameter1 、parameter2 只为示意，真实项目中的代码不要这样命名。
func doSomething(parameter1: Int, parameter2: Int) -> Int { return 0 }
// 有参有返回值
func doSomething(parameter: Int) -> Int { return 0 }
```

* 函数中的参数默认是 let 修饰，即不可修改的。如果想修改需添加 inout 关键字。
```
func doSomething(parameter: inout Int) {  }
```
* 可以在参数前面添加 _，从而在调用是忽略参数名。
```
func doSomething(parameter: Int) {  }
doSomething(parameter: 10)

func doSomething1(_ parameter: Int) {  }
doSomething1(10)
```
* 参数设置默认值。
```
func doSomething(parameter: Int = 1024) {  }
// parameter 默认值为 1024
doSomething()
```
### 集合

#### Array
Array：用来存储一组同类型、有序的数据。
```
// 声明
var nums = [1, 2, 3, 4]
// 尾部添加
nums.append(5) // 1 2 3 4 5
// 移除第一个元素
nums.remove(at: 0) // 2 3 4 5
// 移除尾部元素
nums.removeLast() // 2 3 4
// 移除首部元素
nums.removeFirst() // 3 4
// 在 index 为 2 的位置插入 10
nums.insert(10, at: 2) // 3 4 10
// 删除全部元素
nums.removeAll() // []
```

* 不要对空数组调用 removeLast/removeFirst 函数。
* remove/insert 函数的索引应是有效的。

#### Dictionary
Dictionary：用来存储键值对，它的 key 是唯一的，且数据是无序的。
```
// 声明
var goods = ["name": "appale", "price": "20"]
// 添加键值对
goods["weight"] = "10.0" // ["name": "appale", "weight": "10.0", "price": "20"]
// 修改
goods["name"] = "orange" // ["price": "20", "name": "orange", "weight": "10.0"]
// 获取所有的 key
goods.keys //["name", "price", "weight"]
// 移除某个键值对
goods["name"] = nil // ["price": "20", "weight": "10.0"]
// 移除所有元素
goods.removeAll()
```

#### Set
Set：用来存储一组同类型、无序、值唯一的数据。

```
// 声明
var set = Set<Int>()
// 添加元素
set.insert(10) // [10]
set.insert(20) // [20, 10]
// 因为 set 值唯一，所以还是 [20, 10]
set.insert(10) // [20, 10]
// 移除头部元素
set.removeFirst() // [10] 或者 [20]
// 移除所有元素
set.removeAll()
```

* removeFirst：因为 Set 是无序的，所以它移除的并不一定是最先添加进去的元素。并且不要对空的 set 调用该函数。

### struct 与 class
#### struct
用 struct 关键字修饰，可以声明属性和函数。
```
// 定义
struct Person {
    let name: String
    let age: Int
    
    func run() { }
}
// 使用
let person = Person(name: "jack", age: 10)
person.run()
```

* struct 在 Swift 中是值类型，为内容拷贝。具体参见下方代码：
```
let jack = Person(name: "jack", age: 10)
var rose = jack
// 虽然 rose 的内容是从 jack 来的，但修改 rose 的 name 属性并不会影响 jack 的name 属性。
rose.name = "rose"

print(rose.name, jack.name) // rose jack
```
* struct 默认会提供构造函数。

#### class
用 class 关键字修饰，可以声明属性和函数。
```
// 声明
class Person {
    var name: String
    let age: Int
    
    func run() { }
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// 使用
let jack = Person(name: "jack", age: 10)
var rose = jack
rose.name = "rose"
print(rose.name, jack.name) // rose rose
```
* class 在 Swift 是引用类型，为指针拷贝。所以👆的代码改变了 rose 的 name 值，jack 的 name 值也跟着改变。
* class 不会提供构造函数，需要自己创建。

### 总结
* 介绍了 var/let 、if/for/while、函数、集合、struct/class。
* var 声明可变的数据；let 声明不可变的数据。
* Array 存储一组同类型、有序的数据；Ditionary 存储键唯一且无序的键值对；Set 存储一组同类型、无序且值唯一的数据。
* struct 为值类型，系统默认提供构造函数；class 为引用类型，系统不提供构造函数，需自己创建。

### 参考
* [Apple Document](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)