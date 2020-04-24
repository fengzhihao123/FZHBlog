# LearniOS

## 编码规范

### 给属性和数据类型命名(Naming Properties and Data Types)

该部分是讨论的如何声明属性，实例变量，常量，通知和异常(properties, instance variables, constants, notifications, and exceptions)

#### 声明属性和实例变量(Declared Properties and Instance Variables)

声明一个属性，实际上就是声明该属性的访问器方法，所以声明属性要遵守的规则和声明访问器方法的规则是一样的。如果实行表示为名词或者动词，它的格式如下:

@property (…) type nounOrVerb;

例如:

```
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showsAlpha;
```
如果属性表示为形容词的话，属性可以省略'is'的前缀。例如:

```
@property (nonatomic, assign) BOOL editable;
```

你也可以这样声明属性:

```
@implementation MyClass {
    BOOL _showsTitle;
}
```

当你给类添加实例变量的时候，下面这几点你要时刻记在脑中:

* 避免声明公共实例变量(public instance variables)。
* 如果你需要声明一个实例变量，你需要明确指出它是@private 还是 @protected。
* 如果你希望你的类将会成为子类，并且这些子类将要直接访问这些数据，你应该使用@protected。

#### 常量(Constants)

常量的规则根据常量的创建方式而变化。

##### 枚举常量(Enumerated constants)

* 对于有整型值的相关的常量组，应该使用枚举。
* 枚举常量的命名规则遵守函数的命名规则。

例如:

```
typedef enum _NSMatrixMode {
    NSRadioModeMatrix           = 0,
    NSHighlightModeMatrix       = 1,
    NSListModeMatrix            = 2,
    NSTrackModeMatrix           = 3
} NSMatrixMode;
```

注意，上面例子中的定义类型的标识`_NSMatrixMode`可以省略。

* 你可以创建没有名字的枚举，类似位屏蔽(bit masks)。例如:
```
enum {
    NSBorderlessWindowMask      = 0,
    NSTitledWindowMask          = 1 << 0,
    NSClosableWindowMask        = 1 << 1,
    NSMiniaturizableWindowMask  = 1 << 2,
    NSResizableWindowMask       = 1 << 3
 
};
```

##### 由const创建的常量(Constants created with const)

* 使用const创建单精度常量。如果该常量是独立的你可以使用const创建，若不是，请使用枚举。枚举常量命名规格和函数命名规则相同。
* const创建的常量格式如下: 

```
const float NSLightGary;
```

##### 其它类型的常量(Other types of constants)

* 通常情况下，不要使用`#define` 预处理器命令来创建常量。对于整型常量，枚举，和使用const创建的单精度常量也是如此。
* 当预处理器决定是否执行某个代码块的时候，标识符号我们应该大写。例如:

```
#ifdef DEBUG
```

* 注意，由编译器定义的宏前后都应该有下划线。例如:

```
__MACH__
```

* 定义诸如通知的名字或者字典的key这样的字符串常量。通过使用字符串常量，你要确定编译器是否指向了正确的值。Cocoa 框架提供了很多字符串常量的例子，例如:

```
APPKIT_EXTERN NSString *NSPrintCopies;
```

实际的NSString值被分配给实现文件中的常量。

#### 通知和异常(Notifications and Exceptions)

通知和异常的命名方式遵循下面几条规则。但是它们也有自己推荐的使用方式。

##### Notifications

如果一个类有一个协议，大多数它的通知将会被由delegate通过一个定义的delegate方法来接受。这些通知的名字应该关联相应的delegate方法。例如，一个NSApplication的全局对象的delegate是自动注册去接受applicationDidBecomeActive: 消息，无论这个application是否发送了NSApplicationDidBecomeActiveNotification。

通知如果由下面这种方法组成全局字符串对象命名，那么该通知是唯一的。

```
[Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
```

例如:

```
NSApplicationDidBecomeActiveNotification
NSWindowDidMiniaturizeNotification
NSTextViewDidChangeSelectionNotification
NSColorPanelColorDidChangeNotification
```

##### Exceptions

虽然对于你的任何想法，你都可以自由的使用异常，但是Cocoa会使用异常来处理程序错误，例如数组越界问题。Cocoa不会用异常来处理正常的或者预期的错误。这种错误应该有返回nil、NULL、no或者错误代码的方式来解决。

异常如果由下面这种方法组成全局字符串对象命名，那么该异常是唯一的。

```
[Prefix] + [UniquePartOfName] + Exception
```

名字中唯一的一部分应该每一个单词的字母都要大写。这有一些例子:

```
NSColorListIOException
NSColorListNotEditableException
NSDraggingException
NSFontUnavailableException
NSIllegalSelectorException
```
