## 创建自己的Pod

### pod 相关命令
* [what's the different between 'pod spec lint' and 'pod lib lint'](http://stackoverflow.com/questions/32304421/whats-the-different-between-pod-spec-lint-and-pod-lib-lint)

### 中途遇到的错误
* error:ERROR:While executing gem ... (Errno::EPERM)Operation not permitted - /usr/bin/pod.[answer](http://stackoverflow.com/questions/30812777/cannot-install-cocoa-pods-after-uninstalling-results-in-error/30851030#30851030)
* error: Unable to find a pod with name, author, summary, or description matching `FZHInitialize` [answer](http://blog.cocoachina.com/article/29127)

```
pod setup成功后，依然不能pod search，是因为之前你执行pod search生成了search_index.json，此时需要删掉。
终端输入：rm ~/Library/Caches/CocoaPods/search_index.json
删除成功后，再执行pod search。
```

* error:ERROR | [iOS] file patterns: The `source_files` pattern did not match any file.

可能原因:
* This was also driving me nuts for 'hours'. I then discovered that the files and tags must be present in the source git repo. So make sure you push your code and your tags to the remote repo


我的情况的最终解决办法：将`s.source`中的tag改为最近的commit
```
 s.source       = { :git => "https://github.com/fengzhihao123/FZHProjectInitializer.git", :commit => "e004159d7d4cf32734ca52680b6af1bd5516aaf2" }
 ```

 ### 参考文章
* [CocoaPods](http://guides.cocoapods.org/making/specs-and-specs-repo.html)
* [如何发布自己的开源框架到CocoaPods](http://www.jianshu.com/p/32ba94d41861)
* [如何创建tag](http://caibaojian.com/github-create-tag.html)
* [如何打造一个让人愉快的框架](https://onevcat.com/2016/01/create-framework/)
