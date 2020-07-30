## String 的内存窥探

### 两个问题
1、 个String变量占用多少内存,👇的两个变量内存地址有何区别？
```
var str = "123456"
var str1 = "1234567890ABCDEF"
```
占用16个字节

String - init中与oxf比较
大于15个字符，存储内存地址，否则则直接存储在变量的内存中。
若大于15个字符，后八个字节为字符串内容的内存地址，放在常量区（cstring）
<!-- tagger pointer -->


2、对上面的字符串进行拼接后会发生什么？
< 15：拼接在地址后面
> 15：在堆空间重新开辟空间，通过malloc函数来验证


内存地址低到高：代码区-常量区-全局区-堆空间-栈空间-动态库

Mach -O:可执行文件


```
0x20
< 15 - rax：字符串的长度 rdx：字符串的真实地址
> 15 - rxi：字符串的长度 rdi:字符串的真实地址
si
register read <var>
x /2xg <address>
x
finish
bt
```

dyld_stub_binder