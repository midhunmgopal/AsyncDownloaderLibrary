//
//  Downloader.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 26/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class Downloader: NSObject {
    fileprivate let session = URLSession(configuration: .default)
    fileprivate var dataTask: URLSessionDataTask?
    
    
    /**
     Download data from the url. And the the response is available through the closure.
     - Parameter urlString: The url of the data to download. Type String.
     - Parameter completion: The completion handler.
     */
    func downloadWith(urlString: String, completion: @escaping CompletionHandler) {
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        dataTask = session.dataTask(
            with: urlRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                completion(data, error)
        })
        dataTask?.resume()
    }
    
    /**
     Cancel the current data task.
     */
    func cancel() {
        dataTask?.cancel()
    }
    
    
    /**
     Download the image with the given url and optional placeholder image.
     - Parameter url: The image url to download, String.
     - Parameter placeholder: The placeholder image, UIImage.
     */
    func downloadImage(url: String,
                       completion: ((_ image: UIImage?) -> Void)? = nil) {
        
        if let cacheImage = ImageCache.shared.imageWith(url: url) {
            DispatchQueue.main.async {
                completion?(cacheImage)
            }
            return
        }
        
        cancel()
        // Download the image and store to the cache
        downloadWith(urlString: url) { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            guard let _data = data else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            ImageCache.shared.add(image: _data, url: url)
            DispatchQueue.main.async {
                completion?(UIImage(data: _data))
            }
        }
    }
}
