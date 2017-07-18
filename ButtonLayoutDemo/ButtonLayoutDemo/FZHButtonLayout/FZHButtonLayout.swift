//
//  FZHButtonLayout.swift
//  ButtonLayoutDemo
//
//  Created by 冯志浩 on 2017/7/18.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

extension UIButton {
    enum FZHImagePosition {
        case left   //图片在左，文字在右，默认
        case right  //图片在右，文字在左
        case top    //图片在上，文字在下
        case bottom //图片在下，文字在上
    }
    
    func setImagePosition(position: FZHImagePosition, spacing: CGFloat) {
        self.setTitle(self.currentTitle, for: .normal)
        self.setImage(self.currentImage, for: .normal)
        
        // MARK - ImageSize
        var imageW: CGFloat = 0
        if let width = imageView?.image?.size.width {
            imageW = width
        } else {
            assertionFailure("image can't be nil(图片不能为空)")
        }
        
        var imageH: CGFloat = 0
        if let height = imageView?.image?.size.height {
            imageH = height
        }
        
        // MARK - LabelSize
        assert(titleLabel != nil, "label be nil(文字不能为空)")
        
        var labelW: CGFloat = 0
        if let width = titleLabel?.frame.size.width {
            labelW = width
        }
        /*
         CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
         CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
         */
        
        var labelH: CGFloat = 0
        if let height = titleLabel?.frame.size.height {
            labelH = height
        }
        
        let imageOffsetX = (imageW + labelW)/2 - imageW/2
        let imageOffsetY = imageH/2 + spacing/2
        
        let labelOffsetX = (imageW + labelW/2) - (imageW + labelW)/2
        let labelOffsetY = labelH/2 + spacing/2
        
        let tempW = max(labelW, imageW)
        let changedW = labelW + imageW - tempW
        
        let tempH = max(labelH, imageH)
        let changedH = labelH + imageH + spacing - tempH
        
        switch position {
        case .left:
            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2)
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2)
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2)
        case .right:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelW + spacing/2, 0, -(labelW + spacing/2))
            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + spacing/2), 0, imageW + spacing/2)
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2)
        case .top:
            imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX)
            titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX)
            contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedW/2, changedH-imageOffsetY, -changedW/2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX)
            titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX)
            contentEdgeInsets = UIEdgeInsetsMake(changedH-imageOffsetY, -changedW/2, imageOffsetY, -changedW/2)
        }
        
    }
}
