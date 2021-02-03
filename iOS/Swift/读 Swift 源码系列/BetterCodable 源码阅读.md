## BetterCodable 源码阅读
* [项目地址](https://github.com/marksands/BetterCodable)

该项目通过 Property Wrappers 来简化 Codable 的使用，使其更好的应对值为 nil，或者类型对应不正确而导致解码失败的情况。

本项目支持以下三种类型的 Codable：
* 基本类型。
* 集合类型：Array、Dictionary。
* 日期类型。

### 基本类型
基础类型包含这几个文件：
* DefaultCodable：为缺失值提供自定义实现。
* DefaultFalse：若 Bool 类型的字段解析失败，默认值为 false。
* DefaultTrue：若 Bool 类型的字段解析失败，默认值为 true。
* LosslessValue：将值解析为你声明的类型，比如声明的字段 name 为 String，而服务端返回的值为 Int，解析时自动转为 String。
* LossyOptional：若解析失败，默认值为 nil。
