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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "", name: UIApplicationDidEnterBackgroundNotification, object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "", name: UIApplicationWillTerminateNotification, object: nil)
        
    }
    
}

extension ImageCache {
    
    func storeImageCache(image: UIImage, forKey key: String, toDisk: Bool, completedHandle: (() -> Void)?) {
        memoryCache.setObject(image, forKey: key, cost: 0)
        
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
}

extension ImageCache {
    func retrieveImageForKey(key: String, completedHandler: ((UIImage?) -> Void)?) {
        
    }
}





































