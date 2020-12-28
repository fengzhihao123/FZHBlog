## 读 Swift 源码系列 - ArrayBuffer

ArrayBuffer: 它是一个用来给 Array 实现存储和对象管理的类。底层是由 struct 实现的。

### _asCocoaArray()
作用：将 Array 转化为 NSArray

时间复杂度：如果元素类型是类的实例或者遵守了 `@objc` 协议，为O(1)。反之，则为O(*n*)。
```
@inlinable
internal func _asCocoaArray() -> AnyObject {
    return _fastPath(_isNative) ? _native._asCocoaArray() : _nonNative.buffer
}
```


* UnsafeMutableRawPointer
* _fastPath
* SwiftShims
* unsafeBitCast
* withUnsafeBufferPointer/withUnsafeMutableBufferPointer
* _isClassOrObjCExistential
* nativeOwner: