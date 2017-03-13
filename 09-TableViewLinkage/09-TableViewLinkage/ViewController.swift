//
//  ViewController.swift
//  09-TableViewLinkage
//
//  Created by 冯志浩 on 2017/3/13.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let leftTableView = UITableView()
    let rightTableView = UITableView()
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        leftTableView.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.3, height: screenHeight)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        view.addSubview(leftTableView)
        
        rightTableView.frame = CGRect(x: screenWidth * 0.3, y: 0, width: screenWidth * 0.7, height: screenHeight)
        rightTableView.delegate = self
        rightTableView.dataSource = self
        view.addSubview(rightTableView)
    }

    //MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return 1
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "left")
        if tableView == leftTableView {
            cell.textLabel?.text = String(format: "section: %ld", indexPath.row)
        }else {
            cell.textLabel?.text = String(format: "section:%ld row:%ld", indexPath.row,indexPath.section)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            let rightIndexPath = IndexPath(row: 0, section: indexPath.row)
            rightTableView.selectRow(at: rightIndexPath, animated: true, scrollPosition: .top)
            rightTableView.deselectRow(at: rightIndexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == rightTableView {
            return String(format: "section: %ld", section)
        }
        return nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != leftTableView {
            let topHeaderIndexPath = rightTableView.indexPathsForVisibleRows?.first
            let leftIndexPath = IndexPath(row: (topHeaderIndexPath?.section)!, section: 0)
            leftTableView.selectRow(at: leftIndexPath, animated: true, scrollPosition: .middle)
        }
    }
}

