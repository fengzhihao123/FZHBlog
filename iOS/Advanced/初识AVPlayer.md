### AVPlayer

* 获取本地视频路径

```
NSString *str = [[NSBundle mainBundle] resourcePath];
NSString *filePath = [NSString stringWithFormat:@"%@%@",str,@"/NBA.mp4"];
NSURL *videoURL = [NSURL fileURLWithPath:filePath];
```
