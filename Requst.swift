//
//  Requst.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

public class Requset {
    /// The session is create session
    public let session: NSURLSession
    
    /// The task is session task
    public var task: NSURLSessionTask { return delegate.task }
    
    /// The request is sent to server
    public var request: NSURLRequest? { return task.originalRequest }
    
    /// The dataOperator is data, error, task and progress operating
    public var delegate: TaskDelegate
    
    /// The progress is requst progress
    public var progress: NSProgress? { return delegate.progress }
    
    //MARK: // LifeCycle
    init (session: NSURLSession, task: NSURLSessionTask) {
        
        switch task {
        case is NSURLSessionDataTask:
            self.delegate = DataTaskDelegate(task: task)
        case is NSURLSessionUploadTask:
            self.delegate = UploadTaskDelegate(task: task)
        case is NSURLSessionDownloadTask:
            self.delegate = DownloadTaskDelegate(task: task)
        default:
            self.delegate = TaskDelegate(task: task)
        }
        
        self.session = session
    }
    
    
    public func resume() {
        task.resume()
    }
    
    public func suspend() {
        task.suspend()
    }
    
    public func cancel() {
        if let downloadDelegate = delegate as? DownloadTaskDelegate,
            downloadTask = downloadDelegate.downloadTask {
                downloadTask.cancelByProducingResumeData({ (resumeData) -> Void in
                    downloadDelegate.resumeData = resumeData
                })
        } else {
            task.cancel()
        }
    }
    
    
    public class TaskDelegate: NSObject {
        /// session task
        var task: NSURLSessionTask
        
        var response: NSHTTPURLResponse? { return task.response as? NSHTTPURLResponse}
        
        /// request progress
        let progress: NSProgress
        
        /// requst return data
        var data: NSData? { return nil }
        
        /// error message
        var error: NSError?
        
        init (task: NSURLSessionTask) {
            self.task = task
            self.progress = NSProgress(totalUnitCount: 0)
        }
        
        // MARK: -URLSessionTaskDelegate
        func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
        }
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
        }
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
            
        }
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            self.progress.totalUnitCount = totalBytesExpectedToSend
            self.progress.completedUnitCount = totalBytesSent
        }
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
            self.task = task
            self.error = error
        }
        
    }
    
    //MARK: -DataDelegate
    public class DataTaskDelegate: TaskDelegate {
        
    }
    
}


extension Requset {
    
    
}