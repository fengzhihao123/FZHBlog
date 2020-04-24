# LearniOS

## 编码规范

### 开发人员的技巧和贴士(Tips and Techniques for Framework Developers)

注:由于本篇生僻单词较多，所以本篇的翻译是基于google翻译上修改的。

框架开发者应该比其他开发者更加注意他们写的代码。很多APP可能会使用他们的框架，由于它们被广泛使用，所以它们中任何一个小问题都可能会被系统放大而造成损失。以下内容讨论了您可以采用哪些编程技术来确保框架的效率和完整性。

`Note: 一些技术在框架中是不被限制的。你可以将它们应用在开发的程序中。`

#### 初始化 (Initialization)

下面是关于框架初始化的建议和推荐。

##### 类的初始化(Class Initialization)

类的初始化方法应该提供一个地方，去放置那些只会执行一次的代码，这些代码在其它类方法之前被调用。它通常用于设置类的版本号。

`runtime` 会对继承链(inheritance chain)的每个类发送初始化方法，即使它没有实现初始化方法；因此一个类的初始化方法可能被调用多次。通常你会想初始化方法只调用一次。`dispatch_once()`方法可以保证它只调用一次。

```
+ (void)initialize {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        // the initializing code
    }
}
```
Note:因为runtime对每个类发送初始化方法，如果一个子类没有实现它的话，这个初始化方法可能会被调用，然后会一直调用父类的初始化方法。如果你知道具体哪个类需要初始化方法的话，你可以使用下面的方法，而不是使用`dispatch_once():` 

```
if (self == [NSFoo class]) {
    // the initializing code
}
```

你不应该明确调用初始化方法。如果需要触发初始化，调用一些无害的方法:

```
[NSImage self];
```

#### 指定初始化器(Designated Initializers)

指定初始化器指的是调父类的init方法的init方法。 （其他初始化器调用该类定义的init方法。）每个公共类都应该有一个或多个指定的初始化器。作为指定的初始化器的例子有NSView的initWithFrame：和NSResponder的init方法。在init方法不意味着重写的情况下，如NSString和其他抽象类前面的类集群，子类期望自己实现。

指定初始化器应该被清晰的定义，因为这些信息对于想成为它子类的类非常重要。一个子类仅重写指定初始化器，则所有其它初始化器将按照设计工作。

当你实现框架的一个类时，你经常不得不实现它的归档方法(archiving methods)eg:`initWithCoder: and encodeWithCoder:`。不要在初始化代码路径中做任何操作，当对象是未归档(unarchived)的时候，它是不会执行的。 Be careful not to do things in the initialization code path that doesn’t happen when the object is unarchived. 实现这个的一个好方法是从指定的初始化器和initWithCoder：（它是一个指定的初始化器本身）调用一个公共例程，如果你的类实现了归档。

####  初始化期间的错误检测(Error Detection During Initialization)

一个好的初始化方法，应该完整的执行下面这几部，以确保正确检测和防止错误的传播:

* 通过调用super的指定初始化重新分配self。
* 检查nil的返回值，这表示在超类初始化中发生了一些错误。
* 如果初始化当前类的时候发生错误，释放该对象并把它置为nil。

例如:

```
- (id)init {
    self = [super init];  // Call a designated initializer here.
    if (self != nil) {
        // Initialize object  ...
        if (someError) {
            [self release];
            self = nil;
        }
    }
    return self;
}
```
#### 版本控制和兼容性(Versioning and Compatibility)

当你向框架中添加新的类或方法时，通常不必为每个新的功能组指定新的版本号。开发人员通常执行（或应该执行）Objective-C运行时检查，如respondToSelector：以确定某个功能在给定系统上是否可用。这些运行时测试是检查新功能时比较常用和灵活的方法。

但是，您可以使用多种技术来确保框架的每个新版本都已正确标记，并尽可能与早期版本兼容。

##### 框架版本(Framework Version)

当运行时测试不容易检测到新功能或错误修复的存在时，你应该为开发人员提供一些方法来检查更改。实现这一点的一种方法是存储框架的确切版本号，并使这个数字可供开发人员访问

* 在版本号下面记录一下更改内容。
* 设置框架的当前版本号，并提供一些方法使其可以全局访问。您可以将版本号存储在框架的信息属性列表（Info.plist）中，并从中访问它。

##### 键入存档(Keyed Archiving)

如果你的框架的对象需要写入nib文件，他们必须能够归档自己。您还需要使用归档机制来存储文档数据。

关于归档，你应该考虑下面的问题:

* 如果存档中缺少键，则根据要求的类型，要求其值将返回nil，NULL，NO，0或0.0。测试此返回值以减少您写出的数据。此外，您可以找出是否将密钥写入归档。
* 编码和解码方法都可以做到确保向后兼容性。例如，类的新版本的encode方法可以使用键来写新值，但是仍然可以写出较旧的字段，以便类的较旧版本仍然能够理解对象。此外，解码方法可能希望以某种合理的方式处理丢失的值，以便为将来的版本保持一定的灵活性。
* 框架类的归档密钥的推荐命名约定是从用于框架的其他API元素的前缀开始，然后使用实例变量的名称。只要确保名称不能与任何超类或子类的名称冲突即可。
* 如果您有一个写出基本数据类型（换句话说，不是对象的值）的实用程序函数，请务必使用唯一键。例如，归档矩形的“archiveRect”例程应该使用关键参数，并使用它;或者，如果它写出多个值（例如，四个浮点），它应该将自己的唯一位附加到提供的键。
* 由于编译器和字节顺序依赖性，归档位字段可能是危险的。你应该归档它们，只有当出于性能原因，很多位需要写出来，很多次。

#### 异常和错误(Exceptions and Errors)

大多数Cocoa框架方法不强制开发人员捕获和处理异常。这是因为异常不会作为执行的正常部分引起，并且通常不用于传达预期的运行时或用户错误. 例如:

* 没有找到文件
* 没有此用户
* 尝试在应用程序中打开错误类型的文档
* 将字符串转换为指定的编码时出错

但是，Cocoa确实抛出异常来提示开发者编程或逻辑上的错误错误，如下所示:

* 数组越界
* 尝试改变不可变的对象
* 错误参数类型

期望的是，开发人员将在测试期间捕获这些错误并在运送应用程序之前解决它们;因此应用程序不需要在运行时处理异常。如果引发异常并且没有应用程序的任何部分捕获它，则顶级默认处理程序通常捕获并报告异常，然后继续执行。开发人员可以选择将此默认异常捕获器替换为提供有关出错原因的更多详细信息，并提供保存数据和退出应用程序的选项。

错误是Cocoa框架与其他一些软件库不同的另一个领域。 Cocoa方法一般不返回错误代码。在有一个合理的或可能的错误原因的情况下，这些方法依赖于布尔或对象（nil /非nil）返回值的简单测试;记录了NO或nil返回值的原因。您不应该使用错误代码来指示要在运行时处理的编程错误，而是提高异常，或者在某些情况下仅仅记录错误而不引发异常。

例如，NSDictionary的objectForKey：方法返回找到的对象，如果找不到对象，则返回nil。 NSArray的objectAtIndex：方法永远不会返回nil（除了重写的通用语言约定，任何消息到nil导致一个nil返回），因为一个NSArray对象不能存储nil值，并且通过定义任何超越访问是一个编程错误，应导致异常。当对象不能用提供的参数初始化时，许多init方法返回nil。

在少数情况下，方法具有对多个不同错误代码的有效需求，它应该在引用参数中指定它们，返回错误代码，本地化错误字符串或描述错误的其他信息。例如，您可能希望将错误作为NSError对象返回;有关详细信息，请查看Foundation中的NSError.h头文件。这个参数可能是一个更简单的BOOL或直接返回的nil。该方法还应遵守约定，所有参考引用参数是可选的，因此如果发送方不希望知道错误，则允许发送方为错误代码参数传递NULL。

#### 框架数据(Framework Data)

如何处理框架数据对性能，跨平台兼容性和其他目的有影响。本节讨论涉及框架数据的技术。

##### 常量数据(Constant Data)

