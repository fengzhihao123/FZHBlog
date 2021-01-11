众所周知，Swift 是一门类型安全的语言，它会通过编译器报错来阻止你代码中不安全的行为。比如变量必须在使用之前声明、变量被销毁之后内存不能在访问、数组越界等问题。

Swift 会通过对于修改同一块内存，同一时间以互斥访问权限的方式（同一时间，只能有一个写权限），来确保你的代码不会发生内存访问冲突。虽然 Swift 是自动管理内存的，在大多数情况下你并不需要关心这个。但理解何种情况下会发生内存访问冲突也是十分必要的。

首先，来看一下什么是内存访问冲突。

### 内存访问冲突
当你设值或者读取变量的值得时候，就会访问内存。
```
var age = 10 // 写权限
print(age) // 读权限
```

当我们对同一块内存，同时进行读写操作时，会产生不可预知的错误。比如上面的 age，假如在你读取它值的期间有别的代码将它设为 20，那么你读取到的有可能是 10，也有可能是 20。这就产生了问题。

内存访问冲突：对同一块内存，同时进行读写操作时，就会造成内存访问冲突。

了解了什么是内存访问冲突，下面来看下什么情况下回造成内存访问冲突。

### In-Out 参数
当 in-out 参数为全局变量，并且该变量在函数体内被修改时，就会造成内存访问冲突。比如下面的代码：
```
var age = 10

func increment(_ num: inout Int) { // step1
    num += age // step2
}
increment(&age)
```
函数在整个函数体内，对所有的 in-out 参数都有写权限。在上述代码中，step1 已经获得了 age 的写权限，而 step2 有得到了 age 的读权限，这样就造成了同一时间对同一块内存，同时进行了读写操作。从而造成了内存访问冲突。

上面的问题可以通过将 age 拷贝一份来解决：
```
// step1
var copyOfAge = age
increment(&copyOfAge)
age = copyOfAge
```

step1 将 age 的值拷贝到另一块内存上，这样在函数体内就是存在对 age 的读权限和对 copyOfAge 的写权限，因为 age 和 copyOfAge 是两块内存，所以就不会造成内存访问冲突。

### 结构体的 mutating 函数
对于结构体的 mutating 函数来说，它整个函数体都有 self 的写权限。
```
struct Person {
    var age: Int
    mutating func increment(_ num: inout Int) { 
        age += num 
    }
}

var p1 = Person(age: 10)
p1.increment(&p1.age)
```
上述的代码编译器会报错：`Overlapping accesses to 'p1', but modification requires exclusive access; consider copying to a local variable`。很明显这是一个内存访问冲突。

inout 参数获得了 p1 的写权限；mutating 函数也获得了 p1 的写权限。同一块内存，同时有两个写操作。造成内存访问冲突。可以通过同上的拷贝操作来解决。

### 值类型的属性
对于结构体、枚举、元祖等值类型来说，修改它们的属性就相当于修改它们整个的值。比如下面的代码：
```
func increment(_ num1: inout Int, _ num2: inout Int) {
    print(num1 + num2)
}

var tuple = (age: 10, height: 20)
increment(&tuple.age, &tuple.height)
```
`&tuple.age` 拿到了 tuple 的写权限，`&tuple.height` 又拿了 tuple 的写权限。同一块内存，同时有两个写操作。造成内存访问冲突。

这个问题可以通过局部变量来解决：
```
func someFunction() {
    var tuple = (age: 10, height: 20)
    increment(&tuple.age, &tuple.height)
}
```
因为在 someFunction() 函数里，age 和 height 没有产生任何的交互(没有在其期间去读取或者写入 age 和 height)，所以编译器可以保证内存安全。

### 总结
* 对同一块内存，同时进行读写操作时，就会造成内存访问冲突。
* 会造成内存访问冲突的情况：
    * In-Out 为全局参数，并且在函数体内修改了它。
    * 结构体的 mutating 函数内修改结构体的值。
    * 同一值类型的多个属性当做函数的 In-Out 参数。
