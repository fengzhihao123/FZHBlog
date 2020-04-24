# LearniOS

## Swift

### Control Flow

#### While

1、Repeat-While

Swift中的`repeat-while`类似于其它语言中的`do-while`。

2、条件语句(Conditional Statements)

Swift提供两种方式可以在你的代码中添加条件语句:if语句和switch语句。通常情况下，当有很少的可能性的时候，你可以用if语句来判定结果。switch更适用于复杂的条件判断。

3、Switch

* 与C和Object-C中的switch不同，Swift中的switch执行完匹配的case语句后，不会执行后面的语句。这也就是说，不需要在 case 分支中显式地使用 break 语 句。这使得 switch 语句更安全、更易用，也避免了因忘记写 break 语句而产生的错误。

* 虽然break在Swift中不是强制要求的，你仍然可以使用break语句来匹配或者忽略摸个特定的case，或者在某个匹配case完成之前跳出该case。

* 每个case必须包含一个可执行的语句。如下面例子中第一个case是无效的，因为它没有可执行语句。

```
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a": // Invalid, the case has an empty body
case "A":
    print("The letter A")
default:
    print("Not the letter A")
}
// This will report a compile-time error.
```

* 通过下面的例子我们可以看出，Swift中的switch可以在一个case中同时包含"a"和"A", 通过逗号分隔。

```
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}
// Prints "The letter A"
```

* 你可以使用元祖在一个switch语句中测试多个值，如下例:

```
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _):
    print("(0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}
```

4、控制语句中的关键字

* continue:语句告诉一个循环体立刻停止本次循环，重新开始下次循环。就好像在说“本次循环我已经执行完 了”，但是并不会离开整个循环体。
* break:break 语句会立刻结束整个控制流的执行。当你想要更早的结束一个 switch 代码块或者一个循环体时，你都可以 使用 break 语句。
* fallthrough:Swift 中的 switch 不会从上一个 case 分支落入到下一个 case 分支中。如果你确实需要 C 风格的贯穿的特性，你可以在每个需要该特性的 case 分支中使用 fallthrough 关键字。下面 的例子使用 fallthrough 来创建一个数字的描述语句。

```
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)
// Prints "The number 5 is a prime number, and also an integer."
```

* return
* throw

5、guard像if语句一样，guard的执行取决于一个表达式的布尔值。我们可以使用guard语句来要求条件必须为真时，以执行guard语句后的代码。不同于if语句，一个guard语句总是有一个else从句，如果条件不为真则执行 else从句中的代码。具体用法请看示例:

```
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    
    print("Hello \(name)!")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    
    print("I hope the weather is nice in \(location).")
}
 
greet(person: ["name": "John"])
// Prints "Hello John!"
// Prints "I hope the weather is nice near you."
greet(person: ["name": "Jane", "location": "Cupertino"])
// Prints "Hello Jane!"
// Prints "I hope the weather is nice in Cupertino."
```

6、检查API是否可用

你可以在if或者guard语句中判断你所使用的API在当前系统下是否可用。

eg:

```
if #available(iOS 10, macOS 10.12, *) {
    //可以在iOS10和macOS10.12使用 
} else {
    // 可以在更早的系统上使用
}
```

语法:

```
if #available(platform name version, ..., *) {
    statements to execute if the APIs are available
} else {
    fallback statements to execute if the APIs are unavailable
}
```

