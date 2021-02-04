### 开篇
在Swift中，有两种传值方式：引用类型(Class)和值类型(Struct/Enum)。而值类型有一个copy的操作，它的意思是当你传递一个值类型的变量的时候(给一个变量赋值，或者函数中的参数传值)，它会拷贝一份新的值让你进行传递。你会得到拥有相同内容的两个变量，分别指向两块内存。

这样的话，在你频繁操作占用内存比较大的变量的时候就会带来严重的性能问题，Swift也意识到了这个问题，所以推出了Copy-on-Write机制，用来提升性能。下面我们来说一下什么是Copy-on-Write。

### 什么是Copy-on-Write
当你有一个占用内存很大的一个值类型，并且不得不将它赋值给另一个变量或者当做函数的参数传递的时候，拷贝它的值是一个非常消耗内存的操作，因为你不得不拷贝它所有的东西放置在另一块内存中。

为了优化这个问题，Swift对于一些特定的值类型(集合类型：Array、Dictionary、Set)做了一些优化，在对于Array进行拷贝的时候，当传递的值进行改变的时候才会发生真正的拷贝。而对于String、Int等值类型，在赋值的时候就会发生拷贝。下面来看代码验证一下：

#### 先看一下基本类型(Int、String等)
```
var num1 = 10
var num2 = num1
print(address(of: &num1)) //0x7ffee0c29828
print(address(of: &num2)) //0x7ffee0c29820

var str1 = "abc"          
var str2 = str1
print(address(of: &str1)) //0x7ffee0c29810
print(address(of: &str2)) //0x7ffee0c29800

//打印内存地址
func address(of object: UnsafeRawPointer) -> String {
    let addr = Int(bitPattern: object)
    return String(format: "%p", addr)
}
```

`从上面的打印我们可以看出基本类型在进行赋值的时候就发生了拷贝操作`

#### 在看一下集合类型
```
var arr1 = [1,2,3,4,5]
var arr2 = arr1
print(address(of: &arr1)) //0x6000023b06b0
print(address(of: &arr2)) //0x6000023b06b0

arr2[2] = 4
print(address(of: &arr1)) //0x6000023b06b0
print(address(of: &arr2)) //0x6000023b11f0
```
`从上面代码我们可以看出，当arr1赋值给arr2时并没有发生拷贝操作，当arr2的值改变的时候才发生了拷贝操作`

Copy-on-Write是一种非常好的方式去优化值类型的拷贝，虽然对于这套底层逻辑我们不用实现，但是了解这个机制对于我们来说还是非常必要的。通过上面的代码我们看到了Copy-on-Write机制是如何发生作用的，但是知道它如何应用是不够的，我们要做到知其然并且知其所以然。所以，接下来我们看一下Swift源代码是如何实现这一机制的。

#### 自定义的结构体并不支持 Copy On Write
```
struct Person {
    var name = ""
}

var p1 = Person(name: "aaa")
print(address(of: &p1)) // 0x104d6a300
var p2 = p1
print(address(of: &p2)) // 0x104d6a310
p2.name = "bbb"
print(address(of: &p2)) // 0x104d6a310
```

上述代码可以看出，虽然将 p1 赋值给了 p2，但它俩的内存地址依然是不同的。由此可见自定义的结构体并不能支持 Copy On Write。

### Copy-on-Write如何实现的
你可以在[OptimizationTips.rst](https://github.com/apple/swift/blob/master/docs/OptimizationTips.rst)里发现如下代码:

```
final class Ref<T> {
  var val : T
  init(_ v : T) {val = v}
}

struct Box<T> {
    var ref : Ref<T>
    init(_ x : T) { ref = Ref(x) }

    var value: T {
        get { return ref.val }
        set {
          if (!isUniquelyReferencedNonObjC(&ref)) {
            ref = Ref(newValue)
            return
          }
          ref.val = newValue
        }
    }
}
```

该例子显示了如何用一个引用类型去实现一个拥有copy-on-write特性的泛型值类型T。具体逻辑就是当你进行set的时候判断是否有多个reference，如果是多个reference则进行拷贝，反之则不会。

### 总结
* Copy-on-Write是一种用来优化占用内存大的值类型的拷贝操作的机制。
* 对于Int、String等基本类型的值类型，它们在赋值的时候就会发生拷贝，它们没有Copy-on-Write这一特性（因为Copy-on-Write带来的开销往往比直接复制的开销要大）。
* 对于Array、Dictionary、Set类型，当它们赋值的时候不会发生拷贝，只有在修改的之后才会发生拷贝，即Copy-on-Write。

### 参考
* [Understanding Swift Copy-on-Write mechanisms](https://medium.com/@lucianoalmeida1/understanding-swift-copy-on-write-mechanisms-52ac31d68f2f)