# LearniOS

## Swift

### Strings and Characters
1、你不能对一个已存在的字符(Character)变量进行字符或者字符串的拼接(Example1)，因为字符变量只能包含一个字符。

Example1 :

```
var str = "hello"
str += " world"
var character: Character = "!"
//你不能写character.append(str)
str.append(character)
```

2、在Example2中的输出语句中，不能包含'\'和换行符。

Example2 :

```
let num = 123
print("the number is \(num)")
```

3、字符串索引的相关操作
`endIndex` 要小心使用
Example3 :
```
let greeting = "Guten Tag!"
//greeting[greeting.endIndex]会越界
greeting[greeting.startIndex]
// G
greeting[greeting.index(before: greeting.endIndex)]
// !
greeting[greeting.index(after: greeting.startIndex)]
// u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// a
```

4、你可以对遵守`Collection protocol`的任何类型，使用`startIndex`、`endIndex`属性和`index(before:)`、`index(after:)`、`index(_:offsetBy:)`方法。
这些类型包括String/Array/Dictionary/Set。你可以对遵守`RangeReplaceableCollection protocol`的任何类型，使用`insert(_:at:)`/`insert(contentsOf:at:)`/`remove(at:)`/`removeSubrange(_:) `方法。这些类型包括String/Array/Dictionary/Set。

5、`hasPrefix(_:)`和`hasSuffix(_:)`方法会每个字符去匹配你提供的字符串(Example4)。

Example4 :

```
let str = "abcdeeeeee"
if str.hasPrefix("ab") {
    print("yes")
}
```

6、剔除字符串中的空格
```
var str = "hh ss dd cc"
var newStr = ""
for chacter in str.characters {
    var chac = String(chacter)
    if chac != " " {
        newStr.append(chac)
    }
}
```

### Practice
```
var str = "hello"
//print str length
str.characters.count
//print helloworld
str += "world"
//print hello world
str.insert(" ", at: str.index(str.startIndex, offsetBy: 5))
//print hello world!
str.insert("!", at: str.endIndex)
//print r index
//str[str.endIndex]
//print hello
let range = str.index(str.startIndex, offsetBy: 5)..<str.endIndex
str.removeSubrange(range)


func convertColor(color: String) -> (red: String, green: String,blue: String) {
    var colorStr = color
    var resultArr = [String]()
    
    if colorStr.hasPrefix("0X") {
        colorStr = colorStr.substring(from: "0X".endIndex)
    }
    if colorStr.hasPrefix("#") {
        colorStr = colorStr.substring(from: "#".endIndex)
    }
    //    red
    let redIndex = colorStr.index(colorStr.startIndex, offsetBy: 2)
    if let redStr = String(colorStr[colorStr.startIndex..<redIndex]) {
        resultArr.append(redStr)
    }
    //    green
    let greenIndex = colorStr.index("11".endIndex, offsetBy: 2)
    if let greenStr = String(colorStr["11".endIndex...greenIndex]) {
        resultArr.append(greenStr)
    }
    //    blue
    let blueIndex = colorStr.index("1111".endIndex, offsetBy: 2)
    if let blueStr = String(colorStr["1111".endIndex...blueIndex]) {
        resultArr.append(blueStr)
    }
    return (resultArr[0], resultArr[1], resultArr[2])
}

```