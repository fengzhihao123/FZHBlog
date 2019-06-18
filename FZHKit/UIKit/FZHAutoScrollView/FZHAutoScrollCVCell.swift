//
//  FZHAutoScrollCVCell.swift
//  FZHKit
//
//  Created by fzh on 2019/6/13.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHAutoScrollCVCell: UICollectionViewCell {
    
    static let identifier = "FZHAutoScrollCVCell"
    
    var imageView = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 50, y: 20, width: 50, height: 30))
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
