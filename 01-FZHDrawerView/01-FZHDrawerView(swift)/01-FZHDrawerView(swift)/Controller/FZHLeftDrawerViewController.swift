//
//  FZHLeftDrawerViewController.swift
//  01-FZHDrawerView(swift)
//
//  Created by 冯志浩 on 16/8/17.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHLeftDrawerViewController: UIViewController {

    var leftVC = UIViewController()
    var mainVC = UIViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func initSubVC(leftVC: UIViewController,mainVC: UIViewController) -> Void {
        self.leftVC = leftVC
        self.mainVC = mainVC
        
        self.leftVC.view.hidden = true
        self.view.addSubview(self.leftVC.view)
        
        for obj in self.leftVC.view.subviews {
            if obj.isKindOfClass(UITableView) {
                
            }
        }
        /*
         //获取左侧tableview
         for (UIView *obj in self.leftVC.view.subviews) {
         if ([obj isKindOfClass:[UITableView class]]) {
         self.leftTableview = (UITableView *)obj;
         }
         }
         self.leftTableview.backgroundColor = [UIColor clearColor];
         self.leftTableview.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
         //设置左侧tableview的初始位置和缩放系数
         self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
         self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
         
         [self.view addSubview:self.mainVC.view];
         */
        
    }

}
