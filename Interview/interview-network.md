#### 请简述 TCP、UDP 的区别
TCP：面向连接，提供可靠性服务，速度较慢；UDP：面向非连接，不提供数据可靠性，速度较快。

#### 了解的端口和对应的服务
* 21 - FTP
* 22 - SSH
* 23 - Telnet
* 25 - SMTP
* 53 - DNS 
* 80 - HTTP
* 443 - HTTPS
* 1080 - Sockets

#### TCP 的三次握手
* client -> server：发送一个 SYN 包，并将序号字段赋一个随机数 x
* server -> client：接收 SYN 包，发送 SYNACK 包，ACK 字段值为 x + 1，序号值为 y
* client -> server：接收 SYNACK 包，SYN 置为 0，ACK 字段值为 y + 1。

#### 有哪些私有的（保留）地址？
私有IP地址是一段保留的IP地址。只是使用在局域网中，在Internet上是不使用的。 

* A类：10.0.0.0 - 10.255.255.255
* B类：172.16.0.0 - 172.31.255.255
* C类：192.168.0.0 - 192.168.255.255

#### IP 地址分为几类？简单说下各个分类
* IPv4
    - 32 bit
    - 允许分片
* IPv6
    - 128 bit
    - 不允许分片

#### 在浏览器中输入网址之后执行会发生什么？
浏览器解析URL生成报文 -> 根据域名通过 DNS 获取 IP 地址 -> 通过系统协议栈将报文传递给运输层 -> 网络层转发到目的地址 -> Server 处理请求返回数据 -> 浏览器接受返回数据，显示。

#### 简单介绍下 ARP 的工作过程

#### OSI 七层模型
* 应用层
* 表示层
* 会话层
* 运输层
* 网络层
* 数据链路层
* 物理层

#### TCP、IP 四层模型
* 应用层
* 传输层
* 网络层
* 链路层

#### HTTP 协议包括哪些请求
* GET/POST/DELETE/PUT/HEAD/OPTIONS/CONNECT

#### HTTP 中 GET 和 POST 的区别
* GET：用于获取信息
* POST：用于更新信息


Source：https://zhuanlan.zhihu.com/p/24001696