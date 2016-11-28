//
//  FZHADScrollView.swift
//  08-ADScrollView
//
//  Created by 冯志浩 on 2016/11/28.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHADScrollView: UIScrollView,UIScrollViewDelegate {
//《DOTA 2》是一款由Valve开发免费的多人在线战斗竞技类游戏（MOBA）。2011年Dota2开始在Windows平台上进行测试，它的前身是魔兽争霸三及扩展版本冰封王座中的一张自定义游戏地图。截至2013年6月，Dota2支持Windows系统、OS X系统及Linux系统。Dota2是steam平台上活跃人数最多的游戏之一，最高在线人数超过100万。
    let dataSource = ["《DOTA 2》是一款由Valve开发免费的多人在线战斗竞技类游戏（MOBA）","它的前身是魔兽争霸三及扩展版本冰封王座中的一张自定义游戏地图","Dota2是steam平台上活跃人数最多的游戏之一，最高在线人数超过100万。","《DOTA 2》是一款由Valve开发免费的多人在线战斗竞技类游戏（MOBA）"]
    var originFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var originSize = CGSize(width: 0, height: 0)
    var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originFrame = frame
        originSize = frame.size
        setupScrollView()
        setupData()
        setupTimer()
    }
    
    func setupScrollView() -> Void {
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        isScrollEnabled = false
        delegate = self
    }
    
    func setupTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollViewAutoScroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewAutoScroll() -> Void {
       
        if contentOffset.y == CGFloat(dataSource.count - 2) * originSize.height {
            UIView.animate(withDuration: 2.0, animations: {
                self.contentOffset.y += self.originSize.height
            }, completion: {(true) in
                self.contentOffset.y = 0
            })
        } else {
            UIView.animate(withDuration: 2.0, animations:{
                self.contentOffset.y += self.originSize.height
            })
        }
    }
    
    func setupData() -> Void {
        
        self.contentSize = CGSize(width: 0, height: CGFloat(dataSource.count) * originSize.height)
        
        for index in 0..<dataSource.count {
            let text = dataSource[index]
            let label = UILabel()
            label.text = text
            label.textColor = UIColor.blue
            label.frame = CGRect(x: 0, y: CGFloat(index) * originSize.height, width: originSize.width, height: originSize.height)
            self.addSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
