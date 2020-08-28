## Algorithm.swift
## min

### min - 两个参数
 源码：
 ```
 public func min<T: Comparable>(_ x: T, _ y: T) -> T {
   return y < x ? y : x
 }
 ```
 通过源码可以得知，min函数的底层就是使用三目运算符计算得出结果。`这里需要注意的一点，如果 x 等于 y，它返回的是 x。这样做的原因是保持数据的稳定性。`
 
 何为数据稳定性？比如我们有一个需要排序的数组：[5, 3, 2, 4, 3],如果我们通过排序，第二个位置的 3 经过排序后在第五个位置的 3 前面，则是稳定的，反之则为不稳定的。
 
 通过下面的代码可以看出如果相等，确实返回的第一个参数：
 ```
 struct Student: Comparable {
     var age = 0
     var name = ""
     
     static func < (lhs: Student, rhs: Student) -> Bool {
         return lhs.age < rhs.age
     }
 }

 let s1 = Student(age: 18, name: "jack")
 let s2 = Student(age: 18, name: "rose")

 let res = min(s1, s2)
 print(res.name) // jack
 ```
### min - 多个参数
 源码：
 ```
 public func min<T: Comparable>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T {
   var minValue = min(min(x, y), z)
   // 如果 value 等于 minValue，会选择 minValue 当最小值，原因同上。
   for value in rest where value < minValue {
     minValue = value
   }
   return minValue
 }
 ```
 
 通过代码可以看出，可以传递多个参数的 min 函数是先求出前三个参数的最小值 - minValue，再去 rest 集合中寻找是否有比 minValue 更小的值。
 
### max - 两个参数
 源码：
 ```
 public func max<T: Comparable>(_ x: T, _ y: T) -> T {
   return y >= x ? y : x
 }
 ```
 同样通过三目运算符得出结果，如果两个值相等，则选择 y 为结果，原因同上。
 
### max - 多个参数
 源码：
 ```
 public func max<T: Comparable>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T {
   var maxValue = max(max(x, y), z)
   for value in rest where value >= maxValue {
     maxValue = value
   }
   return maxValue
 }
 ```
 原理同接受多个参数的 min 函数。
 
### EnumeratedSequence
 当数组调用 `enumerated()` 函数时，会返回一个 `EnumeratedSequence` 类型的实例。
 
 源码：
 ```
 // 1、构建一个支持泛型的结构体
 public struct EnumeratedSequence<Base: Sequence> {
   @usableFromInline
   internal var _base: Base

   @inlinable
   internal init(_base: Base) {
     self._base = _base
   }
 }
 
 // 2、提供一个访问 index 的迭代器，从而可以循环访问每个元素
 extension EnumeratedSequence {
   @frozen
   public struct Iterator {
     @usableFromInline
     internal var _base: Base.Iterator
     @usableFromInline
     internal var _count: Int

     /// Construct from a `Base` iterator.
     @inlinable
     internal init(_base: Base.Iterator) {
       self._base = _base
       self._count = 0
     }
   }
 }
 
 // 3、迭代器遵守 IteratorProtocol 和 Sequence，可以通过 next() 访问下一个元素
 extension EnumeratedSequence.Iterator: IteratorProtocol, Sequence {
   public typealias Element = (offset: Int, element: Base.Element)
   @inlinable
   public mutating func next() -> Element? {
     guard let b = _base.next() else { return nil }
     let result = (offset: _count, element: b)
     _count += 1
     return result
   }
 }

 // 4、遵守 Sequence 返回迭代器
 extension EnumeratedSequence: Sequence {
   @inlinable
   public __consuming func makeIterator() -> Iterator {
     return Iterator(_base: _base.makeIterator())
   }
 }
 ```
 
 示例代码：
 ```
 var s = ["foo", "bar"].enumerated()
 for (n, x) in s {
     print("\(n): \(x)")
 }
 //0: foo
 //1: bar
 ```
这里有一点疑问，第 4 步的代码为何不放在第 3 步？我的理解是每个 extension 只做一件事，保持单一职能，如果理解错误还烦请知道的不吝赐教。
