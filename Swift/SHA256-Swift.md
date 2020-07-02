### 引子
在编写个人项目的时候，需要给字符串加密。于是就编写了以前经常使用的MD5加密算法。但是该算法在 XCode 中显示在 iOS13 以后将被废弃，系统推荐使用 SHA256 算法。
下面是被警告的 MD5 算法。
```
var md5: String {
    let utf8 = cString(using: .utf8)
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
    return digest.reduce("") { $0 + String(format:"%02x", $1) }
}
```
### 为什么废弃MD5
通过 Xcode 的警告可以了解到，MD5 在加密方面已经遭到破坏，为了数据安全不应该再使用它，应该使用更加安全的 SHA256 算法。

### 什么是SHA256
SHA 是 Secure Hash Algorithm 的缩写，即安全哈希算法。

SHA 的计算流程：对数字数据进行数学运算 -> 将计算出的哈希值与已知预期的哈希值进行比较 -> 从而确定数据的完整性。

`哈希值可以从任意数据段生成，但该过程不能逆向，即不能从哈希值逆向生成数据。`

SHA256 也成为 SHA2，它是从[SHA1](https://en.bitcoinwiki.org/wiki/SHA-1)进化而来，目前没有发现SHA256被破解，但随着计算机计算能力越来越强大，它肯定会被破解，所以SHA3已经在路上了。
### 如何实现
```
extension String {
    var sha256: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

var str = "hello, world"
print(str.sha256) // 09ca7e4eaa6e8ae9c7d261167129184883644d07dfba7cbfbc4c8a2e08360d5b
```
### 参考
* [SHA256](https://en.bitcoinwiki.org/wiki/SHA-256)