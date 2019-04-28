//
//  APIResponse.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation

class APIResponse {
    var data: Any?
    var message: String
    var error: Error?
    var code: StatusCode
    init(data: Any? = nil,
         message: String = "",
         error: Error? = nil,
         code: StatusCode = StatusCode.notFound) {
        self.data = data
        self.message = message
        self.error = error
        self.code = code
    }
}
