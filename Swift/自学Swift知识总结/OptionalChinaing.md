# LearniOS

## Swift

### Optional  Chaining



#### Tip
* 如果你试图查找一个不是optional类型的值，它将会返回一个变为optional类型的值，因为它处于optional chain(例如：如果你查询的为Int，那么它返回的是Int?)
* 如果你想查找的值就是optional类型，它将不会变的更加optional(例如：如果你想查询的为Int?，那么它将返回Int?,而不是Int?？)
* optional chain是不同于强制解包(forced unwarpping)的一种解包方式，如果optional类型的值为nil，强制解包会发生错误，而optional chain则不会，它会返回一个nil。
