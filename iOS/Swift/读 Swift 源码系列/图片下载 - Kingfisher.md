### 如何实现支持的特性
* 异步下载缓存图片
    - 下载图片的函数调用栈：setImage -> retrieveImage -> loadAndCacheImage -> downloadImage -> resume
    - 使用 NSLock 来保证线程安全。
    - 缓存图片的函数调用栈：cacheImage -> store -> storeNoThrow/syncStoreToDisk(队列异步执行)
* 可加载网络和本地的图片
    - 加载网络图片使用👆的步骤。
    - loadAndCacheImage 函数中，case 为 provider ，则会调用 provideImage 设置本地的图片并缓存。
* Multiple-layer hybrid cache for both memory and disk.
* Fine control on cache behavior. Customizable expiration date and size limit.
* Cancelable downloading and auto-reusing previous downloaded content to improve performance.
* Independent components. Use the downloader, caching system and image processors separately as you need.
* Prefetching images and showing them from cache to boost your app.
* View extensions for UIImageView, NSImageView, NSButton and UIButton to directly set an image from a URL.
* Built-in transition animation when setting images.
* Customizable placeholder and indicator while loading images.
* Extensible image processing and image format easily.
 SwiftUI support.