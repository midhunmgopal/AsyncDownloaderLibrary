//
//  Constants.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation
import UIKit

/**
 The completion handler for the api call.
 - Parameter data: The downloaded data will be available here, Data?
 - Parameter error: The error object, Error?
 */
typealias CompletionHandler = (_ data: Data?, _ error: Error?) -> Void

/**
 The completion handler for the api call.
 - Parameter response: The reponse data, APIResponse.
 */
typealias ResponseHandler = (_ response: APIResponse) -> Void


/// HTTP methods.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

let kDataURL = "http://pastebin.com/raw/wgkJgazE"

enum StatusCode: Int {
    case success = 200
    case notFound = 404
}
