### Foundation 的改进

#### difference 的使用
`difference` 函数用于任意元素实现 Equaltable 、且有序集合。

下面是该函数的示例代码：
```
let bird = "bird"
let bear = "bear"
// step1
let diff = bird.difference(from: bear) //两个字符创不同的部分： i r e a
// step2
let newBird = bear.applying(diff) // bird
```

step1 通过 `difference` 函数获得了 bird 和 bear 不同的部分 diff，step2 通过调用 `applying` 函数将 diff 应用到 bear 上来得到 newBird。

因为 `difference` 函数可以应用于任意有序集合，所以也可以在数组中使用：
```
let arr1 = [1, 2, 3]
let arr2 = [2, 3, 4]
let diff = arr1.difference(from: arr2) // 两个数组不同的部分：[1, 4]
let newArr1 = arr2.applying(diff)
print(newArr1) // [1, 2, 3]
```

因为 `difference` 函数返回的结果本身也是一个集合，所以我们也可以使用 for-in 来迭代它的元素：
```
for change in diff {
    switch change {
    case .remove(let offset, let element, _):
        print("offset = \(offset), element = \(element)") // offset = 2, element = 4
    case .insert(let offset, let element, _):
        print("offset = \(offset), element = \(element)") // offset = 0, element = 1
    }
}
```

* 对 arr2 移除 index 为 2 的元素，得到 [2, 3]。
* 在 index 为 0 的位置插入 1。得到 [1, 2, 3] 即 arr1 的内容

#### 数据压缩
在 Swift 5.1，官方提供了数据压缩函数，但该函数仅限于 NSData 使用。

示例代码：
```
let str = "Swift"
let data = str.data(using: .utf8)
if let d = data {
    let d1 = d as NSData
    let res = try d1.compressed(using: .lzfse)
    print(res)
}
```
CompressionAlgorithm 为枚举，提供四种 case：lz4、lzfse、lzma、zlib。

#### 新增单位类型
UnitDuration 新增以下类型：
* milliseconds：毫秒
* microseconds：微秒
* nanoseconds：纳秒
* picoseconds：皮秒

UnitFrequency 新增 framesPerSecond，可用来测试 FPS。

UnitInformationStorage 新增以下类型：
* bits
* bytes
* nibbles

#### 显示日期或时间
新增 RelativeDateTimeFormatter 用来计算两个日期之间的间隔，支持本地化。这个更新很实用，可以很方便的计算各种类似于微信聊天的时间标签。

```
let oldDateStr = "2021-01-05"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
let oldDate = dateFormatter.date(from: oldDateStr)!

let nowDate = Date()
let formatter = RelativeDateTimeFormatter()
formatter.locale = Locale(identifier: "zh_CN")
let dateString = formatter.localizedString(for: oldDate, relativeTo: nowDate)
print(dateString) // 1周前
```

#### List Formatter
用于本地化显示数组转成的字符串：
```
let str = ["🤣", "🐖", "🦄"]
let formatter = ListFormatter()

formatter.locale = Locale(identifier: "zh_CN")
let zhString = formatter.string(for: str)
print(zhString) // "🤣、🐖和🦄"

formatter.locale = Locale(identifier: "en_US")
let enString = formatter.string(for: str)
print(enString) // "🤣, 🐖, and 🦄"
```

通过 itemFormatter 来设置 item 的格式。
```
func stringToDate(str: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from:str)
}

let dateStr = ["2020-01-09", "2020-02-05", "2020-04-21"]
let dates = dateStr.compactMap { stringToDate(str: $0) }

let listFormatter = ListFormatter()
let dateFromatter = DateFormatter()
dateFromatter.dateFormat = "yyyy-MM-dd"

listFormatter.itemFormatter = dateFromatter
let str = listFormatter.string(for: dates) // "2020-01-09, 2020-02-05, and 2020-04-21"

// 通过设置 locale 来进行本地化输出
listFormatter.itemFormatter = dateFromatter
listFormatter.locale = Locale(identifier: "es_ES")
let str = listFormatter.string(for: dates) // "2020-01-09, 2020-02-05 y 2020-04-21"
```

#### Operation Queue
新增 `addBarrierBlock` 。当所有 task 执行完之后，才会执行 `addBarrierBlock` 的 task。
```
let queue = OperationQueue()

queue.addOperation {
    print("task1")
}

queue.addOperation {
    print("task2")
}

queue.addOperation {
    print("task3")
}

queue.addOperation {
    print("task4")
}

queue.addBarrierBlock {
    print("complete")
}
// task1 task2 task3 task4 complete
```

通过设置 totalUnitCount 来进行进度检测：
```
queue.progress.totalUnitCount = 3
```

#### Scanner
优化了 Scanner 的使用方式。

```
let scanner = Scanner(string: "")

// Swift 4
var nameNSString: NSString?
if scanner.scanUpToCharacters(from: .newlines, into: &nameNSString) {
    let name = nameNSString! as String
}

// Swift 5.1
let nameString = scanner.scanUpToCharacters(from: .newlines)
```