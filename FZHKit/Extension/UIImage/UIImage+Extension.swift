//
//  UIImage+Extension.swift
//  FZHKit
//
//  Created by fzh on 2019/6/25.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    // 获取网络图片的宽高
    // - urlStr：网络图片的URL
    // - 返回值： imageSize
    static func getImageHeight(urlStr: String) -> CGSize {
        var imageSize = CGSize.zero
        
        guard let url = URL(string: urlStr) else { return imageSize }
        let cfURL = url as CFURL
        guard let source = CGImageSourceCreateWithURL(cfURL, nil) else { return imageSize }
        let imageHeader = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
        
        guard let dict = imageHeader as? Dictionary<String, Any> else { return imageSize }
        if let height = dict["PixelHeight"] as? CGFloat {
            imageSize.height = height
        }
        
        if let width = dict["PixelWidth"] as? CGFloat {
            imageSize.width = width
        }
        return imageSize
    }
}
