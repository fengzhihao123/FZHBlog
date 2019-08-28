//
//  FZHAnimatCVCell.swift
//  FZHKit
//
//  Created by fzh on 2019/8/26.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHAnimatCVCell: UICollectionViewCell {
    static let identifier = "FZHAnimatCVCell"
    
    var disabledHighlightedAnimation = false
    let cardContentView = FZHCardContentView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        cardContentView.layer.cornerRadius = FZHGlobalConstants.cardCornerRadius
        cardContentView.layer.masksToBounds = true
        addSubview(cardContentView)
        
        cardContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardContentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1),
            cardContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            cardContentView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            cardContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
            ])
    }
    
    func resetTransform() {
        transform = .identity
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        if disabledHighlightedAnimation { return }
        let animationOptions: AnimationOptions = FZHGlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard ? [.allowUserInteraction] : []
        
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: FZHGlobalConstants.cardHighlightedFactor, y: FZHGlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
