//
//  FZHHomeAnimatViewController.swift
//  FZHKit
//
//  Created by fzh on 2019/8/26.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

struct FZHStatusBarAnimatableConfig {
    let prefersHidden: Bool
    let animation: UIStatusBarAnimation
    /// status bar 的动画持续时间，默认为 nil ，使用的是 transitionDuration
    let animationDuration: TimeInterval?
    /// status bar 动画在交互阶段结束后开始
    let animatesAfterInteractivityEnds: Bool
}



extension FZHStatusBarAnimatableConfig {
    init(prefersHidden: Bool, animation: UIStatusBarAnimation) {
        self.init(prefersHidden: prefersHidden,
                  animation: animation,
                  animationDuration: nil,
                  animatesAfterInteractivityEnds: true)
    }
}



class FZHStatusBarAnimatableViewController: UIViewController {
    private var shouldCurrentlyHideStatusBar = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let coordinator = transitionCoordinator else { return }
        let config = statusBarAnimatableConfig
        let onlyAfterNonInteractive = config.animatesAfterInteractivityEnds
        
        // IMPORTANT:
        // If you return `interactionControllerFor_`,
        // Even if it does nothing, coordinator.initiallyInteractive will be `true`,
        // BUT this block registered below won't get called at all!
        if onlyAfterNonInteractive && coordinator.initiallyInteractive {
            coordinator.notifyWhenInteractionChanges { [weak self](ctx) in
                if ctx.isCancelled { return }
                self?.shouldCurrentlyHideStatusBar = config.prefersHidden
                UIView.animate(withDuration: config.animationDuration ?? ctx.transitionDuration, animations: {
                    self?.setNeedsStatusBarAppearanceUpdate()
                })
            }
        } else {
            coordinator.animate(alongsideTransition: { [weak self](ctx) in
                self?.shouldCurrentlyHideStatusBar = config.prefersHidden
                UIView.animate(withDuration: config.animationDuration ?? ctx.transitionDuration, animations: {
                    self?.setNeedsStatusBarAppearanceUpdate()
                })
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        shouldCurrentlyHideStatusBar = UIApplication.shared.isStatusBarHidden
    }
    
    final override var prefersStatusBarHidden: Bool {
        return shouldCurrentlyHideStatusBar
    }
    
    final override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarAnimatableConfig.animation
    }
    
    var statusBarAnimatableConfig: FZHStatusBarAnimatableConfig {
        return FZHStatusBarAnimatableConfig(prefersHidden: false,
                                            animation: .none)
    }
}
