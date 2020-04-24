### 一些基础问题

### 不调用dealloc的几种情况
* 控制器中NSTimer没有被销毁
* viewController中的代理不是weak属性
* viewController中block的循环引用