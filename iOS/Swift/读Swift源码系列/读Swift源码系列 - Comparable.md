## Comparable
Comparable 是 Swift 标准库中的 Protocol，继承自 Equatable。它的作用就是支持遵守协议的类型可以使用 `<`、 `<=`、 `>=`、 `>`操作符。

注：标准库中很多类型已遵守该协议，如Int、String等。

### 协议中的方法
```
public protocol Comparable: Equatable {
  static func < (lhs: Self, rhs: Self) -> Bool
  static func <= (lhs: Self, rhs: Self) -> Bool
  static func >= (lhs: Self, rhs: Self) -> Bool
  static func > (lhs: Self, rhs: Self) -> Bool
}

extension Comparable {
  @inlinable
  public static func > (lhs: Self, rhs: Self) -> Bool {
    return rhs < lhs
  }
  @inlinable
  public static func <= (lhs: Self, rhs: Self) -> Bool {
    return !(rhs < lhs)
  }
  @inlinable
  public static func >= (lhs: Self, rhs: Self) -> Bool {
    return !(lhs < rhs)
  }
}
```

虽然 Comparable 中声明了很多方法，但要求必须实现的只有一个：`static func < (lhs: Self, rhs: Self) -> Bool`。

### 如何使用
下面来看一下如何让自定义的类型支持上述操作符。
```
struct Student: Comparable {
    var age = 0
    
    static func < (lhs: Student, rhs: Student) -> Bool {
        return lhs.age < rhs.age
    }
}

let stu1 = Student(age: 10)
let stu2 = Student(age: 20)
print(stu1 > stu2) // false
```
