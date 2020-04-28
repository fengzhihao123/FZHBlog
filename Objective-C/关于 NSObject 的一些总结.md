# 关于 NSObject 的一些总结

* 指针所占字节数：https://blog.csdn.net/IOSSHAN/article/details/88944637
* struct - isa
* 64位 isa指针为8字节
* getInstanceSize/mallocsize
* opensource.apple.com/tarballs
* shift+command+f
* memory write x
* 内存对齐：结构体的最终大小必须是最大成员大小的倍数
## 准备知识
### 相关命令
* 将 OC 代码转换为 C++ 代码的命令：`xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main.cpp`。主要在 main.m 文件的当前路径输入此命令。
* memory write x：写入内存。

### 指针占得字节数
指针所占的字节数与当前系统有关，如果为 32 位的系统，则指针所占字节为：4 字节；若为 64 位的系统，则指针所占字节为 8 字节。

对于指针来说，它存储的是内存地址。如果我们的系统是 32 位的，那就是内存地址为 32 个二进制位，即指针的大小等于 32/8 = 4 字节。若为 64 位的系统，则指针的大小等于 64/8 = 8 字节。

`一字节(byte) = 8 比特，一个二进制位为以比特(bit)。`

### 相关术语
* 大端模式、小端模式
* 

## NSobject 底层实现

## NSobject 及子类的内存管理

## class_getInstanceSize 与 malloc_size

## 参考链接
* [一个指针占几个字节？原理是什么呢？](https://blog.csdn.net/IOSSHAN/article/details/88944637)
