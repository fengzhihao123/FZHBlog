//
//  FZHPopView.swift
//  05-FZHPopView
//
//  Created by 冯志浩 on 16/10/18.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit
protocol FZHPopViewDelegate {
    func transfer(title: String) -> Void
}
class FZHPopView: UIView,UITableViewDelegate,UITableViewDataSource {
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    var tableView = UITableView()
    let dataArr = ["save","cancel"]
    var popViewDelegate: FZHPopViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    func setupTableView() -> Void {
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        tableView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(dataArr.count) * 50, width: SCREEN_WIDTH, height: CGFloat(dataArr.count) * 50)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
    }
    
    //MARK: table view data dource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
    
    //MARK: table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popViewDelegate?.transfer(title: dataArr[indexPath.row])
    }
    
    func showPopView() -> Void {
        UIView.animate(withDuration: 0.25) { 
            self.transform = CGAffineTransform.init(translationX: 0, y: -self.SCREEN_HEIGHT)
        }
    }
    
    func hidePopView() -> Void {
        UIView.animate(withDuration: 0.25) { 
            self.transform = .identity
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidePopView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
