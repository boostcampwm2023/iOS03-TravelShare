//
//  CacheManager.swift
//  Macro
//
//  Created by 김경호 on 11/15/23.
//

import Foundation

struct CacheManager {
    private let memoryCache = NSCache<NSString, NSObject>()
}

extension CacheManager {
    func save(key: String, data: NSObject) {
        memoryCache.setObject(data, forKey: key as NSString)
    }
    
    func load(key: String) -> NSObject? {
        return memoryCache.object(forKey: key as NSString)
    }
}
