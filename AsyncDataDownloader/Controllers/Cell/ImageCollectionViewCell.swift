//
//  ImageCollectionViewCell.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    
    private var downloader: Downloader?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downloader = Downloader()
        makeBorderView()
    }
    
    /// Make the cell with a border.
    private func makeBorderView() {
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    func updateData(model: DataModel) {
        imageViewItem.contentMode = .center
        downloadImage(url: model.images.small, placeHolder: UIImage(named: "placeholder"))
    }
}

extension ImageCollectionViewCell {
    /**
     Download the image with the given url and optional placeholder image.
     - Parameter url: The image url to download, String.
     - Parameter placeholder: The placeholder image, UIImage.
     */
    func downloadImage(url: String,
                       placeHolder: UIImage? = nil) {
        imageViewItem.image = placeHolder
        downloader?.downloadImage(url: url, completion: { (image: UIImage?) in
            self.showImageWithAnimation(image: image)
        })
    }
    
    /**
     Show image with animation
     - Parameter image: The optional image to set the imageview.
     */
    private func showImageWithAnimation(image: UIImage?) {
        UIView.animate(withDuration: TimeInterval(0.5),
                       delay: 0,
                       options: .transitionFlipFromTop,
                       animations: {
                        DispatchQueue.main.async {
                            self.imageViewItem.image = image
                        }
        },
                       completion: nil)
    }
}
