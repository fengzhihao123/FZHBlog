//
//  FZHDrawerController.swift
//  01-FZHDrawerView(swift)
//
//  Created by 冯志浩 on 16/10/13.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHDrawerController: UIViewController {
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let panGesture = UIPanGestureRecognizer.init()
    var leftVC = UIViewController()
    var mainVC = UIViewController()
    
    var isShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initSubVC(leftControl: UIViewController,mainControl: UIViewController) -> UIViewController {
        leftVC = leftControl
        mainVC = mainControl
        
        leftVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        mainVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        panGesture.addTarget(self, action: #selector(panGestureEvent))
        
        self.mainVC.view.addGestureRecognizer(self.panGesture)
        self.view.addSubview(leftVC.view)
        self.view.addSubview(mainVC.view)
        return self
    }
    
    func panGestureEvent(pan: UIPanGestureRecognizer) -> Void {
        
        let point = pan.translation(in: self.view)
        //        当手势移动时
        if pan.state == .changed {
            //        当主视图没移动时右滑不移动主视图，当主视图移动的时候，右滑复位主视图
            if (point.x > 0) || (self.mainVC.view.frame.origin.x > 0) {
                UIView.animate(withDuration: 0.37) {
                    self.mainVC.view.transform = CGAffineTransform(translationX: point.x, y: 0)
                }
            }
            //      当手势取消或者结束
        }else if (pan.state == .cancelled) || (pan.state == .ended){
            if point.x > 200 && isShow == false{
                showLeftView()
            }else{
                hideLeftView()
            }
        }
    }
    
    func showLeftView() -> Void {
        UIView.animate(withDuration: 0.37) {
            self.mainVC.view.transform = CGAffineTransform(translationX: 200, y: 0)
        }
        isShow = true
    }
    
    func hideLeftView() -> Void {
        UIView.animate(withDuration: 0.37) {
            self.mainVC.view.transform = .identity
        }
        isShow = false
    }

}
