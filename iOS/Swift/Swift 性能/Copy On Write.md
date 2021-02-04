### 什么是 Copy On Write
Copy On Write 是一种通用的优化手段，用来帮助优化结构体的拷贝效率。

假设有一个包含 1000 个元素的数组，如果你想将该数组拷贝一份给另一个变量，正常情况下，系统会开辟一块内存来存放这 1000 个元素。但实际上你拷贝之后，并没有对它进行写的操作，只是读取它的值。那在这种情况下，新开辟的内存实际上就被浪费了，而且开辟内存也是比较耗时的操作。

那么，在 Swift 中是如何优化上述情况呢？答案就是：Copy On Write。在 Swift 中，当你将数组赋值给新的变量时，它不会新开辟内存，而是将新变量的指针指向初始数组的内存地址。仅当你去修改新变量的值时，系统才会真正的开辟一块内存来存储初始数组的元素。

一句话总结就是：仅在修改元素时才会开辟新内存。

### 代码说明
```
func address(o: UnsafeRawPointer) -> Int {
    return Int(bitPattern: o)
}

let arr1 = Array(repeating: 5, count: 1000)
print(NSString(format: "%p", address(o: arr1))) // 0x7fcfb6820e20

var arr2 = arr1
print(NSString(format: "%p", address(o: arr2))) // 0x7fcfb6820e20

arr2[1] = 2
print(NSString(format: "%p", address(o: arr2))) // 0x7fcfb7852e20
```

上述代码可以看出，当将 arr1 赋值给 arr2 时，arr1 和 arr2 的内存地址是相同的，而当修改了 arr2 中的元素时，arr2 的内存地址发生了改变。从而证明了 Copy On Write 仅在修改元素时才会开辟新内存。

### 自定义的结构体并不支持 Copy On Write
```
var p1 = Person(name: "aaa")
print(NSString(format: "%p", address(o: &p1))) // 0x111b032f0
var p2 = p1
print(NSString(format: "%p", address(o: &p2))) // 0x111b03300
p2.name = "bbb"
print(NSString(format: "%p", address(o: &p2))) // 0x111b03300
```
上述代码可以看出，虽然将 p1 赋值给了 p2，但它俩的内存地址依然是不同的。由此可见自定义的结构体并不能支持 Copy On Write。