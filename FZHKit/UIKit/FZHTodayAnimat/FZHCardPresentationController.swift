//
//  FZHCardPresentationController.swift
//  FZHKit
//
//  Created by fzh on 2019/8/26.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHCardPresentationController: UIPresentationController {
    private lazy var blurView = UIVisualEffectView(effect: nil)
    
    // Default is false.
    // And also means you can access only `.to` when present, and `.from` when dismiss (e.g., can touch only 'presented view').
    //
    // If true, the presenting view is removed and you have to add it during animation accessing `.from` key.
    // And you will have access to both `.to` and `.from` view. (In the typical .fullScreen mode)

    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        blurView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(blurView)
        edges(to: container)
        blurView.alpha = 0.0
        
        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.effect = UIBlurEffect(style: .light)
                self.blurView.alpha = 1
            })
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            self.blurView.alpha = 0.0
        }, completion: nil)
    }
    
    
    
    func edges(to view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        NSLayoutConstraint.activate([
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            ])
    }
}
