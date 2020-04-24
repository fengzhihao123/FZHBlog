## @property后面可以有哪些修饰符
* atomic/nonatomic/strong/copy/assign/weak/readwirte/readonly
* atomic 的本意是指属性的存取方法是线程安全的，并不保证整个对象是线程安全的,需要加互斥锁
* 默认基本数据：atomic,readwrite,assign；普通的OC对象：atomic,readwrite,strong

## @synthesize 和 @dynamic分别有什么作用
* @property有两个对应的词，一个是@synthesize，一个是@dynamic。如果@synthesize和@dynamic都没写，那么默认的就是@syntheszie var = _var;
* @synthesize的语义是如果你没有手动实现setter方法和getter方法，那么编译器会自动为你加上这两个方法
* @dynamic 的意思是再别的地方实现，如果你自己实现了访问器则没必要用@dynamic
`Not really, @dynamic means to responsibility of implementing the accessors is delegated. If you implement the accessors yourself within the class then you normally do not use @dynamic`

### @synthesize有哪些使用场景
* 首先的搞清楚什么情况下不会autosynthesis（自动合成）/同时重写了setter和getter时/重写了只读属性的getter时/使用了@dynamic时/在 @protocol 中定义的所有属性/在 category 中定义的所有属性/重载的属性，当你在子类中重载了父类中的属性，必须使用@synthesize来手动合成ivar
* 使用@synthesize foo = _foo;，关联@property与ivar
* 可以用来修改成员变量名，一般不建议这么做，建议使用系统自动生成的成员变量

### link
* [so](https://stackoverflow.com/questions/1160498/synthesize-vs-dynamic-what-are-the-differences)
* [apple](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html)

## Category 和 Extension 的区别
### Category
* 源码:
```
Category
Category 是表示一个指向分类的结构体的指针，其定义如下：
typedef struct objc_category *Category;
struct objc_category {
  char *category_name                          OBJC2_UNAVAILABLE; // 分类名
  char *class_name                             OBJC2_UNAVAILABLE; // 分类所属的类名
  struct objc_method_list *instance_methods    OBJC2_UNAVAILABLE; // 实例方法列表
  struct objc_method_list *class_methods       OBJC2_UNAVAILABLE; // 类方法列表
  struct objc_protocol_list *protocols         OBJC2_UNAVAILABLE; // 分类所实现的协议列表
}
Tip:并没有存放属性的地方
```
* 如果分类中有和原有类同名的方法,会优先调用分类中的方法,就是说会忽略原有类的方法。所以同名方法调用的优先级为 分类 > 本类 > 父类。因此在开发中尽量不要覆盖原有类
* 原则上Category只是扩展本类的方法，不能添加成员变量(可以通过runtime添加上set/get方法，但并没有声明实例变量)

### Extension
* 相当于在.m文件中实现的属性和方法
* 用来实现私有方法和属性
* Extension 没有独立的.m文件，具体实现要依靠对应类的.m文件

### 区别
* Category只能扩展方法(可以通过runtime添加上set/get方法，但并没有声明实例变量)，Extension可以添加属性和方法(只能在本类里面用，相当于private)
* Extension 并没有implementation部分，它要依靠对应类的implementation来实现

### 参考
* [iOS分类(category),类扩展(extension)—史上最全攻略](https://www.jianshu.com/p/9e827a1708c6)

## define 和 const常量有什么区别?
* define在预处理阶段进行替换，const常量在编译阶段使用
* define仅仅进行替换不会进行数据类型检查，const有数据类型
* define可以定义简单的函数，const则不能，只能定义常量
* define定义的常量在替换后运行过程中会不断地占用内存，而const定义的常量存储在数据段只有一份copy，效率更高，所以定义常量的时候尽量使用const

### 参考
* [iOS 宏(define)与常量(const)的正确使用](https://www.jianshu.com/p/f83335e036b5)

## __block 和 __weak的区别
* __block可以修饰基本类型和对象，该修饰符修饰的变量可以在Block中修改
* __weak只能修饰对象类型，不能修饰基本类型
* __weak主要用来解决reference circle

### 参考
* [iOS开发-由浅至深学习block](https://www.jianshu.com/p/29d70274374b)

## static关键词的作用
* static修饰的变量，是一个私有的全局变量

## 栈和堆的区别
* 从管理上：对栈来讲，由编译器自动管理，无需我们手工控制；对于堆来讲，释放工作由程序员控制，可能产生内存泄漏
* 从申请大小上：栈空间比较小；堆空间比较大
* 数据存储方面：栈一般存储基础类型，对象地址；堆空间一般存放对象本身，Block的copy

## Objective-C使用什么机制管理对象内存？
* 使用ARC，通过 retainCount 的机制来决定对象是否需要释放。 每次 runloop 的时候，都会检查对象的retainCount，如果retainCount为0，说明该对象没有地方需要继续使用了，可以释放掉了

## ARC下还会存在内存泄露吗？
* 循环引用会导致内存泄漏
* CoreFoundation中的对象不受ARC管理，需要开发者手动释放

## property的本质是什么
* 它的本质是在编译期间自动生成ivar、set方法、get方法

## @protocol 和 category 中如何使用 @property
* category 使用 @property也是只会生成setter和getter方法声明,如果我们真的需要给category增加属性的实现,需要借助于运行时的两个函数,这两个函数并没有生成实例变量
```
objc_setAssociatedObject
objc_getAssociatedObject
```

* 在protocol中使用property只会生成setter和getter方法声明,我们使用属性的目的,是希望遵守我协议的对象能实现该属性


## ivar、getter、setter是如何生成并添加到这个类中的？
* 这个过程由编译器在编译阶段执行自动合成，所以编辑器里看不到这些“合成方法”(synthesized method)的源代码
* 每次增加一个属性，系统都会在ivar_list中添加一个成员变量的描述、在method_list中增加setter与getter方法的描述、在prop_list中增加一个属性的描述
* 计算该属性在对象中的偏移量
* 然后给出setter与getter方法对应的实现,在setter方法中从偏移量的位置开始赋值,在getter方法中从偏移量开始取值,为了能够读取正确字节数,系统对象偏移量的指针类型进行了类型强转

## KVO、KVC
* KVC :key value coding是一种间接访问实例变量的方法,通过`setvalue:forkey`来设置值，通过`valueforkey`来获取值,如果仍未找到,则调用 `valueForUndefinedKey: `和 `setValue: forUndefinedKey: `方法。这些方法的默认实现都是抛出异常,
* KVO:监听一个对象de 某属性发生变化-1.注册观察者、2.实现`observeValueForKeyPath`、3.移除观察者`removeObserver`
* KVO 底层实现原理是系统给当前类创建子类 , 在子类 setter 方法调用父类的 setter 方法
通过修改 isa 指针指向系统创建的子类 实现当前类属性值改变的监听

## Copy/MutableCopy
* 对于非集合类型，只有不可变的copy是指针复制，其他都是内容复制
```
[immutableObject copy] // 浅复制
[immutableObject mutableCopy] //深复制
[mutableObject copy] //深复制
[mutableObject mutableCopy] //深复制
```
* 对于集合类型，也是只有immutable对象的copy是指针复制，其他都是内容复制。但是集合对象的内容复制仅限于对象本身，对象元素仍然是指针复制
```
[immutableObject copy] // 浅复制
[immutableObject mutableCopy] //单层深复制
[mutableObject copy] //单层深复制
[mutableObject mutableCopy] //单层深复制
```
