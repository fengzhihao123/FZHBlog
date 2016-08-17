//
//  CustomTabbarController.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/12.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class CustomTabbarController: FZHTabbarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    func setupSubViews() -> Void {
        
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        let thirdVC = ThirdViewController()
        let fourVC = FourViewController()
        /**
         *  添加tabbar的主控制器
         *
         *  @param firstVC                                 子控制器
         *  @param "first"                                 标题
         *  @param "first"                                 普通状态的图片
         *  @param "first_select"                          选中状态的图片
         *  @param TabbarHideStyle.TabbarHideWithAnimation 当push到下一界面tabbar的隐藏方式
         */
        self.setupChildVC(firstVC, title: "first", imageName: "first", selectImageName: "first_select", isAnimation: TabbarHideStyle.TabbarHideWithNoAnimation)
        self.setupChildVC(secondVC, title: "second", imageName: "second", selectImageName: "second_select", isAnimation: TabbarHideStyle.TabbarHideWithNoAnimation)
        self.setupChildVC(thirdVC, title: "third", imageName: "third", selectImageName: "third_select", isAnimation: TabbarHideStyle.TabbarHideWithNoAnimation)
        self.setupChildVC(fourVC, title: "four", imageName: "four", selectImageName: "four_select", isAnimation: TabbarHideStyle.TabbarHideWithNoAnimation)
    }
    
}
