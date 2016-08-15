//
//  FZHTabbarButton.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/15.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHTabbarButton: UIButton {

    var item: UITabBarItem{
        set{
            item.addObserver(self, forKeyPath:"1title", options: .New, context: nil)
            item.addObserver(self, forKeyPath: "image", options: .New, context: nil)
            item.addObserver(self, forKeyPath: "selectedImage", options: .New, context: nil)
            self.addObserver(self, forKeyPath: "", options: .New, context: nil)
        }
        get{
            return UITabBarItem.init()
        }
    }
    
    let tabbarImageRatio = 0.65
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        1.图片居中
        self.imageView?.contentMode = .Center
//        2.文字居中
        self.titleLabel?.textAlignment = .Center
        self.titleLabel?.font = UIFont.systemFontOfSize(11)
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
    deinit{
        self.item.removeObserver(self, forKeyPath: "1title")
        self.item.removeObserver(self, forKeyPath: "image")
        self.item.removeObserver(self, forKeyPath: "selectedImage")
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.setTitle(self.item.title, forState: .Selected)
        self.setTitle(self.item.title, forState: .Normal)
        
        self.setImage(self.item.image, forState: .Normal)
        self.setImage(self.item.selectedImage, forState: .Selected)
    }

}
