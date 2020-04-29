# 匿名函数（Closure）
## 前言
 上一章我们讲解了函数，这一章来看一下什么是匿名函数。举个例子大家就理解了，在现实中，写文章我们可以署名也可以匿名，如果署名的话我们需要写上我们的名字，而匿名的话就不需要了。对于函数来说也是一样的。
 
 正常的函数都是有名字的，比如下面执行加法操作的函数：
 ```
 func add(_ arg1: Int, _ arg2: Int) -> Int {
     return arg1 + arg2
 }
 ```
 
 我们需要给它添加名字。而对于匿名函数，则不需要给它命名了。
 
 ## 匿名函数
 
 ### 定义
 Closure expression syntax has the following general form:

 { (parameters) -> return type in
     statements
 }
 ### 使用
 ### 简化
 ### 值获取
 ### 逃逸闭包
 ### 注意事项 - 循环引用
