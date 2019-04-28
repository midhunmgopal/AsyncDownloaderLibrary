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
    fileprivate var dataSource = [DataModel]()
    
    // Pagination
    fileprivate var page: Int = 0
    fileprivate var shouldLoadNextPage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        loadData()
    }
    
    /// Initialize
    private func initialize() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    }

    
    /// Load the data to display.
    private func loadData() {
        showLoading()
        let apimanager = APIManager()
        apimanager.requestWith(urlString: kDataURL) { [weak self] (response) in
            self?.hideLoading()
            guard let self = self else { return }
            
            //Error check
            guard response.error == nil else {
                print("Error: \(response.error?.localizedDescription ?? "")")
                return
            }
            
            // Result data
            guard let result = response.data as? [[String: Any]] else {
                return
            }
            let dataModel = result.map({ DataModel(data: $0) })
            self.dataSource.append(contentsOf: dataModel)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageReuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        cell?.updateData(model: dataSource[indexPath.row])
        return cell ?? ImageCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
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



