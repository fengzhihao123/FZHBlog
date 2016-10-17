//
//  ViewController.swift
//  02-FZHDeleteCells(Swift)
//
//  Created by 冯志浩 on 16/8/8.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let tableView = UITableView()
    var dataSource: NSMutableArray = ["1","2","3","4","5","6","7","8"]
    var deleteArr: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() -> Void {
        let editButton = UIBarButtonItem.init(title: "编辑", style: .done, target: self, action: #selector(buttonDidTouch))
        let doneButton = UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(buttonDidTouch))
        let deleteButton = UIBarButtonItem.init(title: "删除", style: .done, target: self, action: #selector(buttonDidTouch))
        let selectAllButton = UIBarButtonItem.init(title: "全选", style: .done, target: self, action: #selector(buttonDidTouch))
        
        editButton.tag = 1001
        doneButton.tag = 1002
        deleteButton.tag = 1003
        
        self.navigationItem.leftBarButtonItems = [editButton,doneButton,deleteButton,selectAllButton]
    }
    
    func buttonDidTouch(_ btn:UIButton) -> Void {
        if btn.tag == 1001 {//编辑
            tableView.isEditing = true
            tableView.allowsMultipleSelectionDuringEditing = true
        }else if btn.tag == 1002{//完成
            tableView.isEditing = false
        }else if btn.tag == 1003{//删除
            self.dataSource.removeObjects(in: self.deleteArr as [AnyObject])
            tableView.reloadData()
        }else{//全选
            if tableView.isEditing == false {//如果处于完成状态则直接返回
                return
            }
            for row in 0...self.dataSource.count {
                let indexPath = IndexPath.init(row: row, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            self.deleteArr.addObjects(from: self.dataSource as [AnyObject])
        }
    }
    
    func setupTableView() -> Void {
        tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
//    MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = self.dataSource[(indexPath as NSIndexPath).row] as? String
        return cell
        
    }
    
//MARK: UITableViewDelegate
//    设置编辑style
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue)!
    }
//    选中则添加到删除数组中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deleteArr.add(self.dataSource[(indexPath as NSIndexPath).row])
    }
//    取消选中在数组中删除
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.deleteArr.remove(self.dataSource[(indexPath as NSIndexPath).row])
    }
}

