//
//  FZHTableViewController.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/12.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHTabbarViewController: UITabBarController,FZHTabBarDelegate {

   weak var customTabBar = FZHTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
//        self.tabBar.tintColor = UIColor.blackColor()
    }
//    delete origin tabbar
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for child in self.tabBar.subviews {
            if child.isKindOfClass(UIControl) {
                child.removeFromSuperview()
            }
        }
    }
    
    func setupTabbar() -> Void {
        let customTabBar = FZHTabBar.init(frame: self.tabBar.bounds)
        customTabBar.fzhTabbarDelegate = self
        self.tabBar.addSubview(customTabBar)
        self.customTabBar = customTabBar
    }
    
    //    MARK:FZHTabBarDelegate
    func tabbar(tabbar: FZHTabBar, formWhichItem: Int, toWhichItem: Int) {
        self.selectedIndex = toWhichItem
    }
    
    func setupChildVC(childVC: UIViewController,title: String,imageName: String,selectImageName: String){
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
//        不在渲染图片
        childVC.tabBarItem.selectedImage = UIImage.init(named: selectImageName)?.imageWithRenderingMode(.AlwaysOriginal)
        let navigationCtrl = FZHNavigationController.init(rootViewController: childVC)
        self.addChildViewController(navigationCtrl)
//        添加tabbar内部按钮
        self.customTabBar!.addTabbarButtonWith(childVC.tabBarItem)
    }
}
