在 Swift 中，如何能迭代获取 enum 的所有 case 呢？答案就是 CaseIterable。通过遵守 CaseIterable 协议，可以通过 `allCases` 属性来获取所有 case 的集合。

### 获取所有的 case
```
enum Direction: CaseIterable {
    case east
    case west
    case north
    case south
}
// 可以获取所有 case 的数量
let count = Direction.allCases.count
// 也可以遍历所有 case
for direction in Direction.allCases {
    print(direction)
}

east
west
north
south
```

### 支持集合的所有操作

对于该集合，我们不仅可以遍历它，还可以对它进行 filter 、map 的高阶函数的操作。
```
enum Direction: Int, CaseIterable {
    case east = 0
    case west
    case north
    case south
}

// 进行 filter 操作
let result = Direction.allCases.filter { $0.rawValue > 1 }
for direction in result {
    print(direction)
}
 
// 进行 map 和 joined 操作
let caseList = Direction.allCases
                               .map({ "\($0)" })
                               .joined(separator: ", ")
// caseList == "north, south, east, west"
print(caseList)
```

### 当 enum 有联合值的时候，如何使用 CaseIterable
当 enum 遵守该协议时，编译器会自动提供 CaseIterable 要求的函数实现，比如上面的代码。但 enum 有联合值的时候，是不会自动提供函数实现的。这时候就需要我们自己去实现 CaseIterable 协议要求实现的内容了。
```
enum Barcode: CaseIterable {
    case upc(Int, Int, Int)
    case qrCode(String)
}
```
上面这个代码是无法编译的，会提示报错：`Type 'Barcode' does not conform to protocol 'CaseIterable'`。

修改成下面的代码就可以了：
```
enum Barcode: CaseIterable {
    typealias AllCases = [Barcode]
    static var allCases: [Barcode] = [.upc(0, 0, 0), .qrCode("")]

    case upc(Int, Int, Int)
    case qrCode(String)
}

let count = Barcode.allCases.count
```
实现了 AllCases 和 allCases 之后我们就可以跟之前那样使用了。
