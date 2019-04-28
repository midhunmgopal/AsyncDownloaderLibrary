//
//  ActivityIndicatorView.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {

    private(set) var activityIndicator: UIActivityIndicatorView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    /** Setup UI */
    func setup() {
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = self.center
        activityIndicator?.startAnimating()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if let indicator = activityIndicator {
            self.addSubview(indicator)
        }
    }
    
    
    /**
     Show acitivity indicator in view
     - Parameter view: The parent view. Default is nil
     */
    class func showIn(view: UIView? = nil) {
        guard let parentView = view else {
            return
        }
        let indicatorView = ActivityIndicatorView(frame: parentView.bounds)
        DispatchQueue.main.async {
            parentView.addSubview(indicatorView)
            parentView.bringSubviewToFront(indicatorView)
        }
    }
    
    /**
     Hide acitivity indicator in view
     - Parameter view: The parent view. Default is nil
     */
    class func hideFrom(view: UIView? = nil) {
        guard let parentView = view else {
            return
        }
        DispatchQueue.main.async {
            for view in parentView.subviews {
                if view.isKind(of: ActivityIndicatorView.self) {
                    (view as? ActivityIndicatorView)?.activityIndicator?.stopAnimating()
                    view.removeFromSuperview()
                }
            }
        }
        
    }

}
