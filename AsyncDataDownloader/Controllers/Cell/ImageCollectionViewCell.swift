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
    
    
    /** Set a border for the cell */
    func makeBorderView() {
        viewContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        viewContainer.layer.borderWidth = 1
    }
}
