//
//  FZHTabBar.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/15.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit
protocol FZHTabBarDelegate {
    func tabbar(tabbar: FZHTabBar,formWhichItem: Int, toWhichItem: Int)
}
class FZHTabBar: UIView {
    var tabBarButtons: NSMutableArray = []
    var tabbarButtonImageArray: NSMutableArray = []
    var tabbarButtonSelectedImageArray: NSMutableArray = []
    var tabbarButtonTitleArray: NSMutableArray = []
    
    var selectedButton = FZHTabbarButton()
    var tabbarButton = FZHTabbarButton()
    var lastTitle = ""
    var lastImage = UIImage.init()
    var lastSelectedImage = UIImage.init()
    
    var fzhTabbarDelegate: FZHTabBarDelegate! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
//            add plus
        self.tabbarButton.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        self.tabbarButton.addObserver(self, forKeyPath: "image", options: .New, context: nil)
        self.tabbarButton.addObserver(self, forKeyPath: "selectedImage", options: .New, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTabbarButtonWith(item: UITabBarItem) -> Void {
        var button = FZHTabbarButton()
        self.tabBarButtons.addObject(button)
        self.tabbarButton.title = item.title!
        self.tabbarButton.image = item.image!
        self.tabbarButton.selectedImage = item.selectedImage!
        button.addTarget(self, action: #selector(buttonDidTouch), forControlEvents: .TouchDown)
        button = self.tabbarButton
       self.addSubview(self.tabbarButton)
        
        //        默认选中
        if self.tabBarButtons.count == 1 {
            self.buttonDidTouch((self.tabBarButtons[0] as? FZHTabbarButton)!)
        }
    }
    
    func buttonDidTouch(button: FZHTabbarButton) -> Void {
        fzhTabbarDelegate.tabbar(self, formWhichItem: self.selectedButton.tag, toWhichItem: button.tag)
//        控制器选中按钮
        self.selectedButton.selected = false
        button.selected = true
        self.selectedButton = button
    }
    
    deinit{
        self.tabbarButton.removeObserver(self, forKeyPath: "title")
        self.tabbarButton.removeObserver(self, forKeyPath: "image")
        self.tabbarButton.removeObserver(self, forKeyPath: "selectedImage")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if self.tabbarButton.title != self.lastTitle {
            tabbarButtonTitleArray.addObject(self.tabbarButton.title)
            self.lastTitle = self.tabbarButton.title
        }
        if self.tabbarButton.image != self.lastImage {
            tabbarButtonImageArray.addObject(self.tabbarButton.image)
            self.lastImage = self.tabbarButton.image
        }
        if self.tabbarButton.selectedImage != self.lastSelectedImage {
            tabbarButtonSelectedImageArray.addObject(self.tabbarButton.selectedImage)
            self.lastSelectedImage = self.tabbarButton.selectedImage
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        button
        let buttonW = self.frame.size.width/CGFloat(self.tabBarButtons.count)
        let buttonH = self.frame.size.height
        let buttonY = 0
        
        for index in 0...self.tabBarButtons.count - 1 {
//            取出按钮
            let button: UIButton = self.tabBarButtons[index] as! UIButton
//            2.设置按钮的frame
            let buttonX = CGFloat(index) * buttonW
            button.frame = CGRect(x: buttonX, y: CGFloat(buttonY), width: buttonW, height: buttonH)
//            给button赋值
            button.setTitle(self.tabbarButtonTitleArray[index] as? String, forState: .Selected)
            button.setTitle(self.tabbarButtonTitleArray[index] as? String, forState: .Normal)
            button.setImage(self.tabbarButtonImageArray[index + 1] as? UIImage, forState: .Normal)
            button.setImage(self.tabbarButtonSelectedImageArray[index + 1] as?UIImage, forState: .Selected)
            button.addTarget(self, action: #selector(buttonDidTouch), forControlEvents: .TouchUpInside)
             self.addSubview(button)
//            3.绑定tag
            button.tag = index
        }
        
    }
    
}
