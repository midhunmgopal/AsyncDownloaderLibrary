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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeBorderView()
    }
    
    /// Make the cell with a border.
    private func makeBorderView() {
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }
}
