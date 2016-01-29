//
//  UIImageView+SharpNetworking.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/27/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func gb_setImage(urlString: String, key: String!,  progress: ((NSProgress) -> Void)?, completedHandle: ((Bool?, Bool?) -> Void)?) {
        
        let memoryCache = ImageCache.init(name: urlString)
        
        memoryCache.retrieveImageForKey(key) { (image) -> Void in
            if let _ = image {//有存储
                
            } else {//没有存储情况
                
            }
        }
        
        let destination = Request.suggestDownloadImageDestination(NSURL.init(fileURLWithPath: memoryCache.diskPath))
        download(.GET, URLString: urlString, destination: destination, progress: { (progress) -> Void in
            
            }, success: { (_, data) -> Void in
                memoryCache.storeImageCache(data, forKey: key, completedHandle: { () -> Void in
                    
                })
            }) { (_, error) -> Void in
                
        }
        
        
    }
    
    
}

extension Request {
    static func suggestDownloadImageDestination(url: NSURL) -> DownloadFileDestination {
        return {_,_ in 
            return url
        }
    }
}