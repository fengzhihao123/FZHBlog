### 什么是 Combine
Combine：一个统一的、声明式的 API，用来处理随时间而改变的数据流。

它可以用来合并异步事件，比如异步调用三个接口，等三个接口全部请求完再处理结果。这种需求就可以使用 Combine 来实现。

#### 可以处理的异步交互
* Targe/Action
* Notification center 
* URLSession
* Key-value observing
* Ad-hoc callbacks

#### 特性
* 支持泛型
* 支持类型安全
* 组合优先
* 请求驱动

### 关键概念
Combine 由三个关键概念来驱动：Publishers、Subscribers、Operators。

#### Publisher
Publisher：用来的定义数据流和错误是如何被处理。底层由 struct 来实现，即为值类型。允许注册 Subscriber。

#### Subscriber
Subscriber：接受 Publisher 传递的值，底层由 class 实现，即为引用类型。

#### Operator
Operator：用来适配 Publisher 到 Subscriber 的数据流，使数据流可在 Subscriber 中使用，值类型。

数据流向：Operator 从上游的 Publisher 接受数据，适配数据，再将适配结果发送给下游的 Subscriber。

声明式操作符 API：
* 函数转变
* 列表操作
* 错误处理
* 线程或队列转移
* 时间调度

