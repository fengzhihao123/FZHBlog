# LearniOS

## 编码规范

### 方法命名

方法也许是你们程序里面最常见的元素，所以你应该特别注意它们的命名。下面一部分就是讨论方法命名方面的注意事项:

#### 一般规则(General Rules)

当你命名方法的名字时，下面这些规则你应该时刻记在脑中:

* 首字母小写，以后每个单词的首字母大写。不要使用前缀。有两种情况是在该规则之外的。你可以使用众所周知的简写大写当做方法的开头(如TIFF或者PDF)，还有一种就是你可以使用前缀来管理和标识私有方法。

* 对于表示一个对象的相关操作的方法，我们应该以动词当做方法的开头:

```
- (void)invokeWithTarget:(id)target;
- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem
```

方法名字中不应该包含'do'或者'dose'这些词，因为它们太泛泛没有实际的意义。还有，不要在动词之前使用副词或形容词。

* 如果方法返回接受者的属性，那么你应该在方法尾部拼接该属性。一般情况下也不要使用'get'，间接的返回一个或者多个值。

|- (NSSize)cellSize;|Right|
|----|----|
|- (NSSize)calcCellSize;|Wrong|
|- (NSSize)getCellSize;|Wrong|

* 在所有参数前使用关键字。

|- (void)sendAction:(SEL)aSelector toObject:(id)anObject forAllCells:(BOOL)flag;|Right|
|----|----|
|- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag;|wrong|

* 在参数前要描述该参数。

|- (id)viewWithTag:(NSInteger)aTag;|Right|
|----|----|
|- (id)taggedView:(int)aTag;|Wrong|

* 当你创建的方法比继承的方法更加具体时，你应该在现有的方法尾部添加一个新的关键字。Add new keywords to the end of an existing method when you create a method that is more specific than the inherited one.

|- (id)initWithFrame:(CGRect)frameRect;|NSView, UIView.|
|----|----|
|- (id)initWithFrame:(NSRect)frameRect mode:(int)aMode cellClass:(Class)factoryId numberOfRows:(int)rowsHigh numberOfColumns:(int)colsWide;|NSMatrix, a subclass of NSView|

* 不要使用'and'来连接接受者的各属性。

|- (int)runModalForDirectory:(NSString *)path file:(NSString *) name types:(NSArray *)fileTypes;|Right.|
|----|----|
|- (int)runModalForDirectory:(NSString *)path andFile:(NSString *)name andTypes:(NSArray *)fileTypes;|Wrong.|

虽然在上面那个例子，用'and'看起来不错，但是它造成你的方法有越来越多的关键字。

* 如果方法描述的是两个独立的操作，你应该使用'and'连接它们。

|- (BOOL)openFile:(NSString *)fullPath withApplication:(NSString *)appName andDeactivate:(BOOL)flag;|NSWorkspace.|
|---|---|

#### 访问器方法(Accessor Methods)

'Accessor methods'指的是设置(set)或者获得(get)一个对象的属性的值的方法。它们的构建方式取决于该属性的表达式:

* 如果属性的表达为名词(noun)，那么它的格式如下:

- (type)noun;
- (void)setNoun:(type)aNoun;

例如:

```
- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;
```

* 如果该属性的表达为形容词，那么它的格式如下:

- (BOOL)isAdjective;
- (void)setAdjective:(BOOL)flag;

例如:

```
- (BOOL)isEditable;
- (void)setEditable:(BOOL)flag;
```

* 如果属性表示为动词，那么它的格式如下:

- (BOOL)verbObject;
- (void)setVerbObject:(BOOL)flag;

例如:
```
- (BOOL)showsAlpha;
- (void)setShowsAlpha:(BOOL)flag;
```

动词应该是简单的现在时。

* 不要使用分词将动词变形为形容词:
|- (void)setAcceptsGlyphInfo:(BOOL)flag;|Right.|
|----|----|
|- (BOOL)acceptsGlyphInfo;|Right.|
|- (void)setGlyphInfoAccepted:(BOOL)flag;|Wrong.|
|- (BOOL)glyphInfoAccepted;|Wrong.|

* 你可以使用情态动词来表达含义(如动词前可以加'can','should','will'等等)，但是不要用'do'or'does'。

|- (void)setCanHide:(BOOL)flag;|Right.|
|----|----|
|- (BOOL)canHide;|Right.|
|- (void)setShouldCloseDocument:(BOOL)flag;|Right.|
|- (BOOL)shouldCloseDocument;|Right.|
|- (void)setDoesAcceptGlyphInfo:(BOOL)flag;|Wrong|
|- (BOOL)doesAcceptGlyphInfo;|Wrong.|

* 仅仅在方法间接返回对象和值的时候使用'get'，也可以在方法返回多个值的时候使用'get'。

|- (void)getLineDash:(float *)pattern count:(int *)count phase:(float *)phase;|NSBezierPath.|
|----|----|

在某些方法里面，实现它的时候应该接受`NULL`来当做输入输出的参数，用来说明调用者不会返回一个或者多个值。

#### 委托方法(Delegate Methods)

