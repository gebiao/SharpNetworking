//
//  ImageCache.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/27/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

public class ImageCache {
    let memoryCache: NSCache = NSCache()
    
    public init(name: String) {
        if name.isEmpty {
            fatalError("memory cache empty is not permitted.")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveMemoryWarningAction", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackgroundAction", name: UIApplicationDidEnterBackgroundNotification, object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "terminateAction", name: UIApplicationWillTerminateNotification, object: nil)
        
    }
    
    @objc func receiveMemoryWarningAction() {
        cleanCache()
    }
    
    @objc func enterBackgroundAction() {
        cleanCache()
    }
    
    @objc func terminateAction() {
        cleanCache()
    }
    
}

extension ImageCache {
    
    func storeImageCache(image: UIImage, forKey key: String, toDisk: Bool, completedHandle: (() -> Void)?) {
        memoryCache.setObject(image, forKey: key, cost: image.imageCost)
        
        func callbackCompletedInMainQueue() {
            if let handler = completedHandle {
                dispatch_async(dispatch_get_main_queue()) { handler() }
            }
        }
        
        if toDisk {
            
        } else {
            callbackCompletedInMainQueue()
        }
    }
    
    //
    func cleanCache() {
        memoryCache.removeAllObjects()
    }
}

extension ImageCache {
    func retrieveImageForKey(key: String, completedHandler: ((UIImage?) -> Void)?) {
        let imageObj = memoryCache.objectForKey(key)
        guard let image: UIImage = imageObj as? UIImage else { return }
        
        if let completedHandler = completedHandler {
            dispatch_async(dispatch_get_main_queue()) { completedHandler(image) }
        }
        
    }
}

extension UIImage {
    var imageCost: Int {
        return images == nil ? Int(size.width * size.height * scale * scale) : Int(size.width * size.height * scale * scale) * images!.count
    }
}

extension String {
    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}


































