//
//  FZHButton.m
//  12-ButtonLayout
//
//  Created by 冯志浩 on 2017/6/20.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "FZHButton.h"

@implementation FZHButton

- (FZHButton *)initButtonWithButtonFrame:(CGRect)buttonFrame labelFrame:(CGRect)labelFrame imageViewFrame:(CGRect)imageViewFrame {
    if (self = [super initWithFrame:buttonFrame]) {
        //label
        _customLabel = [[UILabel alloc]initWithFrame:labelFrame];
        _customLabel.textAlignment = NSTextAlignmentCenter;
        
        //image
        _customImageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
        
        [self addSubview:_customLabel];
        [self addSubview:_customImageView];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    _customLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    _customLabel.textColor = color;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    _customImageView.image = image;
}
@end
