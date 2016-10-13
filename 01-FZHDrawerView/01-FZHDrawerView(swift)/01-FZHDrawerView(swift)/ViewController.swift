//
//  ViewController.swift
//  01-FZHDrawerView(swift)
//
//  Created by 冯志浩 on 16/10/13.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftItem()
        view.backgroundColor = UIColor.red
    }

    func setupLeftItem() -> Void {
        let leftItem = UIBarButtonItem.init(title: "left", style: .done, target: self, action: #selector(itemDidTouch))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    func itemDidTouch() -> Void {
        let temAppDelegate = UIApplication.shared.delegate as! AppDelegate
        if temAppDelegate.fzhDrawerVC.isShow {
            temAppDelegate.fzhDrawerVC.hideLeftView()
        }else{
            temAppDelegate.fzhDrawerVC.showLeftView()
        }
    }
}

