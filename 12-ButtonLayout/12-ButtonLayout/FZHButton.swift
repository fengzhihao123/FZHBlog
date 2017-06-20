//
//  FZHButton.swift
//  12-ButtonLayout
//
//  Created by 冯志浩 on 2017/6/20.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

import UIKit

class FZHButton: UIButton {
    let customLabel = UILabel()
    let customImageView = UIImageView()
    
    init(buttonFrame: CGRect, labelFrame: CGRect, imageViewFrame: CGRect) {
        super.init(frame: buttonFrame)
        //Label
        customLabel.frame = labelFrame
        customLabel.textAlignment = .center
        
        //image
        customImageView.frame = imageViewFrame
        
        addSubview(customLabel)
        addSubview(customImageView)
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        customLabel.text = title
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        customLabel.textColor = color
    }
    
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        customImageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
