//
//  UIImage+FZHBlurred.swift
//  06-FZHBlurred
//
//  Created by 冯志浩 on 16/11/2.
//  Copyright © 2016年 FZH. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
extension UIImage{
    
   class func boxBlurImage(image: UIImage, withBlurNumber blur: CGFloat) -> UIImage {
        var blur = blur
        if blur < 0.0 || blur > 1.0 {
            blur = 0.5
        }
        var boxSize = Int(blur * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = image.cgImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutableRawPointer
        
        // 从CGImage中获取数据
        let inProvider = img!.dataProvider
        let inBitmapData = inProvider!.data
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(img!.width)
        inBuffer.height = UInt(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        if pixelBuffer == nil {
            NSLog("No pixel buffer!")
        }
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img!.width)
        outBuffer.height = UInt(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            NSLog("error from convolution %ld", error)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        let imageRef = ctx!.makeImage()!
        let returnImage = UIImage(cgImage: imageRef)
        
        free(pixelBuffer)
        
        return returnImage
    }
    
}
