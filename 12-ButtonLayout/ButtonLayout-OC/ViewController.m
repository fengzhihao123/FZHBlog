//
//  ViewController.m
//  ButtonLayout-OC
//
//  Created by 冯志浩 on 2017/6/20.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "ViewController.h"
#import "FZHButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButton];
}

- (void)setupButton {
    FZHButton *button = [[FZHButton alloc]initButtonWithButtonFrame:CGRectMake(100, 100, 100, 100) labelFrame:CGRectMake(0, 0, 100, 50) imageViewFrame:CGRectMake(0, 50, 100, 50)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"fzh" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    button.customImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:button];
}

@end
