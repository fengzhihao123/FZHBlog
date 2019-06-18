//
//  FZHAutoScrollView.swift
//  FZHKit
//
//  Created by fzh on 2019/6/13.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//


/* 未完成功能
 - 滑动平滑的动画效果
 - 自动轮滑的自定义动画
 
 */

import UIKit

protocol FZHAutoScrollViewDelegate {
    func fzhScrollView(_ fzhScrollView: FZHAutoScrollView, didSelectItemAt indexPath: IndexPath)
}

class FZHAutoScrollView: UIView {
    
    enum TransitionType {
        // 头添加最后一张，尾添加最后一张
        case addFirstAndLast
        // 直接回到头部
        case directToFirst
    }

    var collectionView: UICollectionView!
    var originImages = [String]()
    var localTestImages = [UIImage?]()
    
    var transition = TransitionType.directToFirst
    var endPoint: CGFloat!
    var timer: DispatchSourceTimer?
    var delegate: FZHAutoScrollViewDelegate?
    
    
    
    init(frame: CGRect, images: [String], transition: TransitionType) {
        super.init(frame: frame)
        
        self.transition = transition
        
        switch transition {
        case .addFirstAndLast:
            
            if let first = images.first, let last = images.last, images.count > 1 {
                originImages = [last] + images + [first]
            }
        case .directToFirst:
            originImages = images
        }
        
        localTestImages = setupImageData(strs: originImages)
        setupCollectionView()
        autoScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FZHAutoScrollView {
    
    private func startTimer(eventHandler: (() -> Void)?) {
        let queue = DispatchQueue.main
        
        timer?.cancel()        // cancel previous timer if any
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.schedule(deadline: .now() + 2, repeating: .seconds(2), leeway: .milliseconds(100))
        
        timer?.setEventHandler(handler: eventHandler)
        
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}


extension FZHAutoScrollView {
    func autoScrollView() {
        
        startTimer {
            switch self.transition {
            case .addFirstAndLast:
                self.addFirstAndLastAutoScroll()
            case .directToFirst:
                self.directToFirstAutoScroll()
            }
        }
    }
    
    func addFirstAndLastAutoScroll() {
        
        if collectionView.contentOffset.x == 0 {
            collectionView.scrollToItem(at: IndexPath(item: originImages.count - 2, section: 0), at: .right, animated: true)
        } else if collectionView.contentOffset.x == CGFloat(originImages.count - 1) * frame.width {
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
        } else {
            let index = collectionView.contentOffset.x / frame.width
            collectionView.scrollToItem(at: IndexPath(item: Int(index) + 1, section: 0), at: .right, animated: true)
        }
    }
    
    func directToFirstAutoScroll() {
        if collectionView.contentOffset.x == 0 {
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
        } else if collectionView.contentOffset.x == CGFloat(originImages.count - 1) * frame.width {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        } else {
            let index = collectionView.contentOffset.x / frame.width
            collectionView.scrollToItem(at: IndexPath(item: Int(index) + 1, section: 0), at: .right, animated: true)
        }
    }
}

extension FZHAutoScrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return originImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: FZHAutoScrollCVCell.identifier, for: indexPath)
        
        guard let cell = defaultCell as? FZHAutoScrollCVCell else { return defaultCell }
        
        cell.imageView.image = localTestImages[indexPath.row]
        cell.label.text = originImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.fzhScrollView(self, didSelectItemAt: indexPath)
    }
}


extension FZHAutoScrollView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        autoScrollView()
    }
}


extension FZHAutoScrollView {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        switch transition {
        case .addFirstAndLast:
            collectionView.contentOffset.x = frame.width
        case .directToFirst:
            collectionView.contentOffset.x = 0
        }
        
        collectionView.register(FZHAutoScrollCVCell.self, forCellWithReuseIdentifier: FZHAutoScrollCVCell.identifier)
        addSubview(collectionView)
    }
}

extension FZHAutoScrollView {
    func setupImageData(strs: [String]) -> [UIImage] {
        var images = [UIImage]()
        
        for str in strs {
            let letter = str as NSString
            let color = UIColor.blue
            
            let rect = CGRect(x: 0, y: 0, width: frame.width, height: 200)
            
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = 1
            
            let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
            let data = renderer.pngData { context in
                color.setFill()
                context.fill(rect)
                
                let attributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 200)
                ]
                
                let textSize = letter.size(withAttributes: attributes)
                let textRect = CGRect(
                    x: (rect.width - textSize.width) / 2,
                    y: (rect.height - textSize.height) / 2,
                    width: textSize.width,
                    height: textSize.height)
                letter.draw(in: textRect, withAttributes: attributes)
            }
            
            let image = UIImage(data: data)
            images.append(image!)
        }
        return images
    }
}
