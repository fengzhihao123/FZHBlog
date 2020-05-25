## Zip

zip 函数用来同时遍历两个集合，如果两个集合的长度不一致，则遍历完短集合即结束遍历。

### 使用

```
let string = "abcdef"
let range = 1...4
for (str, index) in zip(string, range) {
    print(str, index)
//    a 1
//    b 2
//    c 3
//    d 4
}
```

### 源码
该函数底层使用的是一个名字为 `Zip2Sequence` 的结构体。该结构体通过实现 `Sequence` 协议生成迭代器，实现 `IteratorProtocol` 协议进行迭代来实现同时遍历两个集合。

#### 核心函数
```
public mutating func next() -> Element? {
    // 1
    if _reachedEnd {
      return nil
    }
    // 2
    guard let element1 = _baseStream1.next(),
          let element2 = _baseStream2.next() else {
      _reachedEnd = true
      return nil
    }
    // 3
    return (element1, element2)
  }
```

* 通过`_reachedEnd`变量来判断是否遍历至尾部
* 判断是否两个集合的`next()`是否为空，若都不为空则进行下地迭代，若为空则置`_reachedEnd`为`true`，返回nil结束迭代。
* 返回每次迭代的 tuple
