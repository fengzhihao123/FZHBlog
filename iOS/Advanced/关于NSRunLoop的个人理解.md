### NSRunLoop

### link
* [apple document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/Introduction/Introduction.html#//apple_ref/doc/uid/10000057i)
* [reference](http://blog.csdn.net/wzzvictory/article/details/9237973)

* Multiple threads can improve an application’s perceived responsiveness
* Multiple threads can improve an application’s real-time performance on multicore systems.

### you need to start a run loop if you plan to do any of the following:

* Use ports or custom input sources to communicate with other threads.
* Use timers on the thread.
* Use any of the performSelector… methods in a Cocoa application.
* Keep the thread around to perform periodic tasks.

### To get the run loop for the current thread, you use one of the following:

* In a Cocoa application, use the currentRunLoop class method of NSRunLoop to retrieve an NSRunLoop object.
* Use the CFRunLoopGetCurrent function.

### here are several ways to start the run loop, including the following:

* Unconditionally
* With a set time limit
* In a particular mode

Tip: `If one is not attached, the run loop exits immediately.`

