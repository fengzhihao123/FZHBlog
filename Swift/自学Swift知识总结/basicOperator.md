# LearniOS

## Swift

### Basic Operators

1、与Object-C(Example2)和C中的赋值表达式不同，Swift中的赋值表达式本身不会返回值，所以下面的语句(Example1)是不合法的。该特性主要是防止当你想使用`==`的时候，而错写成了`=`，Swift通过这个特性帮助你避免了这个错误。

Example1 :

```
if x = y {
    //x = y是不合法的，因为x = y并没有返回值
}
```
Example2 :

```
int x = 0;
    int y;
    if ((y = x)) {
        //上面的语句是合法的
    }
```

2、`+`运算符是支持字符串拼接的(Example3)。

Example3 :

```
"hello, " + "world"  // equals "hello, world"
```

3、Swift 同样支持这两个(===/!==)恒等运算式，当你想测试两个对象是否指向一个对象实例的时候使用该运算式(Example4)。

Example4 :
```
var label1 = UILabel()
var label2 = UILabel()
var label3 = label1
var label4 = label1
if label3 === label2 {
    print("y")//
}else{
    print("n")//因为label3指向label1，所以输出n
}
```

4、当元祖(tuple)的元素小于7个的时候，Swift的标准库是支持两个元祖比较大小的(Example5)。如果你想将大于7个元素的元祖作比较，你必须自己实现该算法。

Example5 :

```
//tuple数目要小于7个
if (1,2,3,4,5,6) < (1,2,3,4,5,6) {
    //它是从左向右开始比较的
}
```

5、nil合并运算符(`??`)该表达式实质为`(a != nil) ? a! : b`的简写。

```
var defaultColor: String = "red"
var userSetColor: String?
userSetColor = "green"

var currentColor = userSetColor ?? defaultColor
//currentColor 为green，如果userSetColor非空，则返回userSetColor的值，defaultColor则会无效。
```

6、一元运算符 `+`,并没有实质性的操作

```
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
```

7、比较运算符也可以比较tuples,从左向右比较

8、在写多个逻辑运算符的条件语句时，最好加上括号已使判断逻辑更加清晰

```
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
```

