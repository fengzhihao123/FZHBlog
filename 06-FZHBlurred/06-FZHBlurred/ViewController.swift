//
//  ViewController.swift
//  06-FZHBlurred
//
//  Created by 冯志浩 on 16/11/2.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    func setupImageView() -> Void {
        let imageView = UIImageView.init()
        imageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        let blurrImage: UIImage = UIImage.boxBlurImage(image: UIImage.init(named: "example.png")!, withBlurNumber: 1)
        imageView.image = blurrImage
        view.addSubview(imageView)
    }
    
}

