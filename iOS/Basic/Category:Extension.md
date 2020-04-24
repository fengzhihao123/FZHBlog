# LearniOS
iOS Knowledge
### 目录
<h4><a href="#C01">一、Category </a></h4>
<h5><a href="#C011">1、category的作用</a></h5>
<h5><a href="#C012">2、category的缺点</a></h5>
<h5><a href="#C013">3、使用Category需要注意的地方</a></h5>
<h4><a href="#C02">二、Extensions </a></h4>
<h5><a href="#C021">1、什么是Extension </a></h5>
<h5><a href="#C022">2、Extension的作用</a></h5>
<h4><a href="#C03">三、总结</a></h4>
<h4><a href="#C04">四、参考链接</a></h4>


<h2><a name="C01"> 一、Category</a> </h2>

<h3><a name="C011"> 1、Category的作用 </a> </h3>
#### 1）给已经存在的类添加方法
#### 2）将类的实现分开写在几个分类里面
这样做的好处:

* 可以减少单个文件的体积 
* 可以把不同的功能组织到不同的Category里
* 可以由多个开发者共同完成一个类 
* 可以按需加载想要的category

#### 3）声明私有的方法

<h3><a name="C012">  2、Category的缺点 </a> </h3>
#### 1）不能给相应的类添加`instance variable`
如果你在你的.h文件中写如下代码：
```
{
    NSString *str1;
}
```
Xcode会报如下错误:`Instance variable may not be placed in categories`，通过这句话我们知道Xcode是不允许我们在Category中添加`instance variable`的。

![classStruct](https://github.com/fengzhihao123/LearniOS/blob/master/Basic/classStruct.png)

原因：`在上面的objc_class结构体中，ivars是objc_ivar_list（成员变量列表）指针；methodLists是指向objc_method_list指针的指针。在Runtime中，objc_class结构体大小是固定的，不可能往这个结构体中添加数据，只能修改。所以ivars指向的是一个固定区域，只能修改成员变量值，不能增加成员变量个数。methodList是是一个二维数组，所以可以修改*methodLists的值来增加成员方法，虽没办法扩展methodLists指向的内存区域，却可以改变这个内存区域的值（存储的是指针）。因此，可以动态添加方法，不能添加成员变量`

由此问题引申出一个问题，为什么Category不能添加一个`instance variables`，而能添加`property`?这个我们要从Category的结构体开始分析。

```
typedef struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
} category_t;
```

* 类的名字（name）
* 类（cls）
* category中所有给类添加的实例方法的列表（instanceMethods）
* category中所有添加的类方法的列表（classMethods）
* category实现的所有协议的列表（protocols）
* category中添加的所有属性（instanceProperties）

从Category的定义也可以看出Category的可为（可以添加实例方法，类方法，甚至可以实现协议，添加属性）和不可为（无法添加实例变量）.

#### 2）如何添加`property`？
解决办法:`我们可以Runtime的objc_getAssociatedObject和objc_setAssociatedObject方法来模拟属性的get和set方法，用关联对象来模拟实例变量，这样就有了@property的三要素，只是跟@property的实现机制是完全不一样的。`

##### 添加`property`的两种方法
* 第一种
```
//.h文件：
@property (nonatomic, copy) NSString *str;
//.m文件，要#import <objc/runtime.h>
-(void)setStr:(NSString *)str{
    objc_setAssociatedObject(self, @selector(str), str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)str{
    return objc_getAssociatedObject(self, @selector(str));
}

```

* 第二种
```
static void *UIViewPoint =@"UIViewPoint";
@implementation UIView (Point)

@dynamic pointView;

- (void)setPointView:(UIView *)pointView {
    objc_setAssociatedObject(self, UIViewPoint, pointView,OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)pointView {
   return objc_getAssociatedObject(self, UIViewPoint);
}
```

<h3><a name="C013"> 3、使用Category需要注意的地方 </a> </h3>

* 不要定义一个和原有的类一样的方法，这样会覆盖该类的方法。具体原因看此[博客](http://tech.meituan.com/DiveIntoCategory.html)
* 在Category中是不能添加`instance variables`的。
* Category是在runtime时候加载，而不是在编译的时候。

<h2><a name="C02"> 二、Extensions(OC) </a> </h2>

<h3><a name="C021"> 1、什么是Extension </a> </h3>
虽然类的extention形式上和category有点类似，但是你只能给在编译阶段有源码的类添加extension(extension和类在编译阶段同时编译),所以你不能给framework中的类添加extension(eg:Cocoa或者Cocoa Touch中的NSString，因为你没有NSString的源码),在extension声明的方法必须在原始类的@implementation块中实现。
extensions的声明语法和category的语法比较相似，代码示例:
```
#import "MyClass.h"

@interface MyClass ()
@property (nonatomic, copy) NSString *string;
- (void)printSomething;
@end
```

因为在括号中没有名字，Extensions通常被称为`匿名分类`(anonymous categories),不同于category的是，它可以添加`properties`和`instance variables`。
在编译阶段，编译器会自动合成相关的访问方法，`instance variable`也和方法一样必须在主类的包含在`implementation`模块中。
如果你在Extensions中添加方法，那么你也必须在主类的`implementation`模块中实现它。
代码示例：
```
#import "MyClass.h"
#import "MyClass_addStr.h"
@implementation MyClass
//实现Extensions中声明的方法,该方法只能在类的内部调用，外面是调用不到得.
- (void)printSomething{
    NSLog(@"string is extension");
}

- (void)classPrint{
    self.string = @"ssss";
    [self printSomething];
    NSLog(@"%@",self.string);
}

@end
```

<h3><a name="C022"> 2、Extension的作用 </a> </h3>

* 通过使用Extensions来隐藏私有的信息

### <a name="C03">三、总结</a>

* category可以通过关联对象的方式添加属性(property)，但是不能添加实例变量(instance variable)。
* extensions语法结构和category类似，虽然它叫匿名category，但本质不同，category是在运行时加载，而extensions是在编译阶段加载。
* extensions添加的属性和实例变量都是私有的，只能在主类里面访问。


### <a name="C04">四、参考链接</a>
* [Category深度解析](http://www.jianshu.com/p/a263e53bf4ef)
* [iOS 开发中的争议（一）](http://blog.devtang.com/2015/03/15/ios-dev-controversy-1/)
* [深入理解Objective-C：Category](http://tech.meituan.com/DiveIntoCategory.html)
* [类别(Category)与类扩展 (Extension)的区别](http://www.jianshu.com/p/57d7f1910ef4)
* [Is there a difference between an “instance variable” and a “property” in Objective-c?](http://stackoverflow.com/questions/843632/is-there-a-difference-between-an-instance-variable-and-a-property-in-objecti)
* [ASSOCIATED OBJECT](http://swifter.tips/associated-object/)
* [apple](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html)

### 声明
本文观点均为个人理解，如有错误还请提个issue指正一下。
