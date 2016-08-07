//
//  ViewController.swift
//  01-FZHDrawerView(swift)
//
//  Created by 冯志浩 on 16/8/5.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var isSelect = false
    let leftView = LeftView()
    let mainView = MainView()
    let transformLength: CGFloat = 200
    
    let tableView = UITableView()
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupTableView()
        setupNavigationItem()
    }
    
    func setupSubViews() -> Void {
        self.title = "Main"
        leftView.frame = CGRect(x: 0, y: 0, width: transformLength, height: SCREEN_HEIGHT)
        view.addSubview(leftView)
        
        mainView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        mainView.backgroundColor = UIColor.whiteColor()
        view.addSubview(mainView)
        
    }
    
    func setupNavigationItem() -> Void {
        let leftBarButtonItem = UIBarButtonItem.init(title: "left", style: .Done, target: self, action: #selector(barButtonItemDidTouch))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func barButtonItemDidTouch() -> Void {
        if self.isSelect == false {
            UIView.animateWithDuration(0.5) {
                self.navigationController?.navigationBar.transform = CGAffineTransformMakeTranslation(self.transformLength, 0)
                self.tabBarController?.tabBar.transform = CGAffineTransformMakeTranslation(self.transformLength, 0)
                self.mainView.transform = CGAffineTransformMakeTranslation(self.transformLength, 0)
            }
            self.isSelect = true
        }else{
            UIView.animateWithDuration(0.5) {
                self.navigationController?.navigationBar.transform = CGAffineTransformIdentity
                self.tabBarController?.tabBar.transform = CGAffineTransformIdentity
                self.mainView.transform = CGAffineTransformIdentity
            }
            self.isSelect = false
        }
       
    }
    
    func setupTableView() -> Void {
        tableView.frame = CGRect(x: 0, y: 0, width: 200, height: SCREEN_HEIGHT)
        tableView.backgroundColor = UIColor.grayColor()
        tableView.delegate = self
        tableView.dataSource = self
        leftView.addSubview(tableView)
    }
//    MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = "Sub"
        return cell
    }
//    MARK:UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        UIView.animateWithDuration(0.5, animations: { 
            self.navigationController?.navigationBar.transform = CGAffineTransformIdentity
            self.tabBarController?.tabBar.transform = CGAffineTransformIdentity
            self.mainView.transform = CGAffineTransformIdentity
            }) { (true) in
                let subVC = SubViewController()
                self.navigationController?.pushViewController(subVC, animated: false)
                self.isSelect = false
        }
    }
}

