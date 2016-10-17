//
//  FZHTabBar.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/15.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit
protocol FZHTabBarDelegate {
    func tabbar(_ tabbar: FZHTabBar,formWhichItem: Int, toWhichItem: Int)
}
class FZHTabBar: UIView {
    var tabBarButtons: NSMutableArray = []
    var selectedButton = FZHTabbarButton()
    
    var fzhTabbarDelegate: FZHTabBarDelegate! = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTabbarButtonWith(_ item: UITabBarItem) -> Void {
        let button = FZHTabbarButton()
        button.item = item
        self.tabBarButtons.add(button)
        button.addTarget(self, action: #selector(buttonDidTouch), for: .touchDown)
       self.addSubview(button)
        //        默认选中
        if self.tabBarButtons.count == 1 {
            self.buttonDidTouch((self.tabBarButtons[0] as? FZHTabbarButton)!)
        }
    }
    
    func buttonDidTouch(_ button: FZHTabbarButton) -> Void {
        fzhTabbarDelegate.tabbar(self, formWhichItem: self.selectedButton.tag, toWhichItem: button.tag)
//        控制器选中按钮
        self.selectedButton.isSelected = false
        button.isSelected = true
        self.selectedButton = button
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
             self.addSubview(button)
//            3.绑定tag
            button.tag = index
        }
        
    }
    
}
