//
//  FZHNavigationController.m
//  03-FZHTabbarController
//
//  Created by 冯志浩 on 16/8/16.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "FZHNavigationController.h"

@interface FZHNavigationController ()

@end

@implementation FZHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
