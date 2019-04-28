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
    
    private var downloader: Downloader? = Downloader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeBorderView()
    }
    
    /// Make the cell with a border.
    private func makeBorderView() {
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    func updateData(model: DataModel) {
        print("requeting: \(model.images.small)")
        self.showIndicator()
        downloader?.downloadWith(urlString: model.images.small, completion: { [weak self] (data, error) in
            self?.hideIndicator()
            guard let self = self else { return }
            guard let imgData = data,
                error == nil else {
                    DispatchQueue.main.async {
                        self.imageViewItem.image = nil
                    }
                    return
            }
            
            let image = UIImage(data: imgData)
            DispatchQueue.main.async {
                self.imageViewItem.image = image
            }
        })
    }
}
