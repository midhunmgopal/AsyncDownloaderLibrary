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
    fileprivate var dataTask = URLSessionDataTask()
    
    
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
        urlRequest.httpMethod = "GET"
        
        dataTask = session.dataTask(
            with: urlRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                completion(data, error)
        })
        dataTask.resume()
    }
}
