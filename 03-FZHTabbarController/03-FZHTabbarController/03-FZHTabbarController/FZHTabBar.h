//
//  FZHTabBar.h
//  03-FZHTabbarController
//
//  Created by 冯志浩 on 16/8/16.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZHTabBar;
@protocol FZHTabBarDelegate <NSObject>

@optional
- (void)tabBar:(FZHTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBardidPlusButton:(FZHTabBar *)tabBar;
@end

#import "FZHTabbarButton.h"
@interface FZHTabBar : UIView
@property (nonatomic,strong) NSMutableArray * tabBarButtons;
@property (weak, nonatomic) FZHTabbarButton *selectedButton;
-(void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property(nonatomic,weak)id<FZHTabBarDelegate>delegate;

@end
