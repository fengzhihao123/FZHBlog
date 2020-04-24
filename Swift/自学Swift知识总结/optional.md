# LearniOS

## Swift

### Optional机制

1、什么是Optional机制？

optional机制:就是当你声明optional类型的变量值为空的时候，编译器会自动返回nil。

我们来通过一个例子来理解这一句话，字符串类型转整型。我们知道通过调用函数我们是可以把字符串中的数字转换为整型，但是不是所有的字符串都能转换为整型，比如:`Dota`,那我们应该怎么解决这一问题呢？这就用到了optional机制。例如下面Example1的代码。我们通过编译器发现`convertedNumber`并不是`Int`类型，而是`Int?(等同于optional Int)`类型。我们可以通过判断convertedNumber中的值来知道转换是否成功(如果声明的类型不是optional类型，那么它一定不会为nil)。通过optional机制我们就可以避免程序发生因类型转换而导致的一些计算错误。

注:`在C和Object-C中并没有optional这种机制，和它比较相似的是，当你调用一个返回值为对象的方法时，该方法返回nil(这意味着该对象为空)。然而这个只对对象有效，对于结构体、C的基本类型和枚举是不起作用的。对于这些类型Object-C只能返回一些具体的值(eg:NSNotFound)来表示值缺失。在swift中你可以通过optional来表示值缺失的情况，而不需要给定一个常量。`

Example1 :
```
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
```

Example2 :

```
if convertedNumber != nil {
    // success
}else{
    //fail
}
```

2、在什么情况下使用

当可能发生值缺失(value may be absent)的情况时，你应该使用optional机制。比如Example1的情况。

optional类型的变量会发生两种情况:

* 该变量有值，你可以通过解包(unwarp)的方式来访问该值
* 该变量木有值

3、关于optional返回的`nil`

* 非可选(nonoptional)常量或者变量是不能赋值为nile的，如果你代码中的常量或者变量可能发生值缺失的情况，你应该将它声明为合适的可选(optional)类型
* Swift中的nil和Object-C中的nil是不同的。在OC中，nil是一个指向一个不存在的对象的指针。而在swift中nil并不是一个指针，它是代表值缺失的一种类型。声明为optional的任何类型都能设置为nil，而不仅仅是对象类型(注:在OC中只能把对象类型设置为nil，结构体、枚举和C的基本类型是不能设置为nil的)。

4、和if语句相结合的显式解包

在swift中你可以通过if语句来判断是否有值，例如Example2。如果你确定optional是有值的，你可以通过`!`来解包访问这个值，如Example3。

Example3 :

```
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}
```

注:`如果使用'!'来访问一个没有值的可选类型，如Example4，编译器会报"unexpectedly found nil while unwrapping an Optional value"的错误。当你使用'!'解包时一定要确定optional类型的变量是有值的。`

Example4 :

```
let possibleNumber = "dota"
let convertedNumber = Int(possibleNumber)
let num = convertedNumber!
```

5、Optional Binding

你可以通过`optional binding`来检测optional是否包含值，如果有值的话，它会将值赋值给你定义的常量或者变量。

语法格式如下:

if let `constantName` = `someOptional` {

    `statements`
    
}

你可以通过optional binding的方式来访问Example4中的optional的值，如Example5。在optional binding中你可以使用常量或者变量，如果你想改变Example5中`actualNumber`中的值，你可以将它声明为变量。

Example5 :

```
//如果你想改变actualNumber中的值你可以将其声明为变量,如下
//if var actualNumber = Int(possibleNumber) 
//在if语句中创建的常量或者变量只在这个if语句内可用。
if let actualNumber = Int(possibleNumber) {
    print("\"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("\"\(possibleNumber)\" could not be converted to an integer")
}
```

6、隐式解包(Implicitly Unwrapped Optionals)

隐式解包的用法如Example6所示，

注:

* 如果你访问的隐式解包的变量的值为nil(Example7)，你的程序将会报错。该错误和你强行解包一个值为nil的optional是一样的。
* 当你声明的optional的变量后面可能为nil的时候，不要使用隐式解包。如果在一个变量的声明周期内你需要检测它是否为nil，你应该使用普通的optional。

Example6 :

```
//正常情况
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // requires an exclamation mark
//隐式解包
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // no need for an exclamation mark
```

Example7 :

```
var assumedString: String! = nil
let implicitString: String = assumedString // no need for an exclamation mark
```

7、optaional chaining

关于optional chaining的一些问题，大家可以看一下[喵神写的](http://swifter.tips/optional-chaining/)。我在这里就不赘述了！

8、总结

* 在Swift中nil可以对任意的optional类型使用，而不仅仅是对象类型
* 在optional声明的实例的值可能为nil时，我们永远都要先判断在取值
* 隐式解包也要确定必须包含值

9、参考：

* [Swift 的 Optional 机制有什么用](https://www.zhihu.com/question/28026214)

* [[iOS笔记]Swift中的Optional类型 (可选类型)](http://www.jianshu.com/p/0e3712b0c044)

* Swift Tips

