## UIView和CALayer是什么关系?
UIView包含CALayer，每个UIView都有一个自己的主Layer，UIView负责处理交互，CALayer负责内容渲染和显示

### 区别
* UIView可以接受并处理事件，CALayer则不可以
* UIView的父类是UIResponder，CALayer的父类是NSObject
* 每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供


### 参考
* [详解CALayer 和 UIView的区别和联系](https://www.jianshu.com/p/079e5cf0f014)

### 扩展
* UIResponder

## LoadView的作用
* loadView用来自定义view，只要实现了这个方法，其他通过xib或storyboard创建的view都不会被加载

## IBOutlet连出来的视图属性为什么可以被设置成weak?
* 因为父控件的subViews已经对它有强引用

## UITableViewCell使用cell和cell.contentView的区别

## imageWithName /imageWithContentsOfFile 区别

## 沙盒目录结构是怎样的？各自用于那些场景？
* Application：存放程序源文件，上架前经过数字签名，上架后不可修改
* Documents：常用目录，iCloud备份目录，存放数据
* Library：Caches：存放体积大又不需要备份的数据；Preference：设置目录，iCloud会备份设置信息
* Tmp：存放临时文件，不会被备份，而且这个文件下的数据有可能随时被清除的可能

## 请简述UITableView的复用机制
* 每次创建cell的时候通过dequeueReusableCellWithIdentifier:方法创建cell，它先到缓存池中找指定标识的cell，如果没有就直接返回nil
* 如果没有找到指定标识的cell，那么会通过initWithStyle:reuseIdentifier:创建一个cell
* 当cell离开界面就会被放到缓存池中，以供下次复用

## 如何高性能的给 UIImageView 加个圆角?
* 绘图
* UIBezierPath

## 如何渲染UIlabel上的文字
* 通过NSAttributedString/NSMutableAttributedString
