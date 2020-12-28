#### print(_:separator:terminator:)
* print(item) == String(item)，可传递0个或多个参数，原样输出需打印的内容。
```
print("One two three four five")
// Prints "One two three four five"

print(1...5)
// Prints "1...5"

print(1.0, 2.0, 3.0, 4.0, 5.0)
// Prints "1.0 2.0 3.0 4.0 5.0"
```
* separator：支持 item 之间添加分隔符，默认为空格。
```
print(1, 2, 3, 4, 5, separator: "...")
// 1...2...3...4...5
```
* terminator：支持 item 末尾的终止符，默认为换行。
```
for i in 1...5 {
    print(i, terminator: "")
}
// 12345
```
#### debugPrint(_:separator:terminator:)
* 使用及参数效果同上。
* debugPrint 会额外的带有一些有用的调试信息：
```
print(1...5)
// 1...5
debugPrint(1...5)
// ClosedRange(1...5)
```

#### 总结
* print / debugPrint 可以使用 separator 和 terminator 参数进行定制化输出。
* print 旨在提供标准化的输出。
* debugPrint 在输出对象时，会附加更多有用的信息。所以用它调试复杂情况更加高效。

#### 参考
* [Stack Overflow](https://stackoverflow.com/questions/41826683/print-vs-debugprint-in-swift)