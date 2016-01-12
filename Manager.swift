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
    
    public func request(method: Method, URLString: String, parameters: [String : AnyObject]? = nil, encoding: ParameteEncoding = .URL, heard: [String : String]? = nil, progress: Request.ProgressClosure?, succee: Request.SucceeClosure?, failure: Request.FailureClosure?) -> Request {
        let request = URLRequest(method, URLString: URLString, parameters: parameters, heard: heard)
        request.delegate.progressClosure = progress
        request.delegate.succeeClosure = succee
        request.delegate.failureClosure = failure
        return request
    }
    
    func URLRequest(
        method: Method,
        URLString: String,
        parameters: [String : AnyObject]?,
        encoding: ParameteEncoding = .URL,
        heard: [String : String]?) -> Request {
            let mutableRequest = NSMutableURLRequest(URL: NSURL.init(string: URLString)!)
            return request(encoding.encoding(mutableRequest, parametes: parameters).0)
    }
    
    func request(URLRequest: NSMutableURLRequest) -> Request {
        var task: NSURLSessionTask!
        dispatch_sync(queue) { task = self.session.dataTaskWithRequest(URLRequest) }
        let request = Request(session: session, task: task)
        delegate[task] = request.delegate
        if startRequestImmediate {
            request.resume()
        }
        
        return request
    }
    
    
    // SEEEION DELEGATE
    public class SessionDelegate :  NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate {
        
        private var manageTaskList: [Int : Request.TaskDelegate] = [:]
        private let queue: dispatch_queue_t = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
        
        subscript (sessionTask: NSURLSessionTask) -> Request.TaskDelegate? {
            get {
                var task: Request.TaskDelegate?
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
        
        //MAKE: -SessionTaskDelegate
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
            
        }
        
        //MARK: -SessionDataDelegate
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            if let dataTaskDelegate = self[dataTask] as? Request.DataTaskDelegate {
                dataTaskDelegate.URLSession(session, dataTask: dataTask, didReceiveResponse: response, completionHandler: completionHandler)
            }
        }
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeStreamTask streamTask: NSURLSessionStreamTask) {
            if let dataTaskDelegate = self[dataTask] as? Request.DataTaskDelegate {
                dataTaskDelegate.URLSession(session, dataTask: dataTask, didBecomeStreamTask: streamTask)
            }
        }
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
            if let dataTaskDelegate = self[dataTask] as? Request.DataTaskDelegate {
                dataTaskDelegate.URLSession(session, dataTask: dataTask, didBecomeDownloadTask: downloadTask)
            }
        }
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
            if let dataTaskDelegate = self[dataTask] as? Request.DataTaskDelegate {
                dataTaskDelegate.URLSession(session, dataTask: dataTask, didReceiveData: data)
            }
        }
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
            if let dataTaskDelegate = self[dataTask] as? Request.DataTaskDelegate {
                dataTaskDelegate.URLSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
            }
        }
        
        //MARK: -DownloadDelegate
        var downloadTaskDidWrited: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
        var downloadResumeTaskFileOffset: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64) -> Void)?
        var downloadDataCompleted: ((NSURLSession, NSURLSessionDownloadTask, NSURL, NSData?) -> Void)?
        
        public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
            if let downloadDelegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                if let downloadDataCompleted = downloadDataCompleted {
                    downloadDelegate.downloadDataCompleted = downloadDataCompleted
                }
                downloadDelegate.URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
            }
        }
        
        public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            if let downloadDelegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                downloadDelegate.URLSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
                if let downloadTaskDidWrited = downloadTaskDidWrited {
                    downloadDelegate.downloadTaskDidWrited = downloadTaskDidWrited
                }
            }
        }
        
        public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            if let downloadDelegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                downloadDelegate.URLSession(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
                if let downloadResumeTaskFileOffset = downloadResumeTaskFileOffset {
                    downloadDelegate.downloadResumeTaskFileOffset = downloadResumeTaskFileOffset
                }
            }
        }
    }
    
}










