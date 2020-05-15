## Reverse.swift
### reverse() 的源码实现

```
public mutating func reverse() {
    if isEmpty { return }
    var f = startIndex
    var l = index(before: endIndex)
    while f < l {
      swapAt(f, l)
      formIndex(after: &f)
      formIndex(before: &l)
    }
}
```
复杂度为 O(*n*)。

思路：循环头尾交换。

### 自己实现一个reverse()
```
func fzhReverse(_ nums: inout [Int]) {
    var f = nums.startIndex
    var l = nums.index(before: nums.endIndex)
    while f < l {
        nums.swapAt(f, l)
        nums.formIndex(after: &f)
        nums.formIndex(before: &l)
    }
}
```
