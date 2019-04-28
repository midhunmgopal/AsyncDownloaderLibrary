//
//  APIManager.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    fileprivate let session = URLSession(configuration: .default)
    fileprivate var dataTask = URLSessionDataTask()
    
    
    override init() {
        super.init()
    }
    
    
    /**
     Request data from given url. And the response is available through the closure.
     - Parameters:
        - urlString: The url of the data to download. Type String.
        - method: The http method which is used to get the network data and default is GET, HTTPMethod type.
        - completion: The completion handler.
     */
    func requestWith(urlString: String,
                      method: HTTPMethod = .get,
                      completion: @escaping ResponseHandler) {
        let responseHandler = APIResponse()
        
        guard let url = URL(string: urlString) else {
            responseHandler.error = nil
            responseHandler.message = "Invalid URL"
            responseHandler.data = nil
            completion(responseHandler)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        dataTask = session.dataTask(
            with: urlRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                responseHandler.error = error
                responseHandler.data = data
                guard let dataResponse = data,
                    error == nil else {
                        completion(responseHandler)
                        return
                }
                
                do {
                    let responseData = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    print("************\n", responseData)
                    responseHandler.data = responseData
                }
                catch {
                    print(error.localizedDescription)
                    responseHandler.error = error
                    responseHandler.data = nil
                }
                completion(responseHandler)
        })
        dataTask.resume()
    }
    
}
