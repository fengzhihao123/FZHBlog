
## 利用系统自带框架实现扫一扫功能
### 实现功能前的项目配置
因为该项目要使用到相机和相册。所以我们要在info.plist中设置询问用户是否允许访问的权限。因为需要调用摄像头，所以要在真机上运行(在模拟器运行会崩溃)。
### 功能分析
从功能需求分析来看，扫一扫该功能可以分为以下几个功能点:
* 在启动设备时设置loading view
* 使用CGContextRef绘制扫一扫界面UI
* 使用NSTimer实现扫描线动画
* 使用AVFoundation框架实现扫描功能
* 实现扫描二维码图片(系统只支持二维码，不支持条形码)，调用系统闪光灯
* 在扫描完成后将值传给上一个界面(Block反向传值)

### 具体实现
* 在启动设备时设置loading view
1.创建继承 `UIActivityIndicatorView` 的LoadView，在.m文件中写初始化代码:

```
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 菊花背景的大小
        self.frame = CGRectMake((ScreenWidth - 100)/2, (ScreenHeight - 100)/2, 100, 100);
        // 菊花的背景色
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        // 在菊花下面添加文字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 40)];
        label.text = @"loading...";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return  self;
}
```
2.将LoadView添加到bgView中:

```
- (void)setupBgView {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor = [UIColor blackColor];
    
    LoadView *loadView = [[LoadView alloc]init];
    [_bgView addSubview:loadView];
    // 动画开始
    [loadView startAnimating];
}
```

* 使用CGContextRef绘制扫一扫界面UI
1.创建继承与UIView的ScanView，在.m文件中写下面的绘制代码:

```
- (void)drawRect:(CGRect)rect {
    CGFloat rectWidth = 50;
    CGFloat rectHeight = 200;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0.0, 0.0, 0.0, _alphaValue};
    CGContextSetFillColor(context, black);
    //top
    CGRect rect1 = CGRectMake(0, 0, self.frame.size.width, rectHeight);
    CGContextFillRect(context, rect1);
    //left
    rect1 = CGRectMake(0, rectHeight, rectWidth, rectHeight);
    CGContextFillRect(context, rect1);
    //bottom
    rect1 = CGRectMake(0, rectHeight * 2, self.frame.size.width, self.frame.size.height - rectHeight * 2);
    CGContextFillRect(context, rect1);
    //right
    rect1 = CGRectMake(self.frame.size.width - rectWidth, rectHeight, rectWidth, rectHeight);
    CGContextFillRect(context, rect1);
    CGContextStrokePath(context);
    
    //中间画矩形(正方形)
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddRect(context, CGRectMake(rectWidth, rectHeight, self.frame.size.width - rectWidth * 2, rectHeight));
    CGContextStrokePath(context);
    
    CGFloat lineWidth = 10;
    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    //左上角水平线
    CGContextMoveToPoint(context, rectWidth, rectHeight);
    CGContextAddLineToPoint(context, rectWidth + lineWidth, rectHeight);
    
    //左上角垂直线
    CGContextMoveToPoint(context, rectWidth, rectHeight);
    CGContextAddLineToPoint(context, rectWidth, rectHeight + lineWidth);
    
    //左下角水平线
    CGContextMoveToPoint(context, rectWidth, rectHeight * 2);
    CGContextAddLineToPoint(context, rectWidth + lineWidth, rectHeight * 2);
    
    //左下角垂直线
    CGContextMoveToPoint(context, rectWidth, rectHeight * 2 - lineWidth);
    CGContextAddLineToPoint(context, rectWidth, rectHeight * 2);

    //右上角水平线
    CGContextMoveToPoint(context, self.frame.size.width - rectWidth - lineWidth, rectHeight);
    CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight);
    
    //右上角垂直线
    CGContextMoveToPoint(context, self.frame.size.width - rectWidth, rectHeight);
    CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight + lineWidth);

    //右下角水平线
    CGContextMoveToPoint(context, self.frame.size.width - rectWidth - lineWidth, rectHeight * 2);
    CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight * 2);
    //右下角垂直线
    CGContextMoveToPoint(context, self.frame.size.width - rectWidth, rectHeight * 2 - lineWidth);
    CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight * 2);
    CGContextStrokePath(context);
}
```

2.将scanView添加到self.view中:

```
- (void)setupScanView {
    _scan = [[ScanView alloc]initWithFrame:self.view.bounds];
    _scan.backgroundColor = [UIColor clearColor];
    
    _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(_viewWidth, 201, ScreenWidth - _viewWidth * 2, 1)];
    _slideLineView.backgroundColor = [UIColor greenColor];
    [_scan addSubview:_slideLineView];
    [self.view addSubview:_scan];
    [self setupSubView];
}
```

