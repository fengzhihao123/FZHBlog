### 使用 XCtest 测试动画卡顿。

#### 为什么会出现卡顿？
iPhone 的频率是 60 hz，平均每一帧的时间是 16.67 ms，当 APP 中的帧时间占用大于 16.67 ms 时就会造成视觉上的卡顿。

* 通过两种方式来表示：
    - HItch time：帧延迟显示的时间(ms)。
    - Hitch ratio：每秒延迟的时间，ms/s。
* Hitch ratio 的分级：
    - Good: ≤ 5ms/s
    - Warning: ≥ 5ms/s && ＜ 10ms/s  
    - Critical: ≥ 10ms/s          

#### 如何检测卡顿？- XCTOSSignpostMetric
* 使用 XCTOSSignpostMetric 的预备配置：防止这些配置影响测试结果
    - Scheme -> Test -> Build Configuration 调成 Release 。
    - xctestplan -> Configurations -> Automatic Screenshots 调成 Off。
    - xctestplan -> Configurations -> Code Coverage 调成 Off。
    - xctestplan -> Configurations -> Runtime Sanitization/Runtime API Checking/Memory Management 调成 Off。
* XCTOSSignpostMetric 默认会测试 5 次。
* 测试代码：
```
func testScrollingAnimationPerformance() throws {
    // step1
    let app = XCUIApplication()
    app.launch()
    app.staticTexts["Meal Planner"].tap()
    
    let foodCollection = app.collectionViews.firstMatch
    // step2
    let meausreOptions = XCTMeasureOptions()
    meausreOptions.invocationOptions = [.manuallyStop]
    // step3
    measure(metrics: [XCTOSSignpostMetric.scrollDraggingMetric],
            options: meausreOptions) {
        // 向上滑动
        foodCollection.swipeUp(velocity: .fast)
        // 停止测试 
        stopMeasuring()
        // 向下滑动
        foodCollection.swipeDown(velocity: .fast)
    }
}
```
* 代码说明
    - step1，进入到相关的测试页面。
    - step2，配置 XCTMeasureOptions，表示我们要手动停止每次测试。
    - step3，测试相关 XCTOSSignpostMetric 相关指标。

* 添加手动停止、停止测试、向下滑动的代码重置环境，是因为要保证每次测试的环境是一致的，这样的测试结果才会相对正确。

* XCTOSSignpostMetric 可测试的指标
    - navigationTransitionMetric：测试两个 view 之间导航的动画。
    - customNavigationTransitionMetric：测试两个 view 之间自定义导航的动画。
    - scrollDecelerationMetric：测试减速时的动画。
    - scrollDraggingMetric：测试滑动时的动画。
