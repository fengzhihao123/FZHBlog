# LearniOS

## Effective Objective-C

### Item2: Minimize Importing Headers in Headers
* 能不导入头文件尽量不要导入(reason: 减少依赖，减少编译时间)

### Item3:Prefer Literal Syntax over the equivalent methods
* NSString/NSNumber/NSArray/NSDictionary 能用字面量赋值的不要用等同的方法(reason:节省代码体积，是代码更加简洁)
* 可以更早的发现NSArray/NSDictionary的崩溃
* 确保添加到Array和dictionary中的对象不为nil

### Item4:Prefer Typed Constants to Preprocessor #define
* 在表示一个不可变的常量的时候，应该使用`static const`的方式去修饰常量，而不是使用`#define`的方式
* 
*


Q:为什么定义的常量以k做前缀？
A:这是编程语言中通用的一种标记符号，并不是oc中特有的.k标识常量的意思. (https://stackoverflow.com/questions/472103/lower-case-k-in-cocoa/472118#472118)
`That's a general programming notation not specific to Objective-C (i.e. Hungarian Notation) and the "k" stands for "constant".`

### Item5:Use Enumerations for States,options,and status codes



### Word
* subtle
* minimize
* approach
* mandate
* bargin
* unavoidable
* prudent
* proportion
* bulk
* superfluous
* moreover
* limitation
* minor
* cluster
* benefit
* succinct

