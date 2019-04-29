//
//  DataCache.swift
//  AsyncDataDownloader
//
//  Created by Midhun on 29/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import Foundation
import UIKit


/// Model struct for cache.
struct CacheDataModel {
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
class DataCache {
    private static let _shared = DataCache()
    class var shared: DataCache {
        return _shared
    }
    
    private var cache: [String: CacheDataModel]
    
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
     - Returns: If data found for the unique key, then CacheDataModel else nil.
     */
    private func cacheDataWith(url: String) -> CacheDataModel? {
        cache[url]?.timestamp = Int(Date().timeIntervalSince1970)
        return cache[url]
    }
    
    
    /**
     Return the data for the given url.
     - Parameter url: The unique url, String.
     - Returns: If data found for key, then Data else nil.
     */
    func itemWith(url: String) -> Data? {
        cache[url]?.timestamp = Int(Date().timeIntervalSince1970)
        return cache[url]?.data
    }
    
    /**
     Add item to the cache with url.
     - Parameter data: The data to be cached, Data.
     - Parameter url: The unique image url, String.
     */
    func add(data: Data, url: String) {
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var cacheData = cacheDataWith(url: url)
        if cacheData != nil {
            cacheData?.data = data
            cacheData?.hitCount += 1
            cacheData?.timestamp = timestamp
        }
        else {
            cacheData = CacheDataModel(data: data, timestamp: timestamp)
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
        cache = cache.filter({ (arg: (key: String, value: CacheDataModel)) -> Bool in
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
