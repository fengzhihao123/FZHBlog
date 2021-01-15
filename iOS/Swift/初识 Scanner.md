Scanner 是一种字符串解析器，用于扫描字符集中的子字符串或字符，也可以扫描十进制、十六进制和浮点表示形式的数值。

Scanner 对象会将字符串中的字符解释转换为数字类型或者字符串类型。当创建 Scanner 对象时，可以赋值一个字符串。它会从给予字符串的头部开始扫描，根据你请求的次数，一直扫描到尾部。

跳过字符串中的换行符，提取所有的数字：
```
let scanner = Scanner(string: "123\n456\n7890")

let res = scanner.scanUpToCharacters(from: .newlines)
let res1 = scanner.scanUpToCharacters(from: .newlines)
let res2 = scanner.scanUpToCharacters(from: .newlines)

print(res, res1, res2) // Optional("123") Optional("456") Optional("7890")
```

由于类簇的性质，Scanner 对象并不是真正 Scanner 类的实例，而是它的私有子类。虽然 Scanner 对象的类是私有的，但它的接口都是 public。对于 Scanner 的属性和函数都可以调用。

使用 `charactersToBeSkipped` ，跳过扫描 "-"：
```
let scanner = Scanner(string: "123-456-7890")
scanner.charactersToBeSkipped = CharacterSet(charactersIn: "-")
```

字符集默认跳过换行符和空格。

实际应用：Hex Color -> UIColor
```
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

let gold = UIColor(hex: "#ffe700ff")
```

* [上面的栗子出处](https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor)