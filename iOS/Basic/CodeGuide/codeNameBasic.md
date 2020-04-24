# LearniOS

### 基础命名规范(Code Name Basic)

#### 一般命名规范(General Principles)

1、清晰(Clarity)

* 如果既精简又清晰那是最好的，但是你不应该为了精简而摒弃清晰。

示例代码 | 评价|
----|------|
insertObject:atIndex: | Good  | 
insert:at:            | 不清晰，插入什么？at又是具体指的什么 |
removeObjectAtIndex:  | Good  |
removeObject:         | Good, 因为它指出了删除的为对象类型  |
remove:               | 不清晰; 删除什么?|

* 一般情况下，不要缩写名字，即使它们很长。你可能认为简写是众所周知的，但是它可能不是，尤其是那些和你不同语言和不同文化背景的人。

示例代码 | 评价|
----|------|
destinationSelection  | Good   | 
destSel               | 不清晰  |
setBackgroundColor:   | Good   |
setBkgdColor:         | 不清晰  |

* 然而，少数一部分缩写是非常通用的，也有很长的使用历史。你可以继续使用它们；[可用缩写](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/APIAbbreviations.html#//apple_ref/doc/uid/20001285-BCIHCGAE)

* API的名字要避免模棱两可，例如方法名称可以被解读为多个意思。

示例代码 | 评价|
----|------|
sendPort     | 是发送port还是返回port？   | 
displayName  | 它是显示一个名字还是返回用户界面的接受者的title？| 

2、一致性(Consistency)

* 尽量使用和Cocoa 编程风格保持一致。如果你不确定如何命名，你可以浏览本文或者查看API文档。
* 当你有一个方法应该利用多态性的类时，一致性尤为重要。做相同事情的方法在不同的类中应该有相同的名字。

示例代码 | 评价|
----|------|
`- (NSInteger)tag` | 在 NSView, NSCell, NSControl中被定义| 
`- (void)setStringValue:(NSString *)`  | 在很多Cocoa的类中被定义| 

3、不要自我重复No Self Reference

* 名称不要自我重复Names shouldn’t be self-referential.

示例代码 | 评价|
----|------|
NSString | Okey| 
NSStringObject  | NSString和Object重复|

* 作为掩码的常量（因此可以按位操作组合）是此规则的例外，还有通知名称的常量。(此句为google，这是原句:`Constants that are masks (and thus can be combined in bitwise operations) are an exception to this rule, as are constants for notification names`)

示例代码 | 评价|
----|------|
NSUnderlineByWordMask | Okey| 
NSTableViewColumnDidMoveNotification  | Okey|

#### 前缀(Prefixes)

前缀是程序设计非常重要的一种命名方式。不同的前缀在软件区域中有不同的功能。

* 每种前缀有各自规定的格式。它由两个或者三个大写字母组成，它不能使用下划线或者下标。下面是一些具体的例子:

前缀 | Framework|
----|------|
NS | Foundation| 
NS | Application Kit|
AB | Address Book|
IB | Interface Builder|

* 当你命名类、协议、函数、常量和定义结构体的时候应该使用前缀。当命名方法的时候不要使用前缀；方法是存在于定义它们的类的命名空间。在命名结构体的字段时也不要使用前缀。

#### 书写约定(Typographic Conventions)

当命名API元素的时候你要准守一些很简单的约定:

* 名字由多个单词组成，不要使用标点符号或者空格(或者下划线等等)当做名字的一部分；另外，每个单词的首字母要大写然后将这些单词拼在一起即可(第一个单词的首字母要小写)。eg:`runTheWordsTogether`。下面还有几条要求:

1)对于方法的名字，第一个字母小写，以后每个单词的首字母大写。不要使用前缀。

eg:
```
fileExistsAtPath:isDirectory:
```
在该规范中对于方法的名字有一个例外，那就是以总所周知的单词缩写开头的，eg:TIFFRepresentation (NSImage)。

2)对于功能和常量的名字，使用与相关类相同的前缀，并大写嵌入字的第一个字母

```
NSRunAlertPanel
NSCellDisabled
```

* 不要将下划线当做x私有方法的前缀(使用下划线当做实例变量的前缀是可以的)。Apple 存储使用该约定。第三方使用可能导致名称空间冲突；他们可能会不小心重写一个已经存在的私有方法，这将会带来灾难性的后果。

#### 类和协议的名字(Class and Protocol Names)

类的名字应该能清晰的表达这个类的作用。类的名字应该有一个前缀(详情可见前缀)。这个在Foundation和frameworks中有很对例子；例如:NSString, NSDate, NSScanner, NSApplication, UIApplication, NSButton, 和 UIButton等。

协议应该根据他们的组行为来命名:

* 大多数协议组相关的方法和任何类是没有什么特定的关系的。协议的名称不应该和类的名字造成混淆。一个常见的做法就是使用'...ing'，例如:

Code | Commentary|
----|------|
NSLocking | Good| 
NSLock | 有歧义，看起来和类的名字差不多|

* 有些协议有由一部分不想关的方法组成(而不是创建几个单独的小协议)。这些协议倾向于与作为协议的主表达式的类相关联。在这种情况下，应该将协议命名为和类一样的名字。

#### 头文件(Header Files)

如何声明头文件是非常重要的，因为这将说明该文件的包含什么内容。

* 声明一个单独的类和协议。如果类和协议不是组的一部分，那就将类或者协议单独声明在各自的文件中。
Header file | Declares|
----|------|
NSLocale.h | The NSLocale class| 

* 声明相关的类和协议。对于一个组中相关的声明(类，类别，协议)，将声明放在主要的类，类别或协议名称的文件中

Header file | Declares|
----|------|
NSString.h | NSString 和 NSMutableString 类| 
NSLock.h   | NSLocking 协议 and NSLock, NSConditionLock, 和 NSRecursiveLock 类|

* 导入框架头文件。每个框架都应该有一个以框架命名的头文件，包含该框架的所有公共头文件。

Header file | Framework|
----|------|
Foundation.h | Foundation.framework| 

* 给其他的framework中的类添加API。如果你在一个框架中声明的方法，在另一个框架的类的Category中，将'Additions'拼接在原始的类名称后面；例如Application Kit中的NSBundleAdditions.h。

* 相关的功能和数据类型。如果你有组中相关的功能、常量、结构体和其他的数据类型，你应该给他们一个合适的头文件名称，例如NSGraphics.h(Application Kit)。
