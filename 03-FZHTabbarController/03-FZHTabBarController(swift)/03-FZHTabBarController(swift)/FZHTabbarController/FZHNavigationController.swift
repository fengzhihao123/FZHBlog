//
//  FZHNavigationController.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/12.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit
enum TabbarHideStyle {
//    有动画
    case TabbarHideWithAnimation
//    无动画
    case TabbarHideWithNoAnimation
}
class FZHNavigationController: UINavigationController {
    var tabbarHideStyle = TabbarHideStyle.TabbarHideWithNoAnimation
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let rootVC = self.viewControllers[0]
//            是否添加动画
            if tabbarHideStyle == TabbarHideStyle.TabbarHideWithAnimation {
                UIView.animateWithDuration(0.35, animations: {
                    rootVC.tabBarController?.tabBar.transform = CGAffineTransformMakeTranslation(0, 64)
                })
            }else{
                viewController.hidesBottomBarWhenPushed = true
            }
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
}
