## KVO/KVC

### KVO
KVO是Key-Value Observing的缩写。它提供一种机制，当指定的对象的属性被修改后，则对象就会接受到通知。简单的说就是每次指定的被观察的对象的属性被修改后，KVO就会自动通知相应的观察者了。
使用KVO的好处:
* 使用KVO最直接的好处就是可以减少代码量。
* KVO是观察者设计模式中的一种，有利于业务逻辑于视图控制之间的解耦。

### KVC
KVC即NSKeyValueCoding，就是键-值编码的意思。一个非正式的 Protocol，是一种间接访问对象的属性使用字符串来标识属性，而不是通过调用存取方法，直接或通过实例变量访问的机制。

KVC间接修改对象属性时，会自动判断对象属性的类型，完成相应的转换。
KVC按键值路径取值时，如果对象不包含指定的键值，那么就会自动进入对象内部，查找对象属性。
KVC可以嵌套按照键值路径取值。
如果访问的类没有你传入的key会报下面的错误:

```
this class is not key value coding-compliant for the key name.
```
### KVO/KVC
KVC(键值编码)，即Key-Value Coding，一个非正式的Protocol，使用字符串(键)访问一个对象实例变量的机制。而不是通过调用Setter、Getter方法等显式的存取方式去访问。
KVO(键值监听)，即Key-Value Observing，它提供一种机制,当指定的对象的属性被修改后,对象就会接受到通知，前提是执行了setter方法、或者使用了KVC赋值。

### 其他
* 和notification(通知)的区别？
notification比KVO多了发送通知的一步。
两者都是一对多，但是对象之间直接的交互，notification明显得多，需要notificationCenter来做为中间交互。而KVO如我们介绍的，设置观察者->处理属性变化，至于中间通知这一环，则隐秘多了，只留一句“交由系统通知”，具体的可参照以上实现过程的剖析。notification的优点是监听不局限于属性的变化，还可以对多种多样的状态变化进行监听，监听范围广，例如键盘、前后台等系统通知的使用也更显灵活方便


参考:
* [iOS KVO概述](http://www.superqq.com/blog/2015/06/05/ios-kvogai-shu-yu-shi-jian/)
* [iOS开发-- KVO的实现原理与具体应用](http://www.jianshu.com/p/e59bb8f59302)