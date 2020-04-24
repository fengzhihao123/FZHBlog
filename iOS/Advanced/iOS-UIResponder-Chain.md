## 理解响应者和响应链如何处理事件

### 事件在APP中如何传递
先看一下Apple文档是如何解释事件的传递:
```
  APP通过UIResponder的实例来处理事件。UIResponder 是UIView/UIViewController/ UIApplication的父类。Responder接受到事件之后只能选择处理事件
或者将事件传递给另一个responder对象，当你的APP接收到一个事件时，UIKit会自动最合适的responder，这就是第一响应者(first responder)。未处理的事件
是会在一个有效的响应链里传递的，这条响应链是由你的APP的responder动态配置的。如果你当前接受事件的view没有处理事件，UIKit会将事件传递给它的父视图，
如果后面的view都没有处理事件的话，它会一次往后传递直到UIApplication。它的路径大概是View->root View->Viewcontroller->root Viewcontroller-
>UIWindow->UIApplication。
注意：如果你UIResponder的实例已经不再响应链之中的话，事件会再从UIApplication传递到app delegate 
```

  通过上文的文档我们可以看到，我们的APP之所以能够处理事件都是依靠responder对象。如果当前接受
到事件的view没有处理事件，该事件会一直传递到UIApplication。

### 决定first responder
  现在我们知道UIKit会自动指定first responder，接下来我们看一下都支持哪些类型的事件：
```
Event Type                 First responder
Touch events               发生touch事件的那个view
Press events               聚焦的那个对象
Shake-motion events        由你或者UIKit指定
Remote-control events      由你或者UIKit指定
Editing menu messages      由你或者UIKit指定

注意：
1.Motion events 并不遵循responder chain
2.Control的Action messages并不是events,但是它们也利用responder chain
```

  通过文档我们知道UIKit会自动查找first responder，那么它是如何实现这个查找过程呢？通过文档
我们可以了解到它底层是通过view-based hit-testing来确定哪里发生了event，具体是通过`hitTest:withEvent:`方法来查找view，将会成为first responder。
```
注意：下面几种情况hitTest:withEvent: 方法会直接忽略该view和其所有的subView
1、view的bounds不包含touch的位置
2、如果view的clipsToBounds为false，它的subView的bounds超出了view的bounds，即使该subView的bounds包含touch的位置
```
   现在我们知道了UIKit通过`hitTest:withEvent:`方法来确定first responder，那么它是如
何确定touch的位置的呢？这个问题我们还是要看一下文档说明：
```
  当触摸发生时，UIKit会创建一个UITouch对象，并将其与视图相关联。随着触摸位置或其他参数的
变化，UIKit会用新信息更新同一个UITouch对象。唯一不变的属性是视图。（即使触摸位置移动到原始视图之外，触摸的视图属性中的值也不会改变。)当触摸结束时，UIKit释放UITouch对象。
```
看完这段话就知道了UIKit是根据UITouch对象来判断的touch的位置。
OK，现在我们看一下event分发的流程[参考](https://www.jianshu.com/p/01368ea1c7f0):
```
1.触碰屏幕产生事件UIEvent并存入UIApplication中事件队列中,并在整个视图结构中自下而上进行分发,如下图
2.UIWindow 接收到事件开始进行最优响应视图查询过程(逆序遍历子视图)
3.当到UiviewController这一层时同样对其视图开始最优响应视图查询,该查询会调用上述提到的两个方法,采用逆序查询也是为了优化查找速度,毕竟后添加的视图易于命中
```

### 修改responder chain
你可以通过重写你responder object的`nextResponder`来修改responder chain。很多UIKit的类已经重写了该属性并返回具体的对象。具体详情请看[文档](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events?language=objc)。

### 实际应用
在日常开发中我们经常会碰到button超出父视图的需求，在这种情况下，超出部分是默认不相应的。这时候我们要重写父视图的`func point(inside point: CGPoint, with event: UIEvent?) -> Bool`方法来让父视图响应超出的部分。

示例：

<img src="https://github.com/fengzhihao123/PersonalBlog/blob/master/resource/resonder-chain-demo.png" width="200" height="200">

代码示例:
```
class RootView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //超出范围
        let radius: CGFloat = 10.0
        print(self.subviews.count)
        var largeBounds = bounds
        largeBounds = CGRect(x: bounds.origin.x - radius, y: bounds.origin.y - radius, width: bounds.size.width + radius, height: bounds.size.height + radius)
        return largeBounds.contains(point)
    }
}
这样超出部分就可以点击响应事件了.
```

### 总结
* event分发与传递:自上而下(UIApplication-window-.....)
* event响应:自下而上(view-superView-.........)

## Link
* [Apple](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events?language=objc)
* [ios中的响应者链-Responder Chain](https://www.jianshu.com/p/01368ea1c7f0)
