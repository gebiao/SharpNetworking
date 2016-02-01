//
//  ImageCache.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/27/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import UIKit

let defaultMemoryCacheName = "ShareNetworking.defaultMemoryCacheName"
let defaultIOququeName = "ShareNetworking.defaultIOququeName"

public class ImageCache {
    let memoryCache: NSCache = NSCache()
    private let io_queue: dispatch_queue_t!
    private var defaultManager: NSFileManager!
    let diskPath: String!
    
    public init(name: String) {
        if name.isEmpty {
            fatalError("memory cache empty is not permitted.")
        }
        
        memoryCache.name = name
        self.diskPath = (NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first! as NSString).stringByAppendingPathComponent(defaultMemoryCacheName + name)
        
        self.io_queue = dispatch_queue_create(defaultIOququeName + name, DISPATCH_QUEUE_SERIAL)
        dispatch_async(io_queue) { self.defaultManager = NSFileManager() }
        
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
    
    func storeImageCache(originData: NSData, forKey key: String, completedHandle: (() -> Void)?) {
        func callbackCompletedInMainQueue() {
            if let handler = completedHandle {
                dispatch_async(dispatch_get_main_queue()) { handler() }
            }
        }
        
        func storeObjToDisk(imageData: NSData) {
            if !self.defaultManager.fileExistsAtPath(self.diskPath) {
                do {
                    try self.defaultManager.createDirectoryAtPath(self.diskPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    
                }
            }
            self.defaultManager.createFileAtPath(key.md5(), contents: imageData, attributes: nil)
            callbackCompletedInMainQueue()
        }
        
        guard let image = UIImage.init(data: originData) else { fatalError("image or originData empty is not permitted.") }
        memoryCache.setObject(image, forKey: key, cost: image.imageCost)
        storeObjToDisk(originData)
    }
    
    //
    func cleanCache() {
        memoryCache.removeAllObjects()
    }
}


extension ImageCache {
    
    typealias CompletedHandler = (() -> UIImage?)
    
    func retrieveImageForKey(key: String) -> CompletedHandler {
//        func callbackCompleted(image: UIImage?) {
//            if let completedHandler = completedHandler {
//                dispatch_async(dispatch_get_main_queue()) { completedHandler(image) }
//            }
//        }
        
        func returnValue(image: UIImage?) -> CompletedHandler {
            return {
                return image
            }
        }

        if let image = memoryCache.objectForKey(key) where (image is UIImage) {
            return {
                return (image as! UIImage)
            }
        } else {
            let singleDiskPath = (self.diskPath as NSString).stringByAppendingPathComponent(key.md5())
            if let originData = NSData.init(contentsOfFile: singleDiskPath) {
                if let image = UIImage.init(data: originData) {
                    return {
                        return image
                    }
                } else {
                    return {
                        return nil
                    }
                }
            } else {
                return {
                    return nil
                }
            }
        }
    }
}

extension UIImage {
    var imageCost: Int {
        return images == nil ? Int(size.width * size.height * scale * scale) : Int(size.width * size.height * scale * scale) * images!.count
    }
}

extension String {
    func md5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}


































