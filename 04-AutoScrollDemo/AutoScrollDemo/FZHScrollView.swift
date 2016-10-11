//
//  FZHScrollView.swift
//  AutoScrollDemo
//
//  Created by 冯志浩 on 16/10/8.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHScrollView: UIView,UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let pageCtrl = UIPageControl()
    var fzhSuperView = UIView()
    var fzhFrame = CGRect()
    var timer = Timer.init()
    var pageNum = 1
    var fzhPicArray:NSMutableArray = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fzhFrame = frame
    }
    func initScrollView(picArray: NSArray,superView: UIView) -> Void {
       //1.
        let endIndex = picArray.count - 1
        fzhPicArray = NSMutableArray.init(array: picArray)
        fzhPicArray.insert(picArray[endIndex], at: 0)
        fzhPicArray.add(picArray[0])
        
        //2.
        scrollView.frame = fzhFrame
        let scrollH = fzhFrame.size.height
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * CGFloat(fzhPicArray.count), height: scrollH)
        scrollView.contentOffset.x = SCREEN_WIDTH
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        
        fzhSuperView = superView
        //3.
        for index in 0..<fzhPicArray.count {
            _ = UIImageView().then {
                $0.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: scrollH)
                let imageName = String.init(format: "%@.jpg", fzhPicArray[index] as! String)
                $0.image = UIImage.init(named: imageName)
                scrollView.addSubview($0)
            }
        }
        self.addSubview(scrollView)
        setupPageCtrl()
        fzhSuperView.addSubview(self)
        
        if picArray.count > 1 {
            setupTimers()
        }
    }
   
    func setupTimers() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scrollViewAutoScroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewAutoScroll() -> Void {
        if pageNum != fzhPicArray.count - 1 {
            pageNum = pageNum + 1
            pageCtrl.currentPage = pageNum - 1
        }
        setScrollViewPageImage(pageNum: pageNum)
    }
    
    func setScrollViewPageImage(pageNum: Int) -> Void {
        if pageNum == fzhPicArray.count - 1 {
            UIView.animate(withDuration: 1, animations: { 
                self.scrollView.contentOffset.x = CGFloat(pageNum) * self.SCREEN_WIDTH
                }, completion: { (true) in
                    self.pageNum = 1
                    self.scrollView.contentOffset.x = self.SCREEN_WIDTH
                    self.pageCtrl.currentPage = 0
            })
        }else{
            UIView.animate(withDuration: 1) {
                self.scrollView.contentOffset.x = CGFloat(pageNum) * self.SCREEN_WIDTH
            }
        }
    }
    
    func setupPageCtrl() -> Void {
        pageCtrl.frame = CGRect(x: 0, y: self.frame.size.height * 0.5, width: SCREEN_WIDTH, height: 30)
        pageCtrl.currentPage = 0
        pageCtrl.numberOfPages = fzhPicArray.count - 2
        pageCtrl.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(pageCtrl)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delay(3) {
           self.setupTimers()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func delay(_ timeInterval: TimeInterval, _ block: @escaping ()->Void) {
        let after = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: after, execute: block)
    }
    
}
