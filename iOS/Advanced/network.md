## Network

### URLSession/NSURLSession(iOS 7 及以后，NSURLConnection在以前使用)
URLSession相当于管理一个请求的类，它涉及到URL/URLRequest/URLSessionConfiguration/URLSessionTask。通过这几个类的综合使用，我们就可以很方便的创建请求

#### 创建GET请求

```
let userTel = "13231852031"
let userPassword = "123456"
let defaultConfiguration = URLSessionConfiguration.default
let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
if let url = URL(string: "http://127.0.0.1:8080/v1/login?usertel=\(userTel)&userpassword=\(userPassword)") {
    (sessionWithoutADelegate.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
        } else if let response = response,
            let data = data,
            let string = String(data: data, encoding: .utf8) {
            print("Response: \(response)")
            print("DATA:\n\(string)\nEND DATA\n")
        }
    }).resume()
}
```

#### 创建POST请求

```
let defaultConfiguration = URLSessionConfiguration.default
let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
let paramer: [String: String] = ["userTel":"13231852031","userPassword":"123456"]

if let url = URL(string: "http://127.0.0.1:8080/v1/register") {
    var request = URLRequest.init(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: paramer, options: JSONSerialization.WritingOptions.prettyPrinted)
    
    sessionWithoutADelegate.dataTask(with: request, completionHandler: { (data, response, error) in
        if let error = error {
            print("Error:\(error)")
        }else if let response = response,
            let data = data,
            let string = String(data: data,encoding: .utf8){
            print("Response: \(response)\n")
            print("DATA:\(string)\n")
        }
    }).resume()
}
```

### 根据Alamofire的README读其源码

#### Swift版本和Alamofire版本

* Swift:3.0
* Alamofire:4.4.0

#### Making a Request

```
Alamofire.request("https://httpbin.org/get")
```

首先，文档中给出上面的一个例子，我们可以看到很简单就发送了一个请求。接下来我们可以看一下Alamofire是如何实现的request，通过跳转我们可以看到该方法是实现在Alamofire.swift文件中:

```
@discardableResult
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil)
    -> DataRequest
{
    return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}
```

首先该方法通过`URLConvertible`协议来判断URL的有效性(如未无效URL会抛出Error)，然后方法默认为GET，parameters参数默认为空，参数编码默认为URLEncoding.default，header默认为空。在该方法中又调用了`SessionManager`，接下来我们再跳转到SessionManager，在SessionManager中的request方法实现如下(由于方法较长下面代码只贴关键部分):

```
do {
    originalRequest = try URLRequest(url: url, method: method, headers: headers)
    let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
    return request(encodedURLRequest)
} catch {
    return request(originalRequest, failedWith: error)
}

```

在上述实现中我们可以看到，如果各项参数都没问题的话，它会进入`do`代码块中request方法.
do中的request方法实现如下:

```
do {
    originalRequest = try urlRequest.asURLRequest()
    let originalTask = DataRequest.Requestable(urlRequest: originalRequest!)
    let task = try originalTask.task(session: session, adapter: adapter, queue: queue)
    let request = DataRequest(session: session, requestTask: .data(originalTask, task))
    delegate[task] = request
    if startRequestsImmediately { request.resume() }
    return request
} catch {
    return request(originalRequest, failedWith: error)
}
```

还是在判断各项参数都正确后调用resume方法，在该方法中它会调用URLSessionTask的`resume()`来启动该次请求。由此我们可以看出虽然我们只是调用这么简单的一句话，但是里面还是由很多条件和逻辑的，只不过这一切Alamofire替我们做了。

上述的代码逻辑如果把所有的错误检查和判断逻辑简化掉，类似于下方的代码:

```
let url = URL.init(string: "http://example.com")
let session = URLSession.shared
session.dataTask(with: url!).resume()
```

#### Response Handling

Alamofire默认有五种response handler:
* Response Handler - Unserialized Response(没有序列化response)
* Response Data Handler - Serialized into Data(将数据序列化为Data)
* Response String Handler - Serialized into String(将数据序列化为String)
* Response JSON Handler - Serialized into Any(将数据序列化为Any)
* Response PropertyList (plist) Handler - Serialized into Any(同上)

