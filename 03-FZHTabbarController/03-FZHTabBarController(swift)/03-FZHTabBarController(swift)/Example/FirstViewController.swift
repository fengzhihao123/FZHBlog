//
//  FirstViewController.swift
//  03-FZHTabBarController(swift)
//
//  Created by 冯志浩 on 16/8/12.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FirstViewController: FZHRootBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let subVC = SubViewController()
        self.navigationController?.pushViewController(subVC, animated: true)
    }
    
}
