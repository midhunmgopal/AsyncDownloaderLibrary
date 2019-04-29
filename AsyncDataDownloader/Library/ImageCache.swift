//
//  ImageCache.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 29/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation
import UIKit


/// Model struct for cache.
struct CacheData {
    var data: Data
    var timestamp: Int
    var hitCount: Int
    
    init(data: Data, timestamp: Int, count: Int = 1) {
        self.data = data
        self.timestamp = timestamp
        self.hitCount = count
    }
}


/// Class reponsible for cache handling.
class ImageCache {
    private static let _shared = ImageCache()
    class var shared: ImageCache {
        return _shared
    }
    
    private var cache: [String: CacheData]
    
    /// Image maximum hold interval
    private let kMaximumHoldInterval: TimeInterval = 60
    
    /// Configurable maximum cache hold count.
    var maxCacheHoldCount: Int
    
    private init() {
        maxCacheHoldCount = 10
        cache = [:]
    }
    
    
    /// Returns true if maximum count reached.
    private var isMaximumCountReached: Bool {
        return cache.keys.count >= maxCacheHoldCount
    }
    
    
    /**
     Get the item from the cache with key.
     - Parameter url: The unique url, String.
     - Returns: If data found for the unique key, then CacheData else nil.
     */
    private func cacheDataWith(url: String) -> CacheData? {
        cache[url]?.timestamp = Int(Date().timeIntervalSince1970)
        return cache[url]
    }
    
    
    /**
     Return the image data for the given url.
     - Parameter url: The unique url, String.
     - Returns: If data found for key, then UIImage else nil.
     */
    func imageWith(url: String) -> UIImage? {
        cache[url]?.timestamp = Int(Date().timeIntervalSince1970)
        guard let data = cache[url]?.data else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /**
     Add item to the cache with url.
     - Parameter image: The image to be cached, Data.
     - Parameter url: The unique image url, String.
     */
    func add(image: Data, url: String) {
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var cacheData = cacheDataWith(url: url)
        if cacheData != nil {
            cacheData?.data = image
            cacheData?.hitCount += 1
            cacheData?.timestamp = timestamp
        }
        else {
            cacheData = CacheData(data: image, timestamp: timestamp)
        }
        
        // remove from the cache based on time.
        checkAndRemoveCache(interval: kMaximumHoldInterval)
        
        if !isMaximumCountReached {
            cache[url] = cacheData
        }
        else {
            removeMaximumHoldTimeItem()
            cache[url] = cacheData
        }
    }
    
    /**
     Filter out all the images from the cache with greated than time interval.
     - Parameter interval: The maximum time interval.
     */
    func checkAndRemoveCache(interval: TimeInterval) {
        cache = cache.filter({ (arg: (key: String, value: CacheData)) -> Bool in
            let (_, value) = arg
            let currentTime = Date()
            let itemDate = Date(timeIntervalSince1970: TimeInterval(value.timestamp))
            return currentTime.timeIntervalSince(itemDate) < interval
        })
    }
    
    
    /**
     Remove the item from the cache with maximum hold time.
     */
    func removeMaximumHoldTimeItem() {
        var maxKey = ""
        var maxValue = 0
        
        // finding the maximum hold time asset.
        for (key, value) in cache {
            let currentTime = Date()
            let itemDate = Date(timeIntervalSince1970: TimeInterval(value.timestamp))
            let differnce = currentTime.timeIntervalSince(itemDate)
            
            maxKey = Int(differnce) > maxValue ? key : maxKey
            maxValue = Int(differnce) > maxValue ? Int(differnce) : maxValue
        }
        cache.removeValue(forKey: maxKey)
    }
}
