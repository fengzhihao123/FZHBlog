# Note


-------------------------------P9-------------------------------

## Animation 
动画可以用来修改view的下列属性:
* frame/center
* bounds
* transform(形变、旋转)
* alpha
* background

### UIViewPropertyAnimator

#### 通过类方法调用
* runningPropertyAnimator(withDuration:delay:options:animations:completion:),此方法opetions默认为curveEaseInOut,在等待delay的时间之后，会自动调用startAnimation()

### Dynamic Animation

#### 通过三步来使用
* 创建一个UIDynamicAnimator 
```
let animator = UIDynamicAnimator(referenceView: self.view)
```
* 创建并添加一个UIDynamicBehavior实例
```
let gravity = UIGravityBehavior()
animator.addBehavior(gravity)
```
* 将UIDynamicItems添加到UIDynamicBehavior中
```
let item1: UIDynamicItem = animatorView
gravity.addItem(item1)
```

#### Behaviors
* UIGravityBehavior
* UIAttachmentBehavior
* UICollisionBehavior
* UISnapBehavior
* UIPushBehavior,使用的时候注意memory cycle
* UIDynamicItemBehavior
* 当behavior执行的时候会调用`var action: (() -> Void)?`，该方法会调用很多次要谨慎使用。


## Tip
* forEach
```
var arr = [1,2,3,4,5]
arr.forEach { print($0 * 2) }
```

## Link
* [iOS UIDynamicAnimator 简介](https://www.jianshu.com/p/0546fee5aede)


-------------------------------P10-------------------------------
## source control
Xcode相关

-------------------------------P11-------------------------------
## VC Lifecycle&&UIScrollView
### Lifecycle
* viewDidLoad:只会调用一次
* viewWillAppear：可以调用多次
* viewDidAppear：可以在此方法里面调用网络接口、Timer等耗时的操作，因为在这里我们知道视图已经加载完了
* viewWillDisappear：可以在这里进行停止timer或者notification等
* viewDidDisappear：save some state or release some large, recreatable resource

### Geometry-视图
```
override func viewWillLayoutSubviews()
override func viewDidLayoutSubviews()
```

### Autorotation
* viewWillTransition

### Low memory
* didReceiveMemoryWarning() :当发生内存警告的时候iOS会调用这个方法，你可以在这个方法中移除一些占用缓存的操作

### Waking up from an storyboard
* func awakeFromNib()：It’s primarily for situations where code has to be executed VERY EARLY in the lifecycle.

### Lifecycle总结
* 实例化
* 执行awakeFromNib（仅在从storyboard实例化的时候调用）  
* segue preparation happens
* outlets get set
* viewDidLoad
* 当每次你的controller从屏幕出现或者消失的时候都会调用viewWillAppear/viewDidAppear和viewWillDisappear/viewDidDisappear
* These “geometry changed” methods might be called at any time after viewDidLoad ... viewWillLayoutSubviews and viewDidLayoutSubviews
* 当内存过低时就会调用`didReceiveMemoryWarning`，无论什么时候

Lifecycle method
init(coder:)
(void)loadView
(void)viewDidLoad
(void)viewWillAppear
(void)viewDidAppear
(void)viewWillDisappear
(void)viewDidDisappear
=======
* do-catch/try?
```
let url = URL(string: "xxxx")!
//first
let urlContent = try? Data(contentsOf: url)
//second
do {
    let urlContent2 = try Data(contentsOf: url)
} catch let error {
    print(error)
}
```

* IB - UIImageView -intrinsic size/sizetoFit()

-------------------------------P12-------------------------------
## Multihreading
### Queues
### Main Queue
### Global Queues

* 如果block中的需要的资源时间很长，即使没有产生memory cycle，最好也设置成weak，这样才能及时释放持有的资源。
* anchor、auto layout in uiview  document
* size class
* vary for traits
* trait collection

-------------------------------P13-------------------------------
* drag / drop
* tableview/collectionview

-------------------------------P14-------------------------------
* UITextField
* keyboard

-------------------------------P15、P16-------------------------------
## Persistence
* Userdefaults:微型数据库，非常小，不要放置大数据；支持数据类型： Array, Dictionary, String, Date, Data or a number (Int, etc.)；通过调用`synchronize()`保持同步更新
* Property list
* Archiving and Codable:支持非标准类型
* Filesystem
* Core Data
* Cloud Kit
* UIDocument UIDocumentBrowserViewController

-------------------------------P17-------------------------------
## Alert/Action sheet
## Notifications/KVO
## Application Lifecycle
*  let myApp = UIApplication.shared、It manages all global behavior、You never need to subclass it

-------------------------------P18-------------------------------
## Modal
* modalTransitionStyle：modal的样式

## Core Motion
## UIPickerController
