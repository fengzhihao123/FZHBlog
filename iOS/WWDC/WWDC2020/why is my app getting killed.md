### 造成 App 后台异常退出的原因
* Crashes
* 看门狗事件
* CPU 资源限制
* 内存资源限制
* 内存清理
* 后台任务超时

### Crashes
Crashes 通常由以下三种情况造成：
* 分段错误
* 非法指令
* 断言和未捕获的异常
如果向更进一步了解 Crashes 以及其解决方法，可以看下 WWDC2018 的[解读崩溃和崩溃日志](https://developer.apple.com/wwdc18/414)。

### 看门狗事件
* App 关键切换时超时(切换不要超过 20 s)，在模拟器不会受影响。
    - application(_:didFinishLaunchingWithOptions:)
    - applicationDidEnterBackground(_:)
    - applicationWillEnterForeground(_:)
* 死锁、死循环、主线程同步执行代码。
* 可以通过 `MXCrashDiagnostic` 来获取诊断报告。

### CPU 资源限制
* 在后台高度占用 CPU 资源。
* 如何查看后台占用 CPU 资源：
    - Xcode Organizer
    - MXCPUExceptionDignostic
* 报告中会包含调用栈，以便定位代码问题。
* 如果确实需要 CPU 高强度的工作，可以将工作代码一到 BGProcessingTask 中，它可以在设备夜间充电时运行同时不会受 CPU 资源限制。

### 内存占用过多
* App 运行时占用内存过多。
* App 前台和后台都会有内存限制。
* 可以使用 Instruments 和 Memory Debugger 来定位问题。
* 时刻谨记老的设备，因为越老的设备界限值越低。若 App 内存占用量控制在 200MB 以下会让你的 App 更加安全。

### 内存资源限制
当手机总内存占用过高时，会清除一些 App，以便前台运行的 App 更加流畅。
* 这种情况下被清除，不代表你的 App 有 bug。
* 这是最常见的 App 被终止的方式。
* 如何减少在这种情况下被干掉的概率？
    - 在后台运行时，限制使用小于 50 MB的内存。
    - 将状态缓存到磁盘。
    - 清除内存中的图片资源已释放内存。
    - 清除内存中的缓存。

* 用户不应该感知到 App 在后台被干掉，那如何减少这种感知？
    - 保存当前 view controller 的状态。
    - 保存多媒体播放状态。
    - 保存 textfield 中的内容。
