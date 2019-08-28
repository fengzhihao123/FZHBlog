//
//  FZHAnimatExampleDetailViewController.swift
//  FZHKit
//
//  Created by fzh on 2019/8/28.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

class FZHAnimatExampleDetailViewController: FZHStatusBarAnimatableViewController {

    let cardContentView = FZHCardContentView(frame: .zero)
    var cardBottomToRootBottomConstraint = NSLayoutConstraint()
    var scrollView = UIScrollView(frame: .zero)
    var isFontStateHighlighted: Bool = true {
        didSet {
            cardContentView.setFontState(isHighlighted: isFontStateHighlighted)
        }
    }
    var cardViewModel: CardContentViewModel! {
        didSet {
            self.cardContentView.viewModel = cardViewModel
        }
    }
    
    var unhighlightedCardViewModel: CardContentViewModel!
    var draggingDownToDismiss = false
    var interactiveStartingPoint: CGPoint?
    var dismissalAnimator: UIViewPropertyAnimator?
    
    final class DismissalPanGesture: UIPanGestureRecognizer {}
    final class DismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer {}
    
    private lazy var dismissalPanGesture: DismissalPanGesture = {
        let pan = DismissalPanGesture()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    private lazy var dismissalScreenEdgePanGesture: DismissalScreenEdgePanGesture = {
        let pan = DismissalScreenEdgePanGesture()
        pan.edges = .left
        return pan
    }()
    
    override var statusBarAnimatableConfig: FZHStatusBarAnimatableConfig {
        return FZHStatusBarAnimatableConfig(prefersHidden: true,
                                            animation: .slide)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = .init(top: cardContentView.bounds.height, left: 0, bottom: 0, right: 0)
        if FZHGlobalConstants.isEnabledTopSafeAreaInsetsFixOnCardDetailViewController {
            self.additionalSafeAreaInsets = .init(top: max(-view.safeAreaInsets.top, 0), left: 0, bottom: 0, right: 0)
        }
    }
}

extension FZHAnimatExampleDetailViewController {
    func setupSubviews() {
        scrollView.backgroundColor = UIColor.white
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: 0, height: 3000)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        cardContentView.viewModel = cardViewModel
        cardContentView.setFontState(isHighlighted: isFontStateHighlighted)
        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self
        
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)
        
        scrollView.addSubview(cardContentView)
        
        cardContentView.translatesAutoresizingMaskIntoConstraints = false
        cardBottomToRootBottomConstraint = cardContentView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3)
        NSLayoutConstraint.activate([
            cardContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cardContentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            cardContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            cardContentView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.3)
            ])
        loadViewIfNeeded()
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
    }
    
    func didSuccessfullyDragDownToDismiss() {
        cardViewModel = unhighlightedCardViewModel
        dismiss(animated: true)
    }
    
    func userWillCancelDissmissalByDraggingToTop(velocityY: CGFloat) {}
    
    func didCancelDismissalTransition() {
        // Clean up
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
    }
}

extension FZHAnimatExampleDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if draggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0) {
            draggingDownToDismiss = true
            scrollView.contentOffset = .zero
        }
        
        scrollView.showsVerticalScrollIndicator = !draggingDownToDismiss
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Without this, when user drag down and lift the finger fast at the top, there'll be some scrolling going on.
        // This check prevents that.
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }
}

extension FZHAnimatExampleDetailViewController {
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss
        
        // Don't do anything when it's not in the drag down mode
        if canStartDragDownToDismissPan { return }
        
        let targetAnimatedView = gesture.view!
        let startingPoint: CGPoint
        
        if let p = interactiveStartingPoint {
            startingPoint = p
        } else {
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }
        
        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        let targetShrinkScale: CGFloat = 0.86
        let targetCornerRadius: CGFloat = FZHGlobalConstants.cardCornerRadius
        
        func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
            if let animator = dismissalAnimator {
                return animator
            } else {
                let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                    targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = targetCornerRadius
                })
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = progress
                return animator
            }
        }
        switch gesture.state {
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0
            
            dismissalAnimator!.fractionComplete = actualProgress
            
            if isDismissalSuccess {
                dismissalAnimator!.stopAnimation(false)
                dismissalAnimator!.addCompletion { [unowned self] (pos) in
                    switch pos {
                    case .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator!.finishAnimation(at: .end)
            }
            
        case .ended, .cancelled:
            if dismissalAnimator == nil {
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }
            // NOTE:
            // If user lift fingers -> ended
            // If gesture.isEnabled -> cancelled
            
            // Ended, Animate back to start
            dismissalAnimator!.pauseAnimation()
            dismissalAnimator!.isReversed = true
            
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            dismissalAnimator!.addCompletion { [unowned self] (pos) in
                self.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            dismissalAnimator!.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }
}

extension FZHAnimatExampleDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
