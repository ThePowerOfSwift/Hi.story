//
//  Cache.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 5/30/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import Kingfisher

class Cache {
    
    static let shareCache = Cache()

}

private let cacheName = "Images"
private let prefixIdentifier = "com.xspyhack.History"

class ImageStorage {
    
    static let sharedStorage = ImageStorage()
    
    fileprivate let cache = ImageCache(name: cacheName, path: String.hi_documentsPath)
    
    func store(_ image: Image, forKey key: String, completionHandler: (() -> Void)? = nil) {
        cache.store(image, forKey: key, toDisk: true, completionHandler: completionHandler)
    }
    
    func retrieveImageInDiskCache(forKey key: String, scale: CGFloat = 1.0) -> Image? {
        return cache.retrieveImageInDiskCache(forKey: key, options: [.scaleFactor(scale)])
    }
    
    static let sharedCache = ImageStorage.sharedStorage.cache
}
