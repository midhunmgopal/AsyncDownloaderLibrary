//
//  Extensions.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /** Show the loading view */
    func showIndicator() {
        ActivityIndicatorView.showIn(view: self)
    }
    
    /** Hide the loading view */
    func hideIndicator() {
        ActivityIndicatorView.hideFrom(view: self)
    }
}

extension UIViewController {
    
    /**
     Show loading indicator
     */
    func showLoading() {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let rootController = window.rootViewController else {
            return
        }
        
        let activitIndicator = ActivityIndicatorView(frame: rootController.view.bounds)
        rootController.view.addSubview(activitIndicator)
    }
    
    
    /**
     Hide loading indicator
     */
    func hideLoading() {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let rootController = window.rootViewController else {
                return
        }
        
        DispatchQueue.main.async {
            for view in rootController.view.subviews {
                if view.isKind(of: ActivityIndicatorView.self) {
                    (view as? ActivityIndicatorView)?.activityIndicator?.stopAnimating()
                    view.removeFromSuperview()
                    break
                }
            }
        }
        
        
    }
}
