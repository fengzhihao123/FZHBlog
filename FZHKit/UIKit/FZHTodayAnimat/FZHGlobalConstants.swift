//
//  FZHGlobalConstants.swift
//  FZHKit
//
//  Created by fzh on 2019/8/28.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHGlobalConstants: NSObject {
    static let cardHighlightedFactor: CGFloat = 0.96
    static let statusBarAnimationDuration: TimeInterval = 0.4
    static let cardCornerRadius: CGFloat = 16
    static let dismissalAnimationDuration = 0.6
    
    static let cardVerticalExpandingStyle: FZHCardVerticalExpandingStyle = .fromTop
    
    
    /// Without this, there'll be weird offset (probably from scrollView) that obscures the card content view of the cardDetailView.
    static let isEnabledWeirdTopInsetsFix = true
    
    /// If true, will draw borders on animating views.
    static let isEnabledDebugAnimatingViews = false
    
    /// If true, this will add a 'reverse' additional top safe area insets to make the final top safe area insets zero.
    static let isEnabledTopSafeAreaInsetsFixOnCardDetailViewController = false
    
    /// If true, will always allow user to scroll while it's animated.
    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true
    
    static let isEnabledDebugShowTimeTouch = true
}

extension FZHGlobalConstants {
    enum FZHCardVerticalExpandingStyle {
        /// Expanding card pinning at the top of animatingContainerView
        case fromTop
        
        /// Expanding card pinning at the center of animatingContainerView
        case fromCenter
    }
}
