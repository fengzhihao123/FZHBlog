## ArrayBody

Array 始于 Body，终于集合中连续的元素。该结构体就是用来表现 Body 的部分。

### 两个构造方法
* `init(count: Int, capacity: Int, elementTypeIsBridgedVerbatim: Bool = false)`
* `init()`
### 包含属性
* count：数组中元素的个数
* capacity：数组的容量
* elementTypeIsBridgedVerbatim：数组元素是否是桥接的OC类，默认是false
* _capacityAndFlags：与`elementTypeIsBridgedVerbatim`一起用来压缩容量进行优化
