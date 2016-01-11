//
//  Manager.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation
import UIKit

public class Manager {
    
    public static let sharedInstance: Manager = {
        let defaultConfiguation = NSURLSessionConfiguration.defaultSessionConfiguration()
        defaultConfiguation.HTTPAdditionalHeaders = Manager.defaultHttpHeardField
        
        return Manager(sessionConfiguration: defaultConfiguation)
    }()
    
    /// http heard field
    public static let defaultHttpHeardField: [String : String] = {
        
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        let acceptLanguages: String = NSLocale.preferredLanguages().enumerate().map { index, languageCode in
            let quality = 1.0 - Double(index)/10
            return "\(languageCode);q=\(quality)"
            }.joinWithSeparator(", ")
        
        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let bundleVersion = info[kCFBundleVersionKey as String] ?? "Unknow"
                let executeable = info[kCFBundleExecutableKey as String] ?? "Unkonw"
                let identifier = info[kCFBundleIdentifierKey as String] ?? "Unknow"
                let systemVersion = UIDevice.currentDevice().systemVersion
                
                return "\(executeable)/\(identifier) (\(bundleVersion); iOS \(systemVersion))"
            }
            return "SharpNetworking"
        }()
        
        
        return ["Accept-Encoding" : acceptEncoding,
            "Accept-Language" : acceptLanguages,
            "User-Agent" : userAgent
        ]
    }()
    
    /// The undering session
    public let session: NSURLSession
    
    public let delegate: SessionDelegate
    
    let queue: dispatch_queue_t = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    
    /// wheather start requst immediate
    public var startRequestImmediate: Bool = true
    
    private init(
        sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration(),
        delegate: SessionDelegate = SessionDelegate()) {
            self.delegate = delegate
            self.session = NSURLSession(configuration: sessionConfiguration, delegate: delegate, delegateQueue: nil)
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
    
    public func request(method: Method, URLString: String, parameters: [String : AnyObject]? = nil, encoding: ParameteEncoding = .URL, heard: [String : String]? = nil) -> Requset {
        return URLRequest(method, URLString: URLString, parameters: parameters, heard: heard)
    }
    
    func URLRequest(
        method: Method,
        URLString: String,
        parameters: [String : AnyObject]?,
        encoding: ParameteEncoding = .URL,
        heard: [String : String]?) -> Requset {
            let mutableRequest = NSMutableURLRequest(URL: NSURL.init(string: URLString)!)
            return request(encoding.encoding(mutableRequest, parametes: parameters).0)
    }
    
    func request(URLRequest: NSMutableURLRequest) -> Requset {
        var task: NSURLSessionTask!
        dispatch_sync(queue) { task = self.session.dataTaskWithRequest(URLRequest) }
        return Requset(session: session, task: task)
    }
}


public class SessionDelegate :  NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate {
    
    private var manageTaskList: [Int : Requset.DataOperator] = [:]
    private let queue: dispatch_queue_t = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    
    subscript (sessionTask: NSURLSessionTask) -> Requset.DataOperator? {
        get {
            var task: Requset.DataOperator?
            dispatch_sync(queue) { task = self.manageTaskList[sessionTask.taskIdentifier] }
            return task
        }
        
        set {
            dispatch_barrier_async(queue) { self.manageTaskList[sessionTask.taskIdentifier] = newValue }
        }
    }
    //MARK: - sessionDelegate
    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        
    }
    
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
    }
    
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
    }
}








