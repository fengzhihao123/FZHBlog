在开始介绍 functionBuilder 的用法前，我们先来看一下目前如何来调用一个 UIAlertController：
```
let alertController = UIAlertController(
    title: "删除",
    message: "确定删除?",
    preferredStyle: .alert
)
let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
    // 删除逻辑
}
let cancelAction = UIAlertAction(title: "取消", style: .cancel)
alertController.addAction(deleteAction)
alertController.addAction(cancelAction)
```
可以看到代码量还是比较多的，下面来看一下如何使用 FunctionBuilder ，来构建一个调用起来更加舒适的 API。

### 什么是 FunctionBuilder

该特性实在 Swift 5.1 开始提出的，由于它现在还未完全支持，所以我们只能使用私有的修饰符 `@_functionBuilder`，而不是 @functionBuilder。你可以在[这里](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md#function-building-methods)找到关于它官方的介绍。

该特性主要侧重于用 DSL 来表示HTML 树，但它也大量应用于 SwiftUI 中，比如 @ViewBuilder。

主要使用的是以下三个方法：
* 必须实现： buildBlock(_ components: Component...) -> Component 
* 可选：buildIf(_ component: Component?) -> Component
* 可选：buildEither(first: Component) -> Component / buildEither(second: Component) -> Component

### FunctionBuilder 初体验
现在来具体实操一下，首先来声明一个 Action 来代替 UIAlertAction：
```
struct Action {
    let title: String
    let style: UIAlertAction.Style
    let action: () -> Void
}
```

接下来声明一个工厂方法来创建 UIAlertController 对象：
```
func makeAlertController(title: String,
                         message: String,
                         style: UIAlertController.Style,
                         actions: [Action]) -> UIAlertController {
    let controller = UIAlertController(
        title: title,
        message: message,
        preferredStyle: style
    )
    for action in actions {
        let uiAction = UIAlertAction(title: action.title, style: action.style) { _ in
            action.action()
        }
        controller.addAction(uiAction)
    }
    return controller
}
```
然后，就是我们的重头戏-`functionBuilder`的使用：
```
@_functionBuilder
struct ActionBuilder {
    typealias Component = [Action]
    static func buildBlock(_ children: Component...) -> Component {
        return children.flatMap { $0 }
    }
}
```
使用它来创建 UIAlertController：
```
func Alert(title: String,
               message: String,
               @ActionBuilder _ makeActions: () -> [Action]) -> UIAlertController {
        makeAlertController(title: title,
                            message: message,
                            style: .alert,
                            actions: makeActions())
    }
```

ok，现在到了品尝胜利果实的时候了，来看一下现在如何调用 UIAlertController：
```
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    [Action(title: "删除", style: .destructive, action: { /* ... */ })]
    [Action(title: "取消", style: .cancel, action: {})]
}
```
额....，虽然代码确实简化了，但闭包里的[Action...]看着还是很怪异。这个可以通过将其包装为类方法来解决，更新 Action 代码如下：
```
extension Action {
    static func `default`(_ title: String, action: @escaping () -> Void) -> [Action] {
        return [Action(title: title, style: .default, action: action)]
    }

    static func destructive(_ title: String, action: @escaping () -> Void) -> [Action] {
        return [Action(title: title, style: .destructive, action: action)]
    }

    static func cancel(_ title: String, action: @escaping () -> Void = {}) -> [Action] {
        return [Action(title: title, style: .cancel, action: action)]
    }
}
```

现在再来看一下使用：
```
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    Action.destructive("删除") { }
    Action.cancel("取消")
}
```
嗯，看起来好多了😊。

### 更进一步 - 如何支持 if
假设我们想在 Alert 的闭包中添加 if 语句的话，编译器会报错：`Closure containing control flow statement cannot be used with function builder 'ActionBuilder'`。比如下面的代码：
```
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    Action.destructive("删除") { }
    if condition {  }
    Action.cancel("取消")
}
```
该错误可以通过实现 `func buildIf(_ component: Component?) -> Component` 来解决，更新后的 ActionBuilder 代码如下：
```
@_functionBuilder
struct ActionBuilder {
    typealias Component = [Action]
    
    static func buildBlock(_ children: Component...) -> Component {
        return children.flatMap { $0 }
    }
    
    static func buildIf(_ component: Component?) -> Component {
        return component ?? []
    }
}
```
如需支持 if - else，则需添加下述两个方法：
```
static func buildEither(first component: Component) -> Component {
    return component
}

static func buildEither(second component: Component) -> Component {
    return component
}
```

Note：若添加上述两个方法，就不再需要 `func buildIf(_ component: Component?) -> Component` 了。

### 最后的尝试 - 支持 for - in
比如下述的代码：
```
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    for str in ["删除", "取消"] {
        Action.default(str) { print(str) }
    }
}
```

创建 helper 函数来解决：
```
func ForIn<S: Sequence>(
    _ sequence: S,
    @ActionBuilder makeActions: (S.Element) -> [Action]
) -> [Action] {

    return sequence
        .map(makeActions) // [[Action]]
        .flatMap { $0 }   // [Action]
}
```

最终，这样使用它：
```
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    ForIn(["删除", "取消"]) { string in
        Action.default(string) { print(string) }
    }
}
```

最后，来个代码对比：
```
let alertController = UIAlertController(
    title: "删除",
    message: "确定删除?",
    preferredStyle: .alert
)
let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
    // 删除逻辑
}
let cancelAction = UIAlertAction(title: "取消", style: .cancel)
alertController.addAction(deleteAction)
alertController.addAction(cancelAction)

// 使用 @_functionBuilder 后的 UIAlertController
let alertVC = Alert(title: "删除", message: "确认删除？") { () -> [Action] in
    Action.destructive("删除") { }
    Action.cancel("取消")
}
```

👀了上面的代码对比，要不要使用 `@_functionBuilder` 就不用我说了吧，大兄嘚。