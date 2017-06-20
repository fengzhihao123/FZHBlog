//
//  FZHButton.h
//  12-ButtonLayout
//
//  Created by 冯志浩 on 2017/6/20.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZHButton : UIButton
@property (nonatomic, strong) UILabel *customLabel;
@property (nonatomic, strong) UIImageView *customImageView;

- (FZHButton *)initButtonWithButtonFrame:(CGRect)buttonFrame labelFrame:(CGRect)labelFrame imageViewFrame:(CGRect)imageViewFrame;
@end
