//
//  ViewController.m
//  01-ScanCode(OC)
//
//  Created by 冯志浩 on 2017/4/10.
//  Copyright © 2017年 冯志浩. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "ViewController.h"
#import "ScanCodeViewController.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) ScanCodeViewController *scanVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _scanVC = [[ScanCodeViewController alloc]init];
    [self setupSubView];
}

- (void)setupSubView {
    _pushButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [_pushButton setTitle:@"pushNextVC" forState:UIControlStateNormal];
    _pushButton.backgroundColor = [UIColor blackColor];
    [_pushButton addTarget:self action:@selector(pushButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushButton];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280, ScreenWidth, 50)];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = @"text";
    [self.view addSubview:_textLabel];
}

- (void)pushButtonDidTouch {
    __weak typeof(self) weakSelf = self;
    _scanVC.resultBlock = ^(NSString *str){
        weakSelf.textLabel.text = str;
    };
    [self.navigationController pushViewController:_scanVC animated:YES];
}

@end
