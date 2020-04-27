# 读 Swift 源码系列 - NSCache 从入门到源码

 
 ## 如何使用
 通常用它来缓存常用数据，提升性能。
 它和 Dictionary 很像，但有以下几个不同点：
 * 自动移除缓存，保证系统的可用内存空间
 * 线程安全
 * 它不会拷贝 key
 
 可配置的属性：
 * name
 * countLimit
 * totalCostLimit
 * evictsObjectsWithDiscardedContent
 
 可用 API：
 * object(forKey:)
 * setObject(_:forKey:)
 * setObject(_:forKey:cost:)
 * removeObject(forKey:)
 * removeAllObjects()
 

* FIFO
* LFU 
* LRU 
* MRU 


 先进先出算法（FIFO）：FIFO是英文First In First Out 的缩写，是一种先进先出的数据缓存器，他与普通存储器的区别是没有外部读写地址线，这样使用起来非常简单，但缺点就是只能顺序写入数据，顺序的读出数据，其数据地址由内部读写指针自动加1完成，不能像普通存储器那样可以由地址线决定读取或写入某个指定的地址。
 
 最不经常使用算法（Least Frequently Used  - LFU）：这个缓存算法使用一个计数器来记录条目被访问的频率。通过使用LFU缓存算法，最低访问数的条目首先被移除。缺点：无法对一个拥有最初高访问率之后长时间没有被访问的条目缓存负责。
 
 最近最少使用算法（Least Recently used - LRU）：这个缓存算法将最近使用的条目存放到靠近缓存顶部的位置。当一个新条目被访问时，LRU将它放置到缓存的顶部。当缓存达到极限时，较早之前访问的条目将从缓存底部开始被移除。这里会使用到昂贵的算法，而且它需要记录“年龄位”来精确显示条目是何时被访问的。此外，当一个LRU缓存算法删除某个条目后，“年龄位”将随其他条目发生改变。
 
 自适应缓存替换算法(ARC)：在IBM Almaden研究中心开发，这个缓存算法同时跟踪记录LFU和LRU，以及驱逐缓存条目，来获得可用缓存的最佳使用。
 最近最常使用算法（MRU）：这个缓存算法最先移除最近最常使用的条目。一个MRU算法擅长处理一个条目越久，越容易被访问的情况。
