//
//  ViewController.swift
//  07-EnlargeImage
//
//  Created by 冯志浩 on 2016/11/23.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    func setupImageView() -> Void {
        let exampleImageView = FZHEnlargeImageView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        exampleImageView.largeFrame = CGRect(x: 0, y: 0, width: 300, height: 400)
        exampleImageView.image = UIImage.init(named: "dota2.jpg")
        view.addSubview(exampleImageView)
        exampleImageView.currentVC = self
    }

}

