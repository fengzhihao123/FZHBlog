//
//  ViewController.swift
//  08-ADScrollView
//
//  Created by 冯志浩 on 2016/11/28.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }

    func setupSubViews() -> Void {
        let adScrollView = FZHADScrollView.init(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: 50))
        adScrollView.backgroundColor = UIColor.brown
        view.addSubview(adScrollView)
    }

}

