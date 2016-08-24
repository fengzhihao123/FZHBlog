//
//  FZHTabbarButton.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/15.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHTabbarButton: UIButton {
    
    let tabbarImageRatio = 0.65
    var item : UITabBarItem = UITabBarItem(){
        didSet{
            self.setTitle(self.item.title, forState: .Normal)
            self.setTitle(self.item.title, forState: .Selected)
            
            self.setImage(self.item.image, forState: .Normal)
            self.setImage(self.item.selectedImage, forState: .Selected)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        图片居中
        self.imageView?.contentMode = .Center
//        去掉高亮状态
        self.adjustsImageWhenHighlighted = false
//        文字居中
        self.titleLabel?.textAlignment = .Center
        self.titleLabel?.font = UIFont.systemFontOfSize(11)
//        title两种状态的颜色
        self.setTitleColor(UIColor.greenColor(), forState: .Selected)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

//    MARK: title
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * CGFloat(tabbarImageRatio)
        let titleH = contentRect.size.height - titleY
        let titleW = contentRect.size.width
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }
//    MARK: image
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let imageH = contentRect.size.height * CGFloat(tabbarImageRatio)
        let imageW = contentRect.size.width
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
