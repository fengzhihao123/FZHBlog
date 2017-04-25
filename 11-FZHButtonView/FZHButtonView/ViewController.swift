//
//  ViewController.swift
//  FZHButtonView
//
//  Created by 冯志浩 on 2017/4/25.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FZHButtonViewDelegate {

    var titleArray = ["1", "2", "3", "4", "5", "6", "7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonView = FZHButtonView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 400))
        buttonView.backgroundColor = UIColor.gray
        buttonView.buttonTitleArray = titleArray
        buttonView.buttonCols = 3
        buttonView.buttonWH = 80
        buttonView.delegate = self
        buttonView.setupButton()
        view.addSubview(buttonView)
    }
    // FZHButtonViewDelegate
    func buttonDidTouch(button: UIButton) {
        let title = String(format: "select: %d", button.tag)
        let alert = UIAlertController(title: title, message: "Selected", preferredStyle: .alert)
        let action = UIAlertAction(title: "yes", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

