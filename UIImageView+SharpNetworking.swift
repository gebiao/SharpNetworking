//
//  UIImageView+SharpNetworking.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/27/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func gb_setImage(urlString: String, key: String, completedHandle: ((Bool?, Bool?) -> Void)?) {
        getMemoryOrDiskCacheImage(urlString, key: key) { [weak self] (image, errorInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let image = image, strongSelf = self {
                    strongSelf.image = image
                }
            })
        }
    }
    
    typealias CompletedCallback = (UIImage?, String?) -> Void
    func getMemoryOrDiskCacheImage(urlstring: String, key: String, completedCallback: CompletedCallback) {
        let memoryCache = SharpNetManager.manager.memoryChache
        print("\(memoryCache)")
        
        let completedHandle = memoryCache.retrieveImageForKey(key)
        if let image = completedHandle() {
            completedCallback(image, nil)
        } else {
            let destination = Request.suggestDownloadImageDestination(NSURL.init(fileURLWithPath: memoryCache.diskPath))
            download(.GET, URLString: urlstring, destination: destination, progress: { (progress) -> Void in
                
                }, success: { (_, data) -> Void in
                    completedCallback(UIImage.init(data: data), nil)
                    memoryCache.storeImageCache(data, forKey: key, completedHandle: { () -> Void in
                        
                    })
                }) { (_, error) -> Void in
                    completedCallback(nil, "\(error)")
            }
        }
    }
    
    
}
