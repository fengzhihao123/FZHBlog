//
//  FZHAnimatExampleViewController.swift
//  FZHKit
//
//  Created by fzh on 2019/8/26.
//  Copyright © 2019 fzh.test.com. All rights reserved.
//

import UIKit

struct CardContentViewModel {
    let primary: String
    let secondary: String
    let description: String
    let image: UIImage
    
    func highlightedImage() -> CardContentViewModel {
        let scaledImage = image.resize(toWidth: image.size.width * FZHGlobalConstants.cardHighlightedFactor)
        return CardContentViewModel(primary: primary,
                                    secondary: secondary,
                                    description: description,
                                    image: scaledImage)
    }
}

class FZHAnimatExampleViewController: FZHStatusBarAnimatableViewController {

    var cv: UICollectionView!
    private lazy var cvDataSource: [CardContentViewModel] = [
        CardContentViewModel(primary: "GAME OF THE DAY",
                             secondary: "Minecraft makes a splash",
                             description: "The ocean is a big place. Tap to read how Minecraft's just got even bigger.",
                             image: UIImage(named: "drowning.png")!.resize(toWidth: UIScreen.main.bounds.size.width * (1/FZHGlobalConstants.cardHighlightedFactor))),
        CardContentViewModel(primary: "You won't believe this guy",
                             secondary: "Something we want",
                             description: "They have something we want which is not something we need.",
                             image: UIImage(named: "img1.png")!.resize(toWidth: UIScreen.main.bounds.size.width * (1/FZHGlobalConstants.cardHighlightedFactor))),
        CardContentViewModel(primary: "LET'S PLAY",
                             secondary: "Cats, cats, cats!",
                             description: "Play these games right meow.",
                             image: UIImage(named: "img2.jpg")!.resize(toWidth: UIScreen.main.bounds.size.width * (1/FZHGlobalConstants.cardHighlightedFactor)))
    ]
    private var transition: FZHCardTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override var statusBarAnimatableConfig: FZHStatusBarAnimatableConfig {
        return FZHStatusBarAnimatableConfig(prefersHidden: false,
                                            animation: .slide)
    }
}

extension FZHAnimatExampleViewController {
    func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: (view.bounds.width - 32) * 1.2)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        
        cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.register(FZHAnimatCVCell.self, forCellWithReuseIdentifier: FZHAnimatCVCell.identifier)
        view.addSubview(cv)
    }
}

extension FZHAnimatExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FZHAnimatCVCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let animateCell = cell as? FZHAnimatCVCell else { return }
        animateCell.cardContentView.viewModel = cvDataSource[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defaultCell = collectionView.cellForItem(at: indexPath)
        guard let cell = defaultCell as? FZHAnimatCVCell else { return }
        // Freeze highlighted state (or else it will bounce back)
        cell.freezeAnimations()
        // Get current frame on screen
        let currentCellFrame = cell.layer.presentation()?.frame ?? .zero
        // Convert current frame to screen's coordinates
        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
        // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let vc = FZHAnimatExampleDetailViewController()
        vc.cardViewModel = cvDataSource[indexPath.row].highlightedImage()
        vc.unhighlightedCardViewModel = cvDataSource[indexPath.row]
        let params = FZHCardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                              fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                              fromCell: cell)

        
        transition = FZHCardTransition(params: params)
        vc.transitioningDelegate = transition
        // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.modalPresentationStyle = .custom
        
        present(vc, animated: true) { [weak cell] in
            cell?.unfreezeAnimations()
        }
    }
}

extension UIImage {
    /// Resize UIImage to new width keeping the image's aspect ratio.
    func resize(toWidth scaledToWidth: CGFloat) -> UIImage {
        let image = self
        let oldWidth = image.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = image.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        let scaledSize = CGSize(width:newWidth, height:newHeight)
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
