//
//  FZHEnlargeImageView.swift
//  07-EnlargeImage
//
//  Created by 冯志浩 on 2016/11/23.
//  Copyright © 2016年 FZH. All rights reserved.
//

import UIKit

class FZHEnlargeImageView: UIImageView,FZHPopViewDelegate {

    let largeImageView = UIImageView()
    var largeFrame = CGRect()
    var originFrame = CGRect()
    let bgView = UIView()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    var currentVC = UIViewController()
    let popView = FZHPopView()
    
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
        
        popView.popViewDelegate = self
        popView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgView.addSubview(popView)
    }
    
    func enlargeImage() -> Void {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(recoverImageView))
        largeImageView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(showAlert))
        longPressGesture.minimumPressDuration = 1.0
        largeImageView.addGestureRecognizer(longPressGesture)
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
    
    func showAlert() -> Void {
        popView.showPopView()
    }
    
    func saveImageToAlbum() -> Void {
        if let image = self.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //MARK:
    func transfer(title: String) {
        popView.hidePopView()
        if title == "save" {
            saveImageToAlbum()
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        let hud = MBProgressHUD.showAdded(to: window!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "保存成功"
        if error != nil {
            hud.label.text = "保存失败"
            //延迟隐藏
            hud.hide(animated: true, afterDelay: 0.5)
            return
        }
        hud.hide(animated: true, afterDelay: 0.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
