//
//  ViewController.swift
//  12-ButtonLayout
//
//  Created by 冯志浩 on 2017/6/20.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonFrame = CGRect(x: 100, y: 100, width: 100, height: 100)
        let labelFrame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let imageFrame = CGRect(x: 0, y: 50, width: 100, height: 50)
        
        let button = FZHButton(buttonFrame: buttonFrame, labelFrame: labelFrame, imageViewFrame: imageFrame)
        button.setTitle("fzh-swift", for: .normal)
        button.setTitleColor(UIColor.brown, for: .normal)
        button.customImageView.backgroundColor = UIColor.cyan
        view.addSubview(button)
    }

}

