# 关于 NSObject 的一些总结

* 指针所占字节数：https://blog.csdn.net/IOSSHAN/article/details/88944637
* 在 main.m 文件夹的当前路径，将其转为 C++ 代码：xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main.cpp
* struct - isa
* 64位 isa指针为8字节
* getInstanceSize/mallocsize
* opensource.apple.com/tarballs
* shift+command+f
* memory write x
* 内存对齐：结构体的最终大小必须是最大成员大小的倍数
