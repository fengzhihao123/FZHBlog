## SDWebImage

### 1，sd使用的什么数据结构存储的图片在缓存中？为什么？
* NSCache
* NSCache有自动收回机制来保证缓存的使用；你可以add, remove, and query通过不同的线程而不用添加线程锁；它不会copy key

### sd的实现流程
sd_setImageWithURL
1）调用UIVIew的分类`sd_internalSetImageWithURL`
2）判断operationKey，如果它为空则获取当前控件的类名，然后通过这个key调用sd的取消下载图片的方法
3）通过GCD异步加载placeholder
4）判断URL是否为空，若为空则提示Trying to load a nil url；若不为空则调用loadImageWithURL方法来异步加载图片
5）loadImageWithURL，该方法会首先判断内存和磁盘中是否有缓存，若有缓存则直接读取若没有缓存则使用GCD异步下载图片，将图片加载完成之后再将图片缓存到内存和磁盘中(若选择memoryonly则只缓存在内存中，内存中使用的NSCache，磁盘使用的NSFileManager,key是url.absoluteString)

## AFN