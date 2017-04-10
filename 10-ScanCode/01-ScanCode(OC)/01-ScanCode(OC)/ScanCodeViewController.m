//
//  ScanCodeViewController.m
//  01-ScanCode(OC)
//
//  Created by 冯志浩 on 2017/4/10.
//  Copyright © 2017年 冯志浩. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"
#import "LoadView.h"
@interface ScanCodeViewController ()
<AVCaptureMetadataOutputObjectsDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *slideLineView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat viewWidth;
//flash
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ScanView *scan;

@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewWidth = 50.0;
    self.isOpen = NO;
    self.view.backgroundColor = [UIColor greenColor];
    //    设置loading界面
    [self setupBgView];
    //    设置扫面界面
    [self setupScanView];
    //    设置扫描线
    [self setupTimer];
    [self.view addSubview:_bgView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_session) {
        [self setupAVFoundation];
    }
}

- (void)setupBgView {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor = [UIColor blackColor];
    
    LoadView *loadView = [[LoadView alloc]init];
    [_bgView addSubview:loadView];
    // 动画开始
    [loadView startAnimating];
}

- (void)setupScanView {
    _scan = [[ScanView alloc]initWithFrame:self.view.bounds];
    _scan.backgroundColor = [UIColor clearColor];
    
    _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(_viewWidth, 201, ScreenWidth - _viewWidth * 2, 1)];
    _slideLineView.backgroundColor = [UIColor greenColor];
    [_scan addSubview:_slideLineView];
    [self.view addSubview:_scan];
    [self setupSubView];
}

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

- (void)lightButtonDidTouch {
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
}

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

@end
