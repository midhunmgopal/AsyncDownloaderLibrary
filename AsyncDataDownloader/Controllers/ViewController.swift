//
//  ViewController.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 26/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let kImageReuseIdentifier = "kImageReuseIdentifier"
    fileprivate let kCellMinimumSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /// Initialize
    private func initialize() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    }


}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageReuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        return cell ?? ImageCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset
        let contentWidth = collectionView.frame.width - (contentInset.left + contentInset.right)
        let width = (contentWidth / 2) - (kCellMinimumSpacing / 2)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kCellMinimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kCellMinimumSpacing
    }
}



