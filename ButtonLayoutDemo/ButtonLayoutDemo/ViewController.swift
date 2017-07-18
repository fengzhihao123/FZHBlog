//
//  ViewController.swift
//  ButtonLayoutDemo
//
//  Created by 冯志浩 on 2017/7/18.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
//    这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
    func setupButton() {
        //left
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 90, height: 50))
        button.setTitle("collect", for: .normal)
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.setImagePosition(position: .right, spacing: 5)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.backgroundColor = UIColor.red
        view.addSubview(button)
    }
}

