# LearniOS

## Swift

### Enumerations

1、基础语法

```
enum CompassPoint {
    case north
    case south
    case east
    case west
}
```

2、不像C或者Object-C，Swift中的枚举成员在它们被创建的时候，并不会被分配默认的整型值。它们本身就是一个完备的值，它们已经在CompassPoint中被定义好。如在上面的例子中，CompassPoint的north的值为north，而不是0。

3、当你声明了一个枚举的成员变量时，你可以用更简洁的方式来修改成员变量的值。如下:

```
var directionToHead = CompassPoint.west
//不用写CompassPoint.east
directionToHead = .east
```

4、关联值(Associated Values) 

在你定义一个枚举的时候，如果你需要的话，每个枚举成员的类型可以不同。

```
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```

应用:

```
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
```

上文中的let你也可以这样使用。

```
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."
```

5、初始值(Raw values)

初始值可以为字符串、字符或者任何数字类型如整型、单精度整型等。在枚举声明中每个成员的初始值必须唯一。

```
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```

6、在将Int作为初始值的时候，如果第一个成员没有赋值的话，它的值将是0。

```
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

在上面的例子中，因为已赋初值，所以Planet.mercury的初始值为1，Planet.venus初始值为2，以此类推。

当字符串被用作初始值的时候，每个成员的初始时默认为它们的名字。如CompassPoint.north的值为north。

```
enum CompassPoint: String {
    case north, south, east, west
}
```

7、不是所有的整型值都会匹配，所以，通过原始值初始化总是返回一个可选类型的枚举成员。例如下面的例子返回的是Planet?，或者'optional Planet'。

```
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet is of type Planet? and equals Planet.uranus
```

可能为nil的情况

```
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
// Prints "There isn't a planet at position 11"
```

8、递归枚举(Recursive Enumerations)

递归枚举使用示例:

```
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
 
print(evaluate(product))
```
 
