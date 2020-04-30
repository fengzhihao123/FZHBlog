# 闭包/匿名函数（Closure）
 ## 前言
`匿名函数和闭包是一个东西的两种叫法，下面统一统一使用闭包来讲解。`
 
上一章我们讲解了函数，这一章来看一下什么是闭包。举个例子大家就理解了，在现实中，写文章我们可以署名也可以匿名，如果署名的话我们需要写上我们的名字，而匿名的话就不需要了。对于函数来说也是一样的。
  
  正常的函数都是有名字的，比如下面执行加法操作的函数：
  ```
  func add(_ arg1: Int, _ arg2: Int) -> Int {
      return arg1 + arg2
  }
  ```
  
  我们需要给它添加名字。而对于闭包，则不需要给它命名了。
  
  ## 闭包
  ### 定义
 闭包的定义语法如下：
  ```
  { (参数列表) -> 返回值类型 in
      需要执行的逻辑
  }
 ```
 
 比如我们需要定义一个执行加法操作的闭包：add：
```
 let add = {(arg1: Int, arg2: Int) -> Int in
     return arg1 + arg2
 }
 ```
 上面定义了一个执行加法操作的闭包，并将它赋值给常量 add。
  ### 使用
 上面定义了一个闭包，它的使用和普通函数的使用一样，直接传递参数即可：
 ```
 let res = add(1, 2)
 print(res) // 3
 ```
  ### 值获取
 在定义闭包的时候，不光可以定义参数，我们也可以捕获参数的值：
 
 ### 简化
 上面举例的代码是闭包的完整版，下面我们来一步一步简化它，看看能简化到什么地步。
 
 比如数组中经常需要用到的排序：sorted。假设我们有一个 [3, 4, 1, 2, 9, 6, 7] 的数组需要排列为升序，则可以写下面的代码：
 ```
 var nums = [3, 4, 1, 2, 9, 6, 7]
 nums.sort { (num1: Int, num2: Int) -> Bool in
     return num1 < num2
 }
 print(nums)
 ```
 
 而 Swift 是可以自动推断出参数类型的，所以可以将闭包参数的类型省略：
 ```
 nums.sort { num1, num2 in return num1 < num2 }
 ```
 
 然后，Swift 中的单表达式闭包默认是返回其结果的，所有又可以将 return 关键字给去掉：
 ```
 nums.sort { num1, num2 in num1 < num2 }
 ```
 
 最后，Swift 在闭包中默认提供 $0、$1等默认参数，所以可以把num1和num2去掉($0代表第一个参数、$1代表第二个参数以此类推)：
 ```
 nums.sort { $0 < $1 }
 ```

 最最后，因为sort函数支持操作符，所以我们也可以写成下面这样：
 ```
 nums.sort(by: <)
 ```
 
### 传递闭包
 对于闭包，我们不仅可以定义、调用，还可以将它当做普通函数的参数。如果闭包为函数的最后一个参数，则称之为尾随闭包(Trailing Closures)。
 
 首先看一下如何声明一个带有尾随闭包的普通函数：
 ```
 func add(target: Int, sub: (Int) -> Void) {
     sub(target + 10)
 }
 ```
 
### 注意事项 - 循环引用
 
 * The parameters in closure expression syntax can be in-out parameters, but they can’t have a default value.
