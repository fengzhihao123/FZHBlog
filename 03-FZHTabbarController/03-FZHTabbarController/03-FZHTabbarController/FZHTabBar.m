//
//  FZHTabBar.m
//  03-FZHTabbarController
//
//  Created by 冯志浩 on 16/8/16.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "FZHTabBar.h"
#import "FZHTabbarButton.h"
@implementation FZHTabBar
-(NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons== nil) {
        _tabBarButtons=[NSMutableArray array];
    }
    return _tabBarButtons;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
-(void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBardidPlusButton:)]) {
        [self.delegate tabBardidPlusButton:self];
    }
}
-(void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    //1.创建按钮
    FZHTabbarButton * button=[[FZHTabbarButton alloc]init];
    [self.tabBarButtons addObject:button];
    //2.设置数据
    button.item=item;
    
    //3.添加按钮
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    //4.默认选中
    if (self.tabBarButtons.count==1) {
        
        [self buttonClick:button];
    }
    
}
-(void)buttonClick:(FZHTabbarButton *)button
{
    //1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    //2.控制器选中按钮
    self.selectedButton.selected=NO;
    button.selected=YES;
    self.selectedButton=button;
}
//布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //1. 4个按钮
    CGFloat buttonW=self.frame.size.width/self.subviews.count;
    CGFloat buttonH=self.frame.size.height;
    CGFloat buttonY = 0;
    
    for (int index=0; index<self.tabBarButtons.count; index++) {
        
        //1.取出按钮
        FZHTabbarButton * button=self.tabBarButtons[index];
        //2.设置按钮的frame
        CGFloat buttonX=index * buttonW;
        button.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //3.绑定tag
        button.tag=index;
    }
}

@end
