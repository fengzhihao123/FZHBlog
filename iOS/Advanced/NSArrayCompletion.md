### NSArray

#### 解决数组越界

Objective-C:
```
+ (void)swizzleSystemMethod:(NSString *)systemMethodStr systemClass:(NSString *)systemClassStr safeMethod:(NSString *)safeMethodStr targetClass:(NSString *)targetClassStr {
    //get system method imp
    Method systemMethod = class_getInstanceMethod(NSClassFromString(systemClassStr), NSSelectorFromString(systemMethodStr));
    //custom method imp
    Method safeMethod = class_getInstanceMethod(NSClassFromString(targetClassStr), NSSelectorFromString(safeMethodStr));
    //
    method_exchangeImplementations(safeMethod, systemMethod);
}

+ (void)load {
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        [self swizzleSystemMethod:@"objectAtIndex:" systemClass:@"__NSArrayI" safeMethod:@"safeObjectAtIndex:" targetClass:@"NSArray"];
        [self swizzleSystemMethod:@"initWithObjects:count:" systemClass:@"__NSPlaceholderArray" safeMethod:@"initWithObjectsSafe:count:" targetClass:@"NSArray"];
        [self swizzleSystemMethod:@"arrayByAddingObject:" systemClass:@"__NSArrayI" safeMethod:@"safeArrayByAddingObject:" targetClass:@"NSArray"];
    });
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return @"index beyond array length";
    }
    return [self safeObjectAtIndex:index];
}

- (NSArray *)safeArrayByAddingObjectSafe:(id)object {
    if (!object) {
        NSLog(@"object cannot be nil");
        return self;
    }
    return [self safeArrayByAddingObjectSafe:object];
}

- (instancetype)initWithObjectsSafe:(id *)objects count:(NSUInteger)count {
    NSUInteger newCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!objects[i]) {
            break;
        }
        newCount++;
    }
    self = [self initWithObjectsSafe:objects count:newCount];
    return self;
}
```

Swift:
```
extension Array {
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
}
```


* [NSMutableArray原理揭露](http://blog.joyingx.me/2015/05/03/NSMutableArray%20%E5%8E%9F%E7%90%86%E6%8F%AD%E9%9C%B2/)
* [iOS数据结构(一):实现NSMutableArray](http://www.liudesheng.com/2016/05/29/iOS%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84-%E5%AE%9E%E7%8E%B0NSMutableArray/)
* [SO](http://stackoverflow.com/questions/6077422/objective-c-nsarray-init-versus-initwithcapacity0/6077543#6077543)
* [教你自己动手一步步实现iOS 数组字典操作safe拓展](http://ios.jobbole.com/87858/)
* [id and *id](http://stackoverflow.com/questions/9263713/arc-pointer-to-non-const-type-id-with-no-explicit-ownership)
* [Objective-C 的底层实现](https://82flex.com/p/objective-c-internals/)
*  一个 CGFloat 在 32 位平台上是 float 的别名，而在 64 位平台上它是 double 的别名
*  [Swift safe Array](https://robinchao.github.io/2016/03/swift-safeindex/)
*  [Objc 黑科技 - Method Swizzle 的一些注意事项](http://swiftcafe.io/2016/12/15/swizzle/)