//
//  UIImageView+SharpNetworking.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/27/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit


extension UIImageView {
    typealias CompletedCallback = (UIImage?, String?) -> Void
    
    func gb_setImage(urlString: String, key: String, placehold: String, progress: Request.ProgressClosure?, completedHandle: CompletedCallback?) {
        
        if let placeholdImage = UIImage.init(named: placehold) {
            self.image = placeholdImage
        }
        getMemoryOrDiskCacheImage(urlString, key: key, progress: progress) { [weak self] (image, errorInfo) -> Void in
            if let completedHandle = completedHandle {
                completedHandle(image, errorInfo)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let image = image, strongSelf = self {
                    strongSelf.image = image
                }
            })
        }
    }
    
    func getMemoryOrDiskCacheImage(urlstring: String, key: String, progress: Request.ProgressClosure?, completedCallback: CompletedCallback) {
        let memoryCache = SharpNetManager.manager.memoryChache
        let completedHandle = memoryCache.retrieveImageForKey(key)
        if let image = completedHandle() {
            completedCallback(image, nil)
        } else {
            download(.GET, URLString: urlstring, destination: nil, progress: { (pr) -> Void in
                
                if let progress = progress {
                    progress(pr)
                }
                
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
