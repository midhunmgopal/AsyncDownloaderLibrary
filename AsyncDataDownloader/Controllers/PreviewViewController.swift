//
//  PreviewViewController.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 30/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var buttonClose: UIButton?
    @IBOutlet weak var imageView: UIImageView?
    
    var data: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }
    
    /// Return the preview contorller instance.
    class var previewController: PreviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController
        controller?.modalTransitionStyle = .crossDissolve
        controller?.modalPresentationStyle = .overCurrentContext
        return controller!
    }

    private func setupUI() {
        buttonClose?.layer.borderColor = UIColor.white.cgColor
        buttonClose?.layer.borderWidth = 1
        buttonClose?.layer.cornerRadius = (buttonClose?.frame.height ?? 0) / 2
    }
    
    private func loadData() {
        guard let model = data else {
            self.imageView?.image = UIImage(named: "placeholder")
            return
        }
        
        view.showIndicator()
        let downloader = Downloader()
        downloader.downloadImage(url: model.images.full) { (image) in
            
            self.view.hideIndicator()
            if image != nil {
                self.imageView?.image = image
                self.imageView?.layoutIfNeeded()
            }
        }
    }

    @IBAction func didTappedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
