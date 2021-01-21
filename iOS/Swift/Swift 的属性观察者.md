属性观察者，用来监听和响应属性值的改变。在每次属性值被设置新值时都会被调用，即使设置的新值跟属性的当前值一模一样。

可以添加属性观察者的属性类型：
* 定义的存储属性。
* 继承的存储属性。
* 继承的计算属性。

属性观察者通过下面的两个函数来监听：
* `willSet`：在值存储前被调用。
* `didSet`：在值存储后调用。

### 定义的存储属性
```
class Person {
    var name: String = "jack" {
        willSet(newName) {
            print("newName == \(newName)")
        }
        
        didSet {
            print("oldName == \(oldValue)")
        }
    }
}

let p = Person()
p.name = "rose" // name == jack；newName == rose name == rose；oldName == jack
```

上面的代码定义了一个 Person 的类，该类包含一个 name 的存储属性。name 属性添加了属性观察者，并实现了 willSet/didSet 两个函数。

通过打印可以看出，在给 name 属性赋值之后，会先调用 willSet 打印 `name == jack；newName == rose`，再调用 didSet 打印 `name == rose；oldName == jack`。由此可以看出 `willSet` 是在值存储前被调用，而 `didSet` 是在值存储后调用。


需要注意的是，`当调用构造函数的时候，不会触发属性观察者。`详见下面的代码：
```
class Person {
    var name: String {
        willSet(newName) {
            print("name == \(name)；newName == \(newName)")
        }
        
        didSet {
            print("name == \(name)；oldName == \(oldValue)")
        }
    }
    
    init(name: String) {
        self.name = name
    }
}

let p = Person(name: "rose")
```
上面的代码中，将 name 属性的初始值删掉，并提供了一个构造函数。当调用 let p = Person(name: "rose") 这行代码时，并没有任何打印。`说明调用构造函数并不会触发属性观察者。`

### 继承的存储属性 
```
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class Student: Person {
    override var name: String {
        willSet(newName) {
            print("name == \(name)；newName == \(newName)")
        }
        
        didSet {
            print("name == \(name)；oldName == \(oldValue)")
        }
    }
}

let stu = Student(name: "jack")
stu.name = "rose" // name == jack；newName == rose name == rose；oldName == jack
```
上面的代码声明了一个 Student 的类，继承自 Person。并对Student 继承 的 name 属性添加了属性观察者。

通过打印可以看出，在给 name 属性赋值之后，会先调用 willSet 打印 `name == jack；newName == rose`，再调用 didSet 打印 `name == rose；oldName == jack`。

虽然，调用父类构造函数不会触发属性观察者，但如果在子类中修改属性值，是会触发属性观察者的。详见下面的代码：
```
class Person {
    var name: String {
        willSet(newName) {
            print("name == \(name)；newName == \(newName)")
        }
        
        didSet {
            print("name == \(name)；oldName == \(oldValue)")
        }
    }
    
    init(name: String) {
        self.name = name
        self.name = "Person, \(name)"
    }
}

class Student: Person {
    override init(name: String) {
        super.init(name: name)
        self.name = "Student, \(name)"
    }
}

let p = Person(name: "mike") // 没有任何打印
let stu = Student(name: "robin") 
// name == Person, robin；newName == Student, robin
// name == Student, robin；oldName == Person, robin
```
可以看到，在 Student 的构造器中添加 `self.name = "Student, \(name)"` 之后，就会触发属性观察者。

而在 Person 的构造器中，无论添加多少 `self.name = "Person, \(name)"` ，都不会触发属性观察者。

### 继承的计算属性
```
struct BodyInfo {
    var height = 0
    var weight = 0
}

class Person {
    var name: String
    var body = BodyInfo()
    
    var info: BodyInfo {
        get {
            return BodyInfo(height: body.height + 1, weight: body.weight + 1)
        }
        
        set {
            body.height = newValue.height + 1
            body.weight = newValue.weight + 1
        }
    }
    
    init(name: String) {
        self.name = name
    }
}

class Student: Person {
    override var info: BodyInfo {
        willSet(newInfo) {
            print("newInfo = \(newInfo)")
        }
        
        didSet {
            print("oldInfo = \(oldValue)")
        }
    }
}


let stu = Student(name: "jack")
stu.info = BodyInfo(height: 15, weight: 20)
// newInfo = BodyInfo(height: 15, weight: 20)
// oldInfo = BodyInfo(height: 1, weight: 1)
```
需要说明上面的代码逻辑上狗屁不通，只是当做代码说明🤣。

上述代码中，Person 定义了一个 info 的计算属性，然后 Student 中继承了 info，并给它添加了属性观察者。

通过 stu.info = BodyInfo(height: 15, weight: 20) 的调用，可以看到输出的结果是符合预期的。

需要说明的是，不能再 Person 中给 info 添加属性观察者，因为 willSet/didSet 是不能和 get 同时出现的，感兴趣的同学可以自己动手实践一下。编译器会报错：`'willSet' cannot be provided together with a getter`。

### 总结
* 可以添加属性观察者的属性类型： 定义的存储属性/继承的存储属性/继承的计算属性。
* 属性观察者的两个函数：*`willSet`：在值存储前被调用；`didSet`：在值存储后调用。
* 调用本类的构造函数不会触发属性观察者，但在子类中的构造器中修改属性会触发。