## Swift 数组使用注意事项
### 数组内存增长策略
当我们向一个数组尾部拼接元素且数组的内存空间不够使用时，数组就会动态的增加内存空间，那么 Swift 的数组内存增长策略是什么？通过查阅 Swift 代码库的 Array.swift 文件的 155 行：`The new storage is a multiple of the old storage's size.`可以得知，它的策略就是将旧的内存空间乘以 2 。下面通过代码来验证一下：
```
var nums = [1, 2, 3, 4, 5]
// 初始容量：5,初始元素个数：5
print("初始容量：\(nums.capacity),初始元素个数：\(nums.count)")
nums.append(6)
// 添加元素后容量：10,元素个数：6
print("添加元素后容量：\(nums.capacity),元素个数：\(nums.count)")

```
可以看到：`nums` 的初始容量为 5，元素个数为 5。通过在尾部添加一个元素后，`nums` 的新容量变成了 10，元素个数则为 6。

可能我们会觉得每次容量乘以 2 有点空间浪费，想自己制定内存增长策略。那么该如何实现呢？答案就是使用 `reserveCapacity(_ minimumCapacity:)` 函数，通过 minimumCapacity 参数来控制每次内存增长。但是这里有一点我们需要注意一下，`For performance reasons, the size of the newly allocated storage might be greater than the requested capacity. Use the array's 'capacity' property  to determine the size of the new storage.`(Array.swift 的第962行) 因为性能原因，每次增长后的新内存可能只比数组的最小容量大，不能保证每次的新内存大小都是你指定的大小。这句话可能理解起来有点抽象，我们通过代码来说明一下：
```
var arr = Array(1...4)
var factor = 0
for index in 1...20 {
    print("第\(index)次执行，数组的内存大小：\(arr.capacity)")
    factor += 10
    arr.reserveCapacity(factor)
}
```
执行结果：
![执行结果](https://github.com/fengzhihao123/FZHBlog/blob/master/images/Array-capacity.png){:height="50%" width="50%"}

通过上述的打印我们可以看到在第1-13次的内存容量都增加了我们指定的 10，但是 14-19次的内存容量并没有变，而最后一次则是增加了 64 次。由此得知，我们指定的内存策略系统只会大概的去按照执行，并不会精确的去执行，所以我们应该使用`capacity` 来获得数组当前确切的容量。

具体应用：在我们知道大概的元素增量时，可以先扩展数组的内存容量，再去添加元素。
```
// 一般写法
var names = ["小明", "小红", "小强"]
for i in 1...10 {
    names.append("name\(i)")
}
// count = 13; capacity = 24
print(names.count, names.capacity) 
// 优化后写法
names = ["小明", "小红", "小强"]
// 后续我们大概需要添加10个名字，可以先把容量扩找到 15，再去添加元素
names.reserveCapacity(15)
for i in 1...10 {
    names.append("name\(i)")
}
// count = 13; capacity = 15
print(names.count, names.capacity)

```
`需要注意的是不要在 for-loop 里面调用 reserveCapacity() 函数。`

### ArraySlice
在我们使用数组切片时，需要注意的是切片的索引是和原数组的索引是一致的，需要注意索引越界的问题，比如下面的代码：
```
var nums = [1, 2, 3, 4, 5]
let slice = nums[1...2]
// 切片的起始索引:1, 结束索引:3
print("切片的起始索引:\(slice.startIndex), 结束索引:\(slice.endIndex)")
```
可以看到 `slice` 的起始索引是1，结束索引是 3,包含的元素为`[2, 3]`。索引跟原数组是一致的，所以，我们不能通过`slice[0]` 来去访问它的第一个元素，这会造成越界问题。

使用切片还有一个需要注意的问题就是，我们不应该长时间的持有切片。因为即使在原始数组的生命周期结束后，切片也回持有对较大数组的整个内存的引用，而不仅仅是对它所表示的部分的引用。因此，切片的长期存储可能会导致元素的生命周期延长，而这些元素在其他情况下是不可访问的，这就可能会出现内存和对象泄漏。“Long-term storage of `ArraySlice` instances is discouraged...can appear to be memory and object leakage.”[出自 ArraySlice.swift 第65-70行]。
### copy on write
当将一个数组的数据赋值给一个新创建的变量时，它并不会立即拷贝。而是当新创建的变量修改的时候才会发生拷贝。如下：
```
var nums = [1, 2, 3, 4, 5]
// 未发生拷贝
var newNums = nums
// 发生拷贝
newNums[0] = 10
```

