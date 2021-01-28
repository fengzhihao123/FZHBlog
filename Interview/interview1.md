### 用递归写一个算法，计算从 1 到 100 的和。
* 算法的时间复杂度是多少？答：O(n)。
* 递归会有什么缺点？答：当数据量较大时，它会占用很大的空间，因为它需要一直压栈。
* 不用递归能否实现，复杂度能否降到O(1)。

递归算法：
```
func sum(_ target: Int) -> Int {
    if target <= 0 {
        return 0
    }
    return target + sum(target - 1)
}
```

不用递归实现，且时间复杂度为O(1)：
```
func sum(_ target: Int) -> Int {
    return (1 + target) * target / 2
}
```

更进一步的优化：
```
func sum(_ target: Int) -> Int {
    return (1 + target) * target << 1
}
```

### property 的作用是什么，有哪些关键词，分别是什么含义？

property 的作用：setter + getter + instance。

关键词：
* strong：用来修饰对象类型，强引用。
* weak：用来修饰对象类型，弱引用。
* copy：用来修饰 String、NSArray、NSDictionary 等。
* atomic：原子性，一般不使用，因为并不能真的保证线程安全，还会带来性能问题。
* nonatomic：非原子性，一般使用这个。
* assign：修饰基本类型：Int等。

### 父类的 property 是如何查找的？

### NSArray、NSDictionary 应该如何选关键词？

### copy 和 muteCopy 有什么区别，深复制和浅复制是什么意思，如何实现深复制？

### 用 runtime 做过什么事情？runtime 中的方法交换是如何实现的？

### 讲一下对 KVC 和 KVO 的了解，KVC 是否会调用 setter 方法？

### __block 有什么作用

### 说一下对 GCD 的了解，它有那些方法，分别是做什么用的？

### 对二叉树是否了解？