Tip:上述五种response handler都没对返回数据的HTTPURLResponse做验证，Alamofire是通过[Response Validation](https://github.com/Alamofire/Alamofire#response-validation)做验证的。

##### Response Handler

```
Alamofire.request("https://httpbin.org/get").response { response in
}
```

ResponseSerialization.swift中的方法实现:

```
 delegate.queue.addOperation {
    (queue ?? DispatchQueue.main).async {
        var dataResponse = DefaultDataResponse(
            request: self.request,
            response: self.response,
            data: self.delegate.data,
            error: self.delegate.error,
            timeline: self.timeline
        )

        dataResponse.add(self.delegate.metrics)

        completionHandler(dataResponse)
    }
```

`DefaultDataResponse`为结构体，包含request、response、data等数据。

Alamofire不建议使用这种response serializers。

##### Response Data Handler
```
Alamofire.request("https://httpbin.org/get").responseData { response in
}
```

如果请求数据和解析数据的过程中没有发生错误，它将返回一个Data类型的数据，Response的Result将会是.success。在该方法的实现源码中调用了`responseSerializer: DataRequest.dataResponseSerializer()`序列化数据的方法

##### Response String Handler

```
Alamofire.request("https://httpbin.org/get").responseString { response in
}
```

该Handler通过`responseStringSerializer`将返回的Data数据转为String类型，如果没有错误发生，并且服务器数据成功转为String，response的Result将为.success并且值为String。

##### Response JSON Handle

```
Alamofire.request("https://httpbin.org/get").responseJSON { response in
}
```

该handler通过调用`jsonResponseSerializer`方法来转换数据类型，若没发生错误request同上

##### Chained Response Handlers

Tip:使用链式response包含几个handler，就会请求几次数据数据

##### Response Handler Queue
Response handlers默认在主线程队列中执行，但是我们可以提供一个自定义线程队列

#### Response Validation
默认情况下，Alamofire认为任何已完成的请求都是成功的，无论相应内容是什么。你可以在handler之前调用`validate`来判断status code

#### HTTP Methods
Alamofire支持HTTP的GET、POST、DELETE等方法，并将这些方法声明为`HTTPMethod`的enum

#### Parameter Encoding
Alamofire提供三种参数编码方式URL,JSON和PropertyList

#### Session Manager
SessionManager.swift是Alamofire中比较重要的一个文件，它是URLSession的管理类，文件中是对request方法的具体实现。正是有该类才使得Alamofire发起一个请求非常简单。
通过源码我们可以看见如果不设置URLSessionConfiguration，默认为URLSessionConfiguration.default
你也可以将URLSessionConfiguration修改为Background Configuration和Ephemeral Configuration

#### Request
Requests可以被暂停(suspended)复位(resumed)和取消(cancelled)

#### Routing Requests
随着APP的不断更新和迭代，构建网络层的通用模式很重要。如何路由你的request也是非常重要的一个部分。`URLConvertible`和`URLRequestConvertible`协议可以帮助你构建路由的通用部分

##### URLConvertible
String, URL, 和URLComponents是默认遵守`URLConvertible`协议的，所以你可以在request中写String, URL, 和URLComponents，它会自动检测request中的参数，根据参数类型找到相应的方法转为URL。你也可以根据文档中的例子来构造自己的路由

##### URLRequestConvertible
URLRequest默认遵守该协议，该协议用来构造URLRequest


#### 代码中的关键字解释
* `@discardableResult`:此关键字表示修饰的方法不必接受返回值Swift 3.0 中方法的返回值必须有接收否则会报警告，当然其实主要目的是为了避免开发人员忘记接收返回值的情况，但是有些情况下确实不需要使用返回值可以使用"_"接收来忽略返回值。当然你也可以增加@discardableResult声明，告诉编译器此方法可以不用接收返回值
* `open`:open 一个元素在其他module中还是可以被override
* `static`:在方法的func关键字之前加上关键字static或者class都可以用于指定类方法.不同的是用class关键字指定的类方法可以被子类重写
* `@escaping`

#### 总结
至此，Alamofire的源码已经了解完，我在这里只是简单的了解一下Alamofire是如何实现最基本的GET和POST请求如何实现。可以看到，它通过几层包装实现了参数的校验、request支持String、URL和URLComponents三种方式。由于水平有限，对于它下载上传等功能的源码并没有十分理解，所以在这并没有写，大家有能力的可以自行查看源码。在Alamofire中比较重要的几个文件Alamofire.swift/Response.swift/SessionManager.swift/Request.swift。

### 参考
* [GET/Post Request](http://ios.jobbole.com/85378/)
* [Apple Document](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/CookiesandCustomProtocols/CookiesandCustomProtocols.html#//apple_ref/doc/uid/10000165i-CH10-SW3)
* [译-URL-Session编程指南](http://www.wenghengcong.com/2016/09/%E8%AF%91-URL-Session%E7%BC%96%E7%A8%8B%E6%8C%87%E5%8D%97/)
* [iOS开发系列--Swift 3.0](http://www.cnblogs.com/kenshincui/p/5594951.html)
* [Swift 3必看：新的访问控制fileprivate和open](http://www.jianshu.com/p/604305a61e57)
* [Swift_关键字static和class的区别](http://www.jianshu.com/p/a9c9e7313438)