出于性能原因，将尽可能多的框架数据标记为常量是很好的，因为这样做会减小Mach-O二进制的__DATA段的大小。不是const的全局和静态数据在__DATA段的__DATA部分中结束。这种数据在使用框架的应用程序的每个运行实例中占用内存。虽然额外的500字节（例如）可能看起来不那么糟糕，但是它可能导致所需页面的增量 - 每个应用程序额外增加4千字节。

你应该标记任何常量为const的数据。如果在块中没有char *指针，这将导致数据降落在__TEXT段（这使得它真正恒定）;否则它将保留在__DATA段中，但不会被写入（除非预加载没有完成或者由于在加载时滑动二进制而被违反）。

你应该初始化静态变量，以确保它们被合并到__DATA段的__data部分，而不是__bss部分。如果没有明显的值用于初始化，请使用0，NULL，0.0或任何适当的值。

##### 位域(Bitfields)

如果代码假定值为布尔值，则对位字段使用有符号值，尤其是使用一位位字段，可能会导致未定义的行为。一位位域应始终为无符号。因为可以存储在这样的位域中的唯一值是0和-1（取决于编译器实现），将该位域与1进行比较是假的。例如，如果你在代码中遇到类似的情况:

```
BOOL isAttachment:1;
int startTracking:1;
```

你应该将类型转为无符号整型。

bitfields的另一个问题是归档。一般来说，您不应以位格式将位字段写入磁盘或归档，因为格式在另一个架构或另一个编译器上再次读取时可能不同。

##### 内存分配(Memory Allocation)

在框架代码中，最好的方法是避免分配内存。如果由于某种原因需要临时缓冲区，通常最好使用堆栈而不是分配缓冲区。但是，堆栈的大小有限（通常为512千字节），因此使用堆栈的决定取决于所需的缓冲区的功能和大小。通常，如果缓冲区大小为1000字节（或MAXPATHLEN）或更小，则使用堆栈是可以接受的.

一个改进是开始使用堆栈，但是如果大小要求超过堆栈缓冲区大小，则切换到malloc'ed缓冲区。代码如下:

```
#define STACKBUFSIZE (1000 / sizeof(YourElementType))
 YourElementType stackBuffer[STACKBUFSIZE];
 YourElementType *buf = stackBuffer;
 int capacity = STACKBUFSIZE;  // In terms of YourElementType
 int numElements = 0;  // In terms of YourElementType
 
while (1) {
    if (numElements > capacity) {  // Need more room
        int newCapacity = capacity * 2;  // Or whatever your growth algorithm is
        if (buf == stackBuffer) {  // Previously using stack; switch to allocated memory
            buf = malloc(newCapacity * sizeof(YourElementType));
            memmove(buf, stackBuffer, capacity * sizeof(YourElementType));
        } else {  // Was already using malloc; simply realloc
            buf = realloc(buf, newCapacity * sizeof(YourElementType));
        }
        capacity = newCapacity;
    }
    // ... use buf; increment numElements ...
  }
  // ...
  if (buf != stackBuffer) free(buf);
 ```
 
#### 比较对象

您应该知道通用对象比较方法`isEqual：`和与对象类型相关联的比较方法之间的重要区别，例如`isEqualToString :`.` isEqual：`方法允许您传递任意对象作为参数，如果对象不是同一个类，则返回NO。方法如`isEqualToString：`和`isEqualToArray：`通常假定参数是指定的类型（这是接收器的类型）。因此，它们不执行类型检查，因此它们更快但不安全。对于从外部源检索的值（如应用程序的信息属性列表（Info.plist）或首选项），优选使用isEqual：，因为它更安全;当类型已知时，请使用`isEqualToString:`代替。

关于isEqual的另一点是它与散列方法的连接。对于放置在基于散列的Cocoa集合（例如NSDictionary或NSSet）中的对象的一个​​基本不变量是，如果[A isEqual：B] == YES，则[A hash] == [B hash]。所以如果你在你的类中重写isEqual：，你也应该覆盖hash来保留这个不变量。默认情况下isEqual：寻找每个对象的地址的指针相等，并且hash基于每个对象的地址返回一个哈希值，所以这个不变量保持不变。

