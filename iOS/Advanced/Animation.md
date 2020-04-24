# LearniOS

## Animation

### CALayer

* 不处理用户的交互
* [iOS-UIResponder-Chain](https://github.com/fengzhihao123/PersonalBlog/blob/master/Advanced/iOS-UIResponder-Chain.md)
* CAGradientLayer

------------------------------寄宿图(图层中包含的图)------------------------------

* contents：默认是nil,你可以给它赋值一个CGImage对象来展示一张静态图片,Animatable
```
let image = UIImage(named: "fund_manager_fund_photo_default")
testView.layer.contents = image?.cgImage
```
* contentMode(view)
* contentsGravity(layer)：内容在图层边界中怎么对齐
* contentsScale
* contentsRect：默认是(0.0, 0.0, 1.0, 1.0).可以将几张图拼成一张图
* contentsCenter：拉伸图片的某一部分

Tip:
* 如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法

### UIView没有暴露的CALayer的功能
 
* 阴影、圆角、带颜色的边框
* 3D变化
* 非矩形范围
* 透明套罩
* 多级非线性动画

------------------------------图层几何学------------------------------

* frame并不是一个非常清晰的属性，它其实是一个虚拟属性，是根据bounds，position和transform计算而来，所以当其中任何一个值发生改变，frame都会变化。
* 当view旋转或缩放之后，frame的宽高可能与bounds的宽高不一致
* zPosition：处理3d；修改图层绘制顺序
* anchorPointZ
* anchorPoint
* 坐标系转换方法
```
- (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer; 
- (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer; 
- (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
- (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
```


* CALayer并不关心任何响应链事件，所以不能直接处理触摸事件或者手势。但是它有一系列的方法帮你处理事件：`-containsPoint:`和`-hitTest:`
* UIViewAutoresizingMask

------------------------------视觉效果------------------------------

* conrnerRadius
* borderWidth/borderColor
* shadow
* 边框是绘制在图层边界里面的，而且在所有子内容之前，也在子图层之前

|  name          |      function |
| -------------  |:-------------:|
| shadowOpacity  | opacity | 
| shadowColor    | color 默认黑色 ，推荐黑色     |
| shadowOffset   | offset 默认(0,-3)，推荐y为正数     | 
| shadowRadius   |  radius 默认0，推荐大于零      |
| shadowPath     | path     |

* mask

|  name                |      function |
| -------------        |:-------------:|
| kCAFilterLinear      | opacity       | 
| kCAFilterNearest     | color         |
| kCAFilterTrilinear   | offset        | 

* 使用`shouldRasterize`和`rasterizationScale`来防止含有子视图的视图透明化的问题(我在iOS10上是没有该问题)

```
 button2.layer.shouldRasterize = YES;
 button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
```


* 最后我们再来谈谈minificationFilter和magnificationFilter属性。总得来讲，当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）。原因如下：
```
1)能够显示最好的画质，像素既没有被压缩也没有被拉伸。
2)能更好的使用内存，因为这就是所有你要存储的东西。
3)最好的性能表现，CPU不需要为此额外的计算。
```

* 组透明shouldRasterize

------------------------------变换------------------------------

* 了解一下矩阵
* UIVIew-transform、CALayer-affineTransform: 平移，旋转和缩放
* 斜切
```
//斜切变换
var transform = CGAffineTransform.identity
transform.b = 0
transform.c = -1
alphaButton.layer.setAffineTransform(transform)
```
* iOS的变换函数使用弧度而不是角度作为单位,下面是转换公式
```
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0) 
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)
```
* 注意：变换的顺序会影响最终的结果
```
transform = transform.scaledBy(x: 0.5, y: 0.5)
transform = transform.rotated(by: CGFloat.pi/4)
transform = transform.translatedBy(x: 200, y: 0)
```
* CATransform3D 透视投影 - m34
* 当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你试图通过调整m34来让它更加有3D效果时，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点
* CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
* doubleSided：图层的背面是否要被绘制
[自定义转场动画](https://github.com/ColinEberhardt/VCTransitionsLibrary)

------------------------------专用图层------------------------------

### CAShapeLayer 的一些优点
```
1.渲染快速
2.高效使用内存
3.不会被边界裁减掉
4.不会出现像素化
```

### CATextLayer

### CAGradientLayer
* 是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速 
* locations:locations属性来调整空间。locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置

### CAReplicatorLayer:它的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换

### CAScrollLayer

### CATiledLayer:将大图分解成小片然后将他们单独按需载入。让我们用实验来证明一下

### CAEmitterLayer: 是一个高性能的粒子引擎，被用来创建实时例子动画如：烟雾，火，雨等等这些效果

### CAEAGLLayer

### AVPlayerLayer

### CADisplayLink

------------------------------隐式动画------------------------------
隐式：隐式是因为我们并没有指定任何动画的类型。我们仅仅改变了一个属性，然后Core Animation来决定如何并且何时去做动画

### CATransaction：管理事务
* setDisableActions：开关隐式动画
* UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
* 对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画
* CALayer隐式动画底层实现步骤
```
1.图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
2.如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
3.如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
4.最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
```
* presentationLayer：每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过-presentationLayer方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值

### CATransition

------------------------------显式动画------------------------------

### 属性动画
* 属性动画分为两种：基础和关键帧
* CABasicAnimation: fromValue/toValue/byValue(只需要指定toValue或者byValue，剩下的值都可以通过上下文自动计算出来)

### CAAnimationDelegate

### 关键帧动画-CAKeyframeAnimation
* CAKeyframeAnimation并不能自动把当前值作为第一帧（就像CABasicAnimation那样把fromValue设为nil）。动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值
* rotationMode/keyPath
* 虚拟属性transform.rotation

### CAAnimationGroup

------------------------------图层时间------------------------------
### CAMediaTiming
* duration、repeatCount
* beginTime、speed、timeOffset

### fillMode
* 四种mode
```
public static let forwards: CAMediaTimingFillMode
public static let backwards: CAMediaTimingFillMode
public static let both: CAMediaTimingFillMode
public static let removed: CAMediaTimingFillMode
```
* 当用它来解决这个问题的时候，需要把removeOnCompletion设置为NO，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。

------------------------------缓冲------------------------------

### CAMediaTimingFunction
* CAMediaTimingFunctionName
```
 linear: 线性，默认
 easeIn: 慢慢加速突然停止
 easeOut: 全速开始慢慢停止
 easeInEaseOut: 满加速在满减速，最符合物理，UIView默认动画缓冲是它
 default: 与`easeInEaseOut`类似，创建显式的CAAnimation它并不是默认选项（换句话说，默认的图层行为动画用kCAMediaTimingFunctionDefault作为它们的计时方法）
```

### 自定义缓冲函数
* `public init(controlPoints c1x: Float, _ c1y: Float, _ c2x: Float, _ c2y: Float)`

------------------------------基于定时器的动画------------------------------
### CADisplayLink

### Run Loop 模式
* mode
```
NSDefaultRunLoopMode - 标准优先级
NSRunLoopCommonModes - 高优先级
UITrackingRunLoopMode - 用于UIScrollView和别的控件的动画
```

------------------------------性能调优------------------------------
* 真机测试，而不是模拟器
* difference
```
let image = UIImage(named: "")
let image2 = UIImage(contentsOfFile: "")
```
* draw
