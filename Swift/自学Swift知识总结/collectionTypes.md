# LearniOS

## Swift

### Collection Types

#### Array

1、当你创建的集合类型不会改变的时候，你应该创建一个不可变的集合(immutable collections)。这样做对你检查代码的错误原因更加容易，并且这样Swift编译器也可以做更好的性能优化。

2、你可以通过`public init(repeating repeatedValue: Element, count: Int)`方法初始化数组(Example1)。

Example1 :

```
var arr = Array(repeating: "ss", count: 3)
//该数组为字符串类型，内容为["ss","ss","ss"]
```

3、'+'可以应用于数组(Example2)。

Example2 :

```
var anotherThreeDoubles = Array(repeating: "2.5", count: 2)
var sixDoubles = anotherThreeDoubles + anotherThreeDoubles
// sixDoubles类型:[String], 包含元素:["2.5", "2.5", "2.5", "2.5"]
```

4、数组中只能存储同一类型的数据。如Example3中，在字符串类型的数组中拼接一个整型元素会报错。

Example3 :

```
var anotherThreeDoubles = Array(repeating: "2.5", count: 2)
//该句会报不能讲Int转换为String的错误
anotherThreeDoubles.append(3)
```

5、你可以通过通过如下方法来访问和修改数组:调用方法、属性、或者使用下标。

* 你可以通过`count`(该属性为只读)属性来查数组的长度(Example4)。

Example4 :

```
var shoppingList = [1,2,3,4]
print("The shopping list contains \(shoppingList.count) items.")
// Prints "The shopping list contains 4 items."
```

* 你可以通过访问`isEmpty`(该属性为Boolean类型)属性来查看数组的长度是否为0(Example5)。

Example5 :
```
if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}
// Prints "The shopping list is not empty."
```

* 你可以使用`append`方法或者`+=`(该运算符后面需为数组)运算符来拼接数组。

Example6 :

```
shoppingList.append(5)
shoppingList += [6]
```

6、你不能通过访问下角标的方式给数组的尾部拼接一个新的元素(Example7):

Example7 :

```
var shoppingList = [1,2,3,4]
//该句会报越界的错误
shoppingList[4] = 5
```

7、数组中比较常用的几个方法

* `insert(_:at:):` 在某个位置插入元素
* `remove(at:):` 移除某个位置的元素
* `removeLast():`移除最后一个元素
* `enumerated():`该方法返回一个包含索引和对应位置的值的元祖(tuple)数组(Example8)。

Example8 :

```
var shoppingList = [1,2,3,4]

for (index, item) in shoppingList.enumerated(){
    print("\(index + 1) value is \(item)")
}
//输出:
//1 value is 1
//2 value is 2
//3 value is 3
//4 value is 4
```

8、如果你想访问或者修改超过数组长度的值，编译器会报错(数组越界)。在你使用数组的索引值之前你可以先用`count`属性判断一下你使用的索引值是否有效。

#### Set

1、关于Set的一些常用方法(Example9)

* `count`
* `isEmpty`
* `insert(_:)`
* `remove(_:)`
* `contains(_:)`
* `removeAll()`

Example9 :

```
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
//1.count
print("I have \(favoriteGenres.count) favorite music genres.")

//Print:I have 3 favorite music genres.
//2.isEmpty
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}
//Print:I have particular music preferences.
//3.insert
favoriteGenres.insert("Jazz")
print(favoriteGenres)
//Print: ["Jazz", "Rock", "Hip hop", "Classical"]
//4.remove
favoriteGenres.remove("Rock")
print(favoriteGenres)
//Print:["Jazz", "Hip hop", "Classical"]

//5.contain
let isContain = favoriteGenres.contains("Jazz")
//isContain true

//6.removeAll
favoriteGenres.removeAll()
print(favoriteGenres)
//Print:[]
```

2、Swift中的Set是无序的，你可以通过`sorted()`方法来循环访问Set的每一个元素。该方法返回一个包含Set中每一个元素的数组(Example10)。

Example10 :

```
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
for item in favoriteGenres.sorted() {
    print("\(item)")
}

//print
//Classical
//Hip hop
//Rock
```

3、Set的一些高级方法

* `intersection(_:)`创建一个包含俩个集合中公共的元素的新集合。
* `symmetricDifference(_:)`创建一个包含两个集合中不共有的的元素的新集合
* `union(_:)`创建一个包含两个集合中所有元素的新集合
* `subtracting(_:)`创建一个包含目标集合没有的元素的新集合

Example11 :

```
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
 
oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
oddDigits.intersection(evenDigits).sorted()
// []
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]

```

4、Set的一些比较方法

* 你可以用'=='表达式来判断两个集合是否相等
* 你可以使用`isSubset(of:)`方法来判断目标集合是否为该集合的子集合
* 你可以用`isSuperset(of:)`方法来判断目标集合是否为该集合的父集合
* 你可以使用`isDisjoint(with:) `方法来判断目标集合和该集合是否有相同的元素

Example12 :

```
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]
 
houseAnimals == cityAnimals
//false
houseAnimals.isSubset(of: farmAnimals)
// true
farmAnimals.isSuperset(of: houseAnimals)
// true
farmAnimals.isDisjoint(with: cityAnimals)
// true
```

#### Dictionary

1、使用`updateValue(_:forKey:)`方法，如果该方法中的key存在则更新该key对应的值，若该key不存在则创建该值。该方法会返回一个该key对应的旧值(该值为可选类型)。

Example13 :

```
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
// Prints "The old value for DUB was Dublin."
```
2、你可以通过`removeValue(forKey:)`方法来移除字典中的键值对。如果该键值对存在就移除，不存在就返回nil。

Example14 :

```
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}
// Prints "The removed airport's name is Dublin Airport."

```
3、你可以通过访问`keys`和`values`属性来索引字典中的所有key或者value。

Example15 :

```
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}
// Airport code: YYZ
// Airport code: LHR
 
for airportName in airports.values {
    print("Airport name: \(airportName)")
}
// Airport name: Toronto Pearson
// Airport name: London Heathrow
```

4、字典转数组

Example16 :

```
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
let airportCodes = [String](airports.keys)
// airportCodes is ["YYZ", "LHR"]
 
let airportNames = [String](airports.values)
// airportNames is ["Toronto Pearson", "London Heathrow"]
```

#### 面试题

* Array:

```
var arr = [Int]()
arr.append(2)
print(arr)
```

#### 总结

* 访问数组的时候不要越界
* Set和Dictionary是无序的，数组是有序的
* [官方文档](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID105)
