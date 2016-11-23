//
//  FZHEnlargeImageView.swift
//  07-EnlargeImage
//
//  Created by 冯志浩 on 2016/11/23.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHEnlargeImageView: UIImageView {

    let largeImageView = UIImageView()
    
    var largeFrame = CGRect()
    var originFrame = CGRect()
    let bgView = UIView()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originFrame = frame
        setupInitData()
    }
    
    func setupInitData() -> Void {
        self.largeFrame = CGRect(x: 100, y: 100, width: 200, height: 400)
        let tapGuester = UITapGestureRecognizer.init(target: self, action: #selector(enlargeImage))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGuester)
        
        bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgView.backgroundColor = UIColor.black
        bgView.addSubview(self)
        
        largeImageView.frame = originFrame
        largeImageView.isUserInteractionEnabled = true
        bgView.addSubview(largeImageView)
    }
    
    func enlargeImage() -> Void {
        let tapGuester = UITapGestureRecognizer.init(target: self, action: #selector(recoverImageView))
        self.largeImageView.addGestureRecognizer(tapGuester)
        largeImageView.image = self.image
        
        UIView.animate(withDuration: 0.5, animations: {
            self.window?.addSubview(self.bgView)
            self.largeImageView.frame = self.largeFrame
        })
    }
    
    func recoverImageView() -> Void {
        UIView.animate(withDuration: 0.5, animations: {
            self.largeImageView.frame = self.originFrame
        }, completion: {(true) in
            self.bgView.removeFromSuperview()
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
