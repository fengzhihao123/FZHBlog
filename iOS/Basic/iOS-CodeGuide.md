
## iOS 编码规范

进入iOS这一行业也有些年头了，一路走来也经历了几个项目。为什么大多数程序员不愿意接受别人的代码，一来每个人的思维逻辑不一样，二来就是代码的规范性了。如果你接手的项目并没有按照相关的规范编写，那可真是欲哭无泪了。由此可见大家遵守统一的代码规范还是很有必要的。所以在闲暇之余写下这篇文章，希望对别人有所帮助。

1、Effective Objective-C 2.0
1）尽量声明局部常量或者全局变量/常量来代替#define

2）NSArray/NSDictory/NSString/NSNumber 赋值时尽量使用字面量语法(Literal Syntax)。

3）在需要知道接口全部细节的时候才导入头文件，其它则使用`@class xxx;`

2、 声明属性

1）格式
 `@property (nonatomic, strong) UIButton *cancelButton;` 
`@property空格(nonatomic,空格strong)空格UIButton空格*cancelButton;`

Tip：声明property一般都是写好一个然后放在Code Snippet中，[如果不知道这个东西可以参见这](http://www.jianshu.com/p/8f953c4cccd5)


2）内存管理的相关关键字

1)一般`atomic/nonatomic`都是用`nonatomic`
2)`NSArray/NSDictory/NSString/NSSet`和block使用`copy`,其它对象类型使用`strong`
3)基本数据类型使用`assign`,声明协议使用`weak`

3、声明枚举

```
typedef NS_ENUM(NSInteger, CouponType) {
    CouponMoneyOffType,
    CouponFreeType
};
```

4、定义方法

```
- (void)viewDidLoad {
    [super viewDidLoad];
    //do something
}

-空格(void)viewDidLoad空格{ 
    [super viewDidLoad];
    //do something
}
```

5、变量命名

变量命名尽量不要缩写，如