3.设置self.view中的闪光灯按钮和访问相册按钮:

```
- (void)setupSubView {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 500, ScreenWidth, 50.0)];
    _titleLabel.text = @"请将二维码放入框内";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_scan addSubview:_titleLabel];
    
    _lightButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 580, 50, 50)];
    [_lightButton setTitle:@"light" forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(lightButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [_scan addSubview:_lightButton];
    
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 580, 50, 50)];
    [_imageButton setTitle:@"相册" forState:UIControlStateNormal];
    [_imageButton addTarget:self action:@selector(imageButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [_scan addSubview:_imageButton];
}
```

4.闪光灯按钮的点击事件:

```
AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        NSLog(@"no torch");
    }else {
        [device lockForConfiguration:nil];
        if (!self.isOpen) {
            [device setTorchMode: AVCaptureTorchModeOn];
            self.isOpen = YES;
        }
        else {
            [device setTorchMode: AVCaptureTorchModeOff];
            self.isOpen = NO;
        }
        [device unlockForConfiguration];
    }
```

5.访问相册按钮的点击事件:
```
- (void)imageButtonDidTouch {
    [_timer invalidate];
    _timer = nil;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //设置图片源(相簿)
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //设置代理
    picker.delegate = self;
    //设置可以编辑
    picker.allowsEditing = YES;
    //打开拾取器界面
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate methods
//完成选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 根据URL找到CIImage
    CIImage *ciImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    if (ciImage){
        // 创建CIDetector
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy: CIDetectorAccuracyHigh }];
        NSArray *features = [detector featuresInImage:ciImage];
        if ([features count] > 0) {
            for (CIFeature *feature in features) {
                if (![feature isKindOfClass:[CIQRCodeFeature class]]) {
                    continue;
                }
                CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
                NSString *code = qrFeature.messageString;
                if (self.resultBlock) {
                    self.resultBlock(code);
                    [self scanSuccess];
                }
                //输出扫描字符串
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [self setupTimer];
        }
    }
}
//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
```

* 使用NSTimer实现扫描线动画
实现扫描线代码如下:

```
- (void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(animationView) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)animationView {
    [UIView animateWithDuration:1.5 animations:^{
        _slideLineView.transform = CGAffineTransformMakeTranslation(0, 200);
    } completion:^(BOOL finished) {
        _slideLineView.transform = CGAffineTransformIdentity;
    }];
}
```

* 使用AVFoundation实现扫描功能
1.导入<AVFoundation/AVFoundation.h>，遵守AVCaptureMetadataOutputObjectsDelegate。
初始化代码如下:

```
- (void)setupAVFoundation {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    //开始捕获
    [_session startRunning];
    //移除loading view
    [_bgView removeFromSuperview];
}
```

2.实现AVCaptureMetadataOutputObjectsDelegate

```
#pragma mark 输出的代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [_timer invalidate];
        _timer = nil;
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex: 0];
        if (self.resultBlock) {
            self.resultBlock(metadataObject.stringValue);
            [self scanSuccess];
        }
        //输出扫描字符串
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//扫描成功的提示音
- (void)scanSuccess {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1109);
}
```

### 结束语
至此，即可实现利用原生框架扫描二维码的功能，使用原生有一个缺陷就是无法扫描图片中的条形码。如要实现这个功能可以使用 `ZXingObjC` 框架。
[完整项目地址，第十个](https://github.com/fengzhihao123/FZHKit)


### 参考链接
* [iOS 二维码扫描](http://ios.jobbole.com/85226/)
* [iOS解码二维码图片](http://www.jianshu.com/p/bfa9e4e24a1a)
* [iOS 原生二维码扫描（可限制扫描区域）](http://blog.csdn.net/lc_obj/article/details/41549469)
* [iOS7使用原生API进行二维码和条形码的扫描](https://my.oschina.net/u/2340880/blog/405847)
* [ios8原生库实现扫描相册内二维码图片](http://blog.csdn.net/danchundep/article/details/47444371)
* [iOS调用闪光灯的代码](http://www.mobile-open.com/2016/944323.html)
* [iOS开发中在加载页面添加菊花动画（非第三方](http://blog.csdn.net/github_32300233/article/details/49426661)
* [ 苹果开发 笔记（48） UIImage CIImage CGImageRef](http://blog.csdn.net/hero82748274/article/details/46839265)
* [iOS 原生扫 QR 码的那些事](http://c0ming.me/qr-code-scan/)
* [CGContextRef使用简要教程](http://www.superqq.com/blog/2015/06/29/cgcontextrefshi-yong-jian-yao-jiao-cheng/)