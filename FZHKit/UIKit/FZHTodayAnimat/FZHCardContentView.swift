//
//  FZHCardContentView.swift
//  FZHKit
//
//  Created by fzh on 2019/8/28.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHCardContentView: UIView {
    
    var viewModel: CardContentViewModel? {
        didSet {
            primaryLabel.text = viewModel?.primary
            detailLabel.text = viewModel?.description
            imageView.image = viewModel?.image
        }
    }
    
    let primaryLabel = UILabel(frame: .zero)
    let detailLabel = UILabel(frame: .zero)
    let imageView = UIImageView(frame: .zero)
    let primaryFont = UIFont.systemFont(ofSize: 20)
    let detailFont = UIFont.systemFont(ofSize: 16)
    var primaryTopAnchor = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        primaryLabel.font = primaryFont
        detailLabel.font = detailFont
        addSubview(imageView)
        addSubview(primaryLabel)
        addSubview(detailLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
            ])
        
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryTopAnchor = primaryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: FZHGlobalConstants.cardPrimaryTopAnchorConstant)
        NSLayoutConstraint.activate([
            primaryLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            primaryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            primaryLabel.heightAnchor.constraint(equalToConstant: 20),
            primaryTopAnchor
            ])
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.leftAnchor.constraint(equalTo: primaryLabel.leftAnchor, constant: 0),
            detailLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor, constant: 0),
            detailLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 5),
            detailLabel.heightAnchor.constraint(equalToConstant: 15)
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        // *Make the background image stays still at the center while we animationg,
        // else the image will get resized during animation.
        imageView.contentMode = .center
        setFontState(isHighlighted: false)
    }
    
    func setFontState(isHighlighted: Bool) {
        // This "connects" highlighted (pressedDown) font's sizes with the destination card's font sizes
        if isHighlighted {
            primaryLabel.font = UIFont.systemFont(ofSize: 20 * FZHGlobalConstants.cardHighlightedFactor, weight: .regular)
            detailLabel.font = UIFont.systemFont(ofSize: 16 * FZHGlobalConstants.cardHighlightedFactor, weight: .regular)
        } else {
            primaryLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
}
