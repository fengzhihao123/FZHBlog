//
//  ViewController.swift
//  02-FZHDeleteCells(Swift)
//
//  Created by 冯志浩 on 16/8/8.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let tableView = UITableView()
    var dataSource: NSMutableArray = ["1","2","3","4","5","6","7","8"]
    var deleteArr: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() -> Void {
        let editButton = UIBarButtonItem.init(title: "编辑", style: .Done, target: self, action: #selector(buttonDidTouch))
        let doneButton = UIBarButtonItem.init(title: "完成", style: .Done, target: self, action: #selector(buttonDidTouch))
        let deleteButton = UIBarButtonItem.init(title: "删除", style: .Done, target: self, action: #selector(buttonDidTouch))
        let selectAllButton = UIBarButtonItem.init(title: "全选", style: .Done, target: self, action: #selector(buttonDidTouch))
        
        editButton.tag = 1001
        doneButton.tag = 1002
        deleteButton.tag = 1003
        
        self.navigationItem.leftBarButtonItems = [editButton,doneButton,deleteButton,selectAllButton]
    }
    
    func buttonDidTouch(btn:UIButton) -> Void {
        if btn.tag == 1001 {//编辑
            tableView.editing = true
            tableView.allowsMultipleSelectionDuringEditing = true
        }else if btn.tag == 1002{//完成
            tableView.editing = false
        }else if btn.tag == 1003{//删除
            self.dataSource.removeObjectsInArray(self.deleteArr as [AnyObject])
            tableView.reloadData()
        }else{//全选
            if tableView.editing == false {//如果处于完成状态则直接返回
                return
            }
            for row in 0...self.dataSource.count {
                let indexPath = NSIndexPath.init(forRow: row, inSection: 0)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
            self.deleteArr.addObjectsFromArray(self.dataSource as [AnyObject])
        }
    }
    
    func setupTableView() -> Void {
        tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
//    MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = self.dataSource[indexPath.row] as? String
        return cell
        
    }
    
//MARK: UITableViewDelegate
//    设置编辑style
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.Delete.rawValue | UITableViewCellEditingStyle.Insert.rawValue)!
    }
//    选中则添加到删除数组中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.deleteArr.addObject(self.dataSource[indexPath.row])
    }
//    取消选中在数组中删除
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.deleteArr.removeObject(self.dataSource[indexPath.row])
    }
}

