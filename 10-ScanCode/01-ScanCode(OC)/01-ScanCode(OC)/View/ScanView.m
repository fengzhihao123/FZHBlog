//
//  ScanView.m
//  01-ScanCode(OC)
//
//  Created by 冯志浩 on 2017/4/10.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "ScanView.h"

@implementation ScanView

- (void)drawRect:(CGRect)rect {
    CGFloat rectWidth = 50;
    CGFloat rectHeight = 200;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0.0, 0.0, 0.0, 0.8};
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


@end
