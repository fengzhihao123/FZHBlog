//
//  LeftViewController.swift
//  01-FZHDrawerView(swift)
//
//  Created by 冯志浩 on 16/10/13.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tableView = UITableView.init()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.frame = CGRect(x: 0, y: 0, width: 300, height: SCREEN_HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    //    MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "tableViewcell")
        cell.textLabel?.text = "left"
        return cell
    }
    //    MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let subVC = SubViewController()
        
        temAppDelegate.mainNavi.pushViewController(subVC, animated: false)
        temAppDelegate.fzhDrawerVC.hideLeftView()
    }

}
