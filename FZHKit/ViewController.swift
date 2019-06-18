//
//  ViewController.swift
//  FZHKit
//
//  Created by fzh on 2019/6/10.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: FZHAutoScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = FZHAutoScrollView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 200), images: ["1", "2", "3", "4"], transition: .addFirstAndLast)
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
}

extension ViewController: FZHAutoScrollViewDelegate {
    func fzhScrollView(_ fzhScrollView: FZHAutoScrollView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

