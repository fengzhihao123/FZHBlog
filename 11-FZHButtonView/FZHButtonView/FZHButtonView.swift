//
//  FZHButtonView.swift
//  FZHButtonView
//
//  Created by 冯志浩 on 2017/4/25.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit
protocol FZHButtonViewDelegate {
    func buttonDidTouch(button: UIButton)
}

class FZHButtonView: UIView {
    var viewW: CGFloat = 0
    var viewH: CGFloat = 0
    var buttonWH: CGFloat = 0
    var buttonTitleArray = [String]()
    var buttonCols: CGFloat = 0
    
    var delegate: FZHButtonViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewW = frame.size.width
        viewH = frame.size.height
    }
    
    func setupButton() {
        var buttonRows: CGFloat = CGFloat(buttonTitleArray.count) / buttonCols
        
        if buttonTitleArray.count % Int(buttonCols) != 0 {
            buttonRows += 1
        }
        
        let marginX: CGFloat = (viewW - buttonCols * buttonWH) / (buttonCols + 1)
        let marginY: CGFloat = (viewH - buttonRows * buttonWH) / (buttonRows + 1)
        for row in 0..<Int(buttonRows) {
            if row != Int(buttonRows) - 1 {
                for col in 0..<Int(buttonCols) {
                    let button = UIButton()
                    button.frame = CGRect(x: CGFloat(col + 1) * marginX + CGFloat(col) * buttonWH, y: CGFloat(row + 1) * marginY + CGFloat(row) * buttonWH, width: buttonWH, height: buttonWH)
                    button.backgroundColor = UIColor.blue
                    button.tag = 1000 + row * Int(buttonCols) + col
                    button.setTitle(buttonTitleArray[row * Int(buttonCols) + col], for: .normal)
                    button.addTarget(self, action: #selector(buttonDidTouch(button:)), for: .touchUpInside)
                    addSubview(button)
                }
            } else {
                for col in 0..<Int(buttonTitleArray.count % Int(buttonCols)) {
                    let button = UIButton()
                    button.frame = CGRect(x: CGFloat(col + 1) * marginX + CGFloat(col) * buttonWH, y: CGFloat(row + 1) * marginY + CGFloat(row) * buttonWH, width: buttonWH, height: buttonWH)
                    button.backgroundColor = UIColor.blue
                    button.tag = 1000 + row * Int(buttonCols) + col
                    button.setTitle(buttonTitleArray[row * Int(buttonCols) + col], for: .normal)
                    button.addTarget(self, action: #selector(buttonDidTouch(button:)), for: .touchUpInside)
                    addSubview(button)
                }
            }
            
        }
    }
    
    func buttonDidTouch(button: UIButton) {
        if delegate != nil {
            delegate?.buttonDidTouch(button: button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
