//
//  FZHCardTransition.swift
//  FZHKit
//
//  Created by fzh on 2019/8/26.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

final class FZHCardTransition: NSObject {
    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: FZHAnimatCVCell
    }
    
    let params: Params
    init(params: Params) {
        self.params = params
        super.init()
    }
}

extension FZHCardTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = FZHPresentCardAnimator.Params.init(fromCardFrame: self.params.fromCardFrame,
                                                        fromCell: self.params.fromCell)
        return FZHPresentCardAnimator(params: params)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = FZHDismissCardAnimator.Params.init(fromCardFrame: self.params.fromCardFrame,
                                                        fromCardFrameWithoutTransform: self.params.fromCardFrameWithoutTransform,
                                                        fromCell: self.params.fromCell)
        return FZHDismissCardAnimator(params: params)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    // IMPORTANT: Must set modalPresentationStyle to `.custom` for this to be used.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FZHCardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
