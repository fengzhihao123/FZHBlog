# property

代码示例：
```
@property UIButton *btn1;
@property (atomic, readwrite, strong) UIButton *btn1;
```

上面两句话是等价的。

1、readwrite/readonly

1）读写（readwrite）：该词修饰的property拥有set和get方法，此值为默认值。

2）只读（readonly）：该词修饰的property只拥有get方法。

2、atomic/nonatomic

1）原子性（atomic）：

* 会保证在别的线程来访问这个属性之前，先执行完当前流程
* 速度慢，因为它要保证操作整体完成
* 并不能真正的保证线程安全

eg:如果线程A调了getter方法，与此同时拥有不同值线程B、线程C都调了setter方法，那最后线程A get到的值，3种都有可能：可能是B C set 之前原始的值，也可能是 B set的值，也可能是C set的值。同样，最终这个属性的值，可能是B set的值，也有可能是C set的值。

2）非原子性（nonatomic）：

* 速度比aotomic块
* 一般使用该词声明property
* 线程不安全，如果两个线程同时访问一个property会出现无法预料的结果

3、strong/weak/_ _unsafe_unretained

该修饰词用于除了C语言基本数据类型和NSString之外的类。

1）强引用（strong）：

循环引用（reference circle）示例代码:

```
- (void)setupVC{
    //strongVC 被strong修饰
    ViewController *vc1 = [[ViewController alloc]init];
    ViewController *vc2 = [[ViewController alloc]init];
    vc1.strongVC = vc2;
    vc2.strongVC = vc1;
    NSLog(@"vc1-%p,vc2-%p",vc1.strongVC,vc2.strongVC);
}
```

vc1的strongVC属性引用了vc2，vc2的strongVC属性又引用了vc1。导致vc1e和vc2都不能释放，造成了循环引用。

2）弱引用（weak）：

弱引用：如果weak修饰的变量指向的对象超出它的作用域，并且没有strong修饰的变量指向该对象的话，weak指向的内存地址会自动置为nil。

代码示例：

* 没有strong修饰的变量指向

```
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
    //_weakLabel声明为weak
    NSLog(@"weak2--%@",_weakLabel);//输出为nil
}

- (void)setupLabel{
    UILabel *label = [[UILabel alloc]init];
    _weakLabel = label;
    NSLog(@"weak1--%p",_weakLabel);//输出label
}
```

* 有strong修饰的变量指向

```
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
    //_weakLabel声明为weak,_strongLabel声明为strong
    NSLog(@"weak2--%@",_weakLabel);//输出label
    NSLog(@"strong2--%@",_strongLabel);//输出label
}

- (void)setupLabel{
    UILabel *label = [[UILabel alloc]init];
    _strongLabel = label;
    _weakLabel = label;
    NSLog(@"weak1--%p",_weakLabel);//输出label
    NSLog(@"strong1--%p",_strongLabel);//输出label
}
```

通过上面第二段代码可以看出，虽然weak指向的`label`超出了它的作用域，但是`weak2`还是输出了label的相关信息，造成这种情况的原因是有`strong`的变量`_strongLabel`指向了该label的内存地址，所以该地址并没有得到释放，所以`weak`修饰的变量还能访问该内存地址，并没有置为nil。

用途：常用来来避免循环引用。

为什么IBOut是weak：因为在你拖拽一个控件的时候，该控件的父视图已经强引用了它，如果你设置为strong，父视图销毁的时候，它并不会销毁，这样不仅没有意义而且消耗内存。所以需要设置为weak即可。

3)_ _unsafe_unretained

在iOS4及以前使用该修饰词，作用相当于weak。

4、assign
该词修饰C的基本数据类型，如：Int、Double等

Why：assign其实也可以用来修饰对象，那么为什么不用它呢？因为被assign修饰的对象在释放之后，指针的地址还是存在的，也就是说指针并没有被置为nil。如果在后续内存分配中，刚才分到了这块地址，程序就会崩溃掉。而weak修饰的对象在释放之后，指针地址会被置为nil。

5、copy
该词修饰`NSString`,用来保护其封装性。

6、synthesize/dynamic

1）synthesize：自动合成set/get方法，此方法配合property。如果你直接用`.`语法来访问这个属性的话，你是没必要写synthesize的，因为点语法实质上就是实现了set/get方法。

代码示例：

```
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *string;
@end

@implementation ViewController
@synthesize string;

- (void)viewDidLoad {
    [super viewDidLoad];
    string = @"synthesize";
    NSLog(@"%@",string);
}

@end
```

2）dynamic

手动实现set/get方法。

代码示例:

```
#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (nonatomic, copy) NSString *string;
@end

@implementation ViewController
@dynamic string;

- (void)viewDidLoad {
    [super viewDidLoad];
    //此句相当于调用set方法
    self.string = @"synthesize";
    //此句相当于调用了get方法
    NSLog(@"%@",self.string);
}

-(void)setString:(NSString *)string{
    objc_setAssociatedObject(self, @selector(string), string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)string{
    return objc_getAssociatedObject(self, @selector(string));
}
```

该词表示对于string系统不会自动生成set/get方法，需要你自己写set/get方法。

`@dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。（当然对于 readonly 的属性只需提供 getter 即可）。假如一个属性被声明为 @dynamic var，然后你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var 时，由于缺 getter 方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定`

7、点语法

点语法实质就是调用set/get方法。

代码示例:

```
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *string;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //此句相当于调用了set方法
    self.string = @"synthesize";
    //此句相当于调用了get方法
    NSLog(@"%@",self.string);
}

@end
```

参考：
* [《招聘一个靠谱的iOS》面试题参考答案/《招聘一个靠谱的iOS》面试题参考答案（上）.md#11-synthesize和dynamic分别有什么作用](https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01《招聘一个靠谱的iOS》面试题参考答案/《招聘一个靠谱的iOS》面试题参考答案（上）.md#11-synthesize和dynamic分别有什么作用)
* [What does @dynamic do in Objective-C? [duplicate]](http://stackoverflow.com/questions/4621952/what-does-dynamic-do-in-objective-c)
* [ios 经典面试题总结 -- 内存管理](http://gold.xitu.io/entry/56d94aa21ea493005dc11e8f)
* [[爆栈热门iOS问题]atomic和nonatomic有什么区别？](http://www.jianshu.com/p/7288eacbb1a2)
* [What's the difference between the atomic and nonatomic attributes?](http://stackoverflow.com/questions/588866/whats-the-difference-between-the-atomic-and-nonatomic-attributes/589392#589392)
* [Differences between strong and weak in Objective-C](http://stackoverflow.com/questions/11013587/differences-between-strong-and-weak-in-objective-c)

声明

本文观点均为个人理解，如有错误还请提个issue指正一下。
