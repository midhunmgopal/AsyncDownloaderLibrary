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
    fileprivate var refreshControl = UIRefreshControl()
    fileprivate var isRefreshing: Bool = false
    
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
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshImageData(_:)), for: .valueChanged)
    }

    
    /// Load the data to display.
    private func loadData() {
        showLoading()
        let apimanager = APIManager()
        apimanager.requestWith(urlString: kDataURL) { [weak self] (response) in
            guard let self = self else { return }
            
            self.hideLoading()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            //Error check
            guard response.error == nil else {
                print("Error: \(response.error?.localizedDescription ?? "")")
                self.isRefreshing = false
                return
            }
            
            // Result data
            guard let result = response.data as? [[String: Any]] else {
                self.isRefreshing = false
                return
            }
            let dataModel = result.map({ DataModel(data: $0) })
            if self.isRefreshing {
                self.isRefreshing = false
                self.dataSource = dataModel
            }
            else {
                self.dataSource.append(contentsOf: dataModel)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    /// Refresh the page.
    @objc private func refreshImageData(_ sender: Any) {
        page = 0
        shouldLoadNextPage = true
        isRefreshing = true
        loadData()
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



