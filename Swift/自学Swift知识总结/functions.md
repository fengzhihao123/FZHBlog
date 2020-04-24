# LearniOS

## Swift

### Functions

1、虽然(Example1)中的函数没有返回值类型，但是严格的讲，该方法(`greet(person:)`)还是返回了一个值，即使没有定义返回值。如果函数没有定义返回值的话，它默认会返回一个类型为Void的具体值。会返回一个空的元祖(`写做()`)。

Example1 :

```
func greet(person: String) {
    print("Hello, \(person)!")
}
```

2、返回值可以被忽略。

返回值可以被忽略，但是一个声明了返回值的函数必须有返回值。如果你声明的函数有返回值，而你的函数体内并没有返回值的话，编译器会报错。

3、`(Int, Int)?`和`(Int?, Int?)`是不同的。一个可选的元祖类型，并不是意味着它包含的每个值都是可选类型。

Example2 :
```
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

4、如果你不想每个参数都写一个参数标签，你可以使用'_'来代替参数标签(eg:Example3)。

Example3 :

```
func someFunction(_ firstParameterName : Int, secondParameterName: Int) {
    // _代表第一个参数
}
someFunction(1, secondParameterName: 2)
```

5、通过在参数类型后面给参数添加一个值，你可以定义任何参数的默认值。如果参数被设置默认值，在调用该方法的时候你可以忽略该参数(Example4)。

Example4 :

```
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {

}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault 为 6
someFunction(parameterWithoutDefault: 4) // parameterWithDefault 为 12
```

6、一个可变参数可以接受0个或者多个指定类型的参数。 你使用可变参数来指定在调用函数时，参数可以传递不同数量的输入值. 在参数类型后面添加三个点(...)来表明它为可变参数(Example5)。

* 一个函数最多有一个可变参数。
* 函数参数默认为常量。

Example5 :

```
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// return 3
arithmeticMean(3, 8.25, 18.75)
// returns 10.0
```

7、输入输出参数不能有默认值，并且可变参数不能标记为inout。你只能将变量声明为in-out参数。

8、In-out参数和函数的返回值是不一样的。下面的例子并没有定义返回值，但是它仍然能修改someInt和anotherInt的值。In-out可以影响函数体外的参数值(Example6)。

Example6 :
```
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
//someInt = 107 anotherInt = 3
```

9、函数解读

Example7 :

```
func printHelloWorld() {
    print("hello, world")
}
```

上面函数的类型为`() -> Void`，或者是一个没有参数，返回值为Void的函数。

Example8 :

```
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts
```

定义一个名字为mathFunction的变量，它的类型为:有两个Int类型的参数，并且返回值为Int的函数。该变量指向addTwoInts函数。

10 函数当参数

Example9 : 

```
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
```

11、内嵌函数

嵌套函数默认情况下从外部隐藏，但仍然可以由其封闭函数调用和使用。封闭函数还可以返回其一个嵌套函数，以允许嵌套函数在另一个作用域中使用(Example10)。

Example10 :

```
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero 现在等同于stepForward函数，因为(currentValue > 0)为false
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
```
