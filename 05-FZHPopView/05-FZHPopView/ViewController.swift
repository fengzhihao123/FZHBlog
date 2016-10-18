//
//  ViewController.swift
//  05-FZHPopView
//
//  Created by 冯志浩 on 16/10/18.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FZHPopViewDelegate {
    
    @IBOutlet weak var popViewBtn: UIButton!
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    var popView = FZHPopView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopView()
    }
    
    func setupPopView() -> Void {
        popView = FZHPopView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 300))
        popView.popViewDelegate = self
        view.addSubview(popView)
    }
    
    @IBAction func popViewBtnDidTouch(_ sender: AnyObject) {
        popView.showPopView()
    }
    
    //MARK: FZHPopViewDelegate
    func transfer(title: String) -> Void{
        popViewBtn.setTitle(title, for: .normal)
    }
    
}

