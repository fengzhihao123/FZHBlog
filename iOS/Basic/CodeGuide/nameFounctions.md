# LearniOS
 
## 编码规范

### 函数命名(Naming Functions)

Object-C允许使用通过函数来进行某些操作。当你的底层对象总是一个单例，或者你在处理子模块的时候，你应该使用函数，而不是类方法。

1、下面有一些函数应该遵守的规则:

* 函数的命名格式和方法类似，除此之外，还应遵守下面的两个规则:

1) 它们应该有一致的前缀，该前缀由当前类或者常量组成

2) 前缀后的第一个单词的首字母大写

* 大多数函数的名字都是以它的功能来命名:

```
NSHighlightRect
NSDeallocateObject
```
2、查询属性的函数还有一组命名规则:

* 如果函数返回第一个参数的属性，则忽略该动词

```
unsigned int NSEventMaskFromType(NSEventType type)
float NSHeight(NSRect aRect)
```

* 如果值通过引用返回,则使用“Get”.

```
const char *NSGetSizeAndAlignment(const char *typePtr, unsigned int *sizep, unsigned int *alignp)
```

* 如果返回一个布尔类型的值，该函数的名字应该以变形动词开动.

```
BOOL NSDecimalIsNotANumber(const NSDecimal *decimal)
```
