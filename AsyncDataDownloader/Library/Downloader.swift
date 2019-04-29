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
        
        // Get from the cache.
        if let cacheData = DataCache.shared.itemWith(url: urlString){
            DispatchQueue.main.async {
                completion(cacheData, nil)
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        dataTask = session.dataTask(
            with: urlRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                // Adding to the cache.
                if error == nil && data != nil {
                    DataCache.shared.add(data: data!, url: urlString)
                }
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
     - Parameter completion: The completion closure to update the image.
     */
    func downloadImage(url: String,
                       completion: ((_ image: UIImage?) -> Void)? = nil) {
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
            DispatchQueue.main.async {
                completion?(UIImage(data: _data))
            }
        }
    }
}
