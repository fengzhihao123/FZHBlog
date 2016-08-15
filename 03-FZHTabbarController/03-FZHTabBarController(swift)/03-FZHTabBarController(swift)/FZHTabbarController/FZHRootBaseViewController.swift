//
//  FZHRootBaseViewController.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/12.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHRootBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIView.animateWithDuration(0.35) {
            self.tabBarController?.tabBar.transform = CGAffineTransformIdentity
        }
    }

}
