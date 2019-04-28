//
//  DataModel.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 28/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation

/// Model class for Data loaded.
struct DataModel {
    var images: ImageURLModel
    
    init(data: [String: Any] = [:]) {
        let urls = data["urls"] as? [String: Any] ?? [:]
        self.images = ImageURLModel(data: urls)
    }
}


/// Model class for image
struct ImageURLModel {
    let full: String
    let small: String
    let reuglar: String
    let thumb: String
    let raw: String
    
    init(data: [String: Any] = [:]) {
        self.full = data["full"] as? String ?? ""
        self.raw = data["raw"] as? String ?? ""
        self.reuglar = data["regular"] as? String ?? ""
        self.thumb = data["thumb"] as? String ?? ""
        self.small = data["small"] as? String ?? ""
    }
}