委托方法指的是:当某些事件发生的时候，对象调用委托中的方法(如果委托实现了这些方法)。它们有一个独特的形式，同样适用于在对象的数据源中调用的方法:

* 以委托方的类的名字当做方法的开头:

```
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row;
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename;
```

类名要忽略前缀并且首字母小写。

* 冒号要紧跟在类名后面(参数是对委托对象的引用)，除非该方法只有一个参数。

```
- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender;
```

* 这种情况的一个例外，是由于发布通知而调用的方法。在这种情况下，唯一的参数就是通知对象。

```
- (void)windowDidChangeScreen:(NSNotification *)notification;
```

* 对已经发生或即将发生的被调用的委托方的通知方法，我们可以使用使用'did'或'will'。

```
- (void)browserDidScroll:(NSBrowser *)sender;
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window;
```

* 虽然你可以使用'did'或'will'在被调用来要求委托的另一个对象做某事的方法，但是'should'是更好的选择。

```
- (BOOL)windowShouldClose:(id)sender;
```
#### 集合方法(Collection Methods)

对于声明操作对象集合的方法，应该遵守下面的惯例:

- (void)addElement:(elementType)anObj;
- (void)removeElement:(elementType)anObj;
- (NSArray *)elements;

例如:

```
- (void)addLayoutManager:(NSLayoutManager *)obj;
- (void)removeLayoutManager:(NSLayoutManager *)obj;
- (NSArray *)layoutManagers;
```

这里有一些需要注意的事项:

* 如果集合是无序的，那么它将返回一个NSSet对象，而不是NSArray对象。
* 如果它将在集合中一个具体的位置插入一个元素，应该使用类似以下格式的方法。

```
- (void)insertLayoutManager:(NSLayoutManager *)obj atIndex:(int)index;
- (void)removeLayoutManagerAtIndex:(int)index;
```

在实现集合方法的时候，你应该将下面的两个点时刻记在你脑中。

* 这些方法通常意味着所插入对象的所有权，因此添加或插入它们的代码必须保留它们，删除它们的代码也必须释放它们。
* 如果插入的对象需要一个指针返回助对象，你可以使用set来设置返回指针，但是不保留。在`insertLayoutManager：atIndex：`方法的情况下，NSLayoutManager类在这些方法中执行此操作:

```
- (void)setTextStorage:(NSTextStorage *)textStorage;
- (NSTextStorage *)textStorage;
```

通常情况下，你可能不会直接调用`setTextStorage:`，但是可能想去重写该方法。

在上述方法约定的另一个例子来自NSWindow类:

```
- (void)addChildWindow:(NSWindow *)childWin ordered:(NSWindowOrderingMode)place;
- (void)removeChildWindow:(NSWindow *)childWin;
- (NSArray *)childWindows;
 
- (NSWindow *)parentWindow;
- (void)setParentWindow:(NSWindow *)window;
```

#### 方法参数(Methods Arguments)

下面是一些涉及命名方法参数的一些规则:

* 在方法中，参数应该以小写字母开头，然后后面的连续词首字母大写(eg:removeObject:(id)anObject)。
* 参数的名字不要使用 'pointer' 或者 'ptr'. 你不应该将参数声明为类似指针的名称。
* 避免使用一个和两个字母的名称作为参数。
* 避免使用只保留几个字母的缩写。

在Cocoa中，通常情况下，下面的关键字和参数是一起使用的:

```
...action:(SEL)aSelector
...alignment:(int)mode
...atIndex:(int)index
...content:(NSRect)aRect
...doubleValue:(double)aDouble
...floatValue:(float)aFloat
...font:(NSFont *)fontObj
...frame:(NSRect)frameRect
...intValue:(int)anInt
...keyEquivalent:(NSString *)charCode
...length:(int)numBytes
...point:(NSPoint)aPoint
...stringValue:(NSString *)aString
...tag:(int)anInt
...target:(id)anObject
...title:(NSString *)aString
```

#### 私有方法(Privates Methods)

在大多数情况下，私有方法的命名通常遵守的规则和公共方法一样。然而，有一种给私有方法添加一个前缀的通常做法，用来比较容易的区分它和公共方法。即使有这个惯例，当给私有方法命名的时候也可能造成一些罕见的问题。当你设计一个属于Cocoa框架的类的子类的时候，你无法知道你的私有方法是否无意中覆盖了同名的私有框架方法。

大多数Cocoa框架的私有方法的名字都由一个下划线当前缀(eg:_fooData)，这样可以标识其为私有方法。请遵循下面推荐的俩条规则。

* 不要使用下划线当做你的私有方法的前缀，Apple官方保留这一做法。
* 如果你是Cocoa框架中一个非常大的类(eg:UIView)的子类，并且你想确认你定义的私有方法是否在该子类是否重名，你可以在你的私有方法添加自己特有的前缀。这个前缀尽可能是唯一的，可以是基于你的公司或者项目。如你的项目叫Byte Flogger，则为可以这样命名:BF_addObject:.

虽然给私人方法名称一个前缀的建议，可能与之前规定的规则有矛盾，但这里的意图是不同的：这里是为了防止无意重写夫类的私有方法。
