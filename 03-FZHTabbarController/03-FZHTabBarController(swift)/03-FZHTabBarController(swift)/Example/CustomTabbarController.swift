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
        
        self.setupChildVC(firstVC, title: "first", imageName: "first", selectImageName: "first_select")
        self.setupChildVC(secondVC, title: "second", imageName: "", selectImageName: "")
        self.setupChildVC(thirdVC, title: "third", imageName: "", selectImageName: "")
        self.setupChildVC(fourVC, title: "four", imageName: "", selectImageName: "")
    }
    
}
