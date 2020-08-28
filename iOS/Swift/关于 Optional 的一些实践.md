### 为 Optional 添加 extension
```
extension Optional where Wrapped == String {
    var safeValue: String {
        return self ?? ""
    }
}

var name: String? = "Swift"
print(name ?? "")

name = nil
print(name!) // 强制解包造成 crash

print(name.safeValue) // 无需解包，不存在上述情况
```
优点：无需解包，从而减少代码因强制解包而出现的问题。

### 为 Optional 添加单元测试
[XCTUnwrap(_:_:file:line:)](https://developer.apple.com/documentation/xctest/3380195-xctunwrap) : 如果表达式为 nil，则测试失败；若不为 nil，测试成功，返回解包的值。
```
func testNameValue() throws {
    let name: String? = "Swift"
    let unwrappedTitle = try XCTUnwrap(name, "Title should be set")
    XCTAssertEqual(unwrappedTitle, "Swift")
}
```

### Optional Protocol
通过 extension 来实现 optional Protocol。
```
protocol Eat {
    func eatFish()
    func eatApple() //Optional
}

extension Eat {
    func eatApple() { }
}

struct Cat: Eat {
    func eatFish() {
        print("Dog eat fish")
    }
}
```

### 避免嵌入式 Optional
optional 可以重复使用，比如下面的代码：
```
var name: String?? = "Swift" // 使用这种方式估计会被人打死🤣
print(name!!)
```
下面给出一种更加可能的使用方式：
```
let nameAndVersion: [String:Int?] = ["Swift": 5]
let swiftVersion = nameAndVersion["Swift"]
print(swiftVersion) // Optional(Optional(5))
print(swiftVersion!) // Optional(5)
print(swiftVersion!!) // 5
```
我们应该尽量避免上面的类似的使用。