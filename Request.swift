//
//  Requst.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

public class Request {
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
    
    //MARK: -LifeCycle
    init (session: NSURLSession, task: NSURLSessionTask) {
        
        switch task {
        case is NSURLSessionUploadTask:
            self.delegate = UploadTaskDelegate(task: task)
        case is NSURLSessionDataTask:
            self.delegate = DataTaskDelegate(task: task)
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
    
    public typealias SuccessClosure = (NSURLSessionTask, NSData) -> Void
    public typealias FailureClosure = (NSURLSessionTask, NSError) -> Void
    public typealias ProgressClosure = (NSProgress) -> Void
    
    
    public class TaskDelegate: NSObject, NSURLSessionTaskDelegate {
        /// session task
        public var task: NSURLSessionTask
        
        public var response: NSHTTPURLResponse? { return task.response as? NSHTTPURLResponse}
        
        /// request progress
        public let progress: NSProgress
        
        
        /// requst return data
        public var data: NSData? { return nil }
        
        /// error message
        public var error: NSError?
        
        //success
        public var successClosure: SuccessClosure?
        //Failure
        public var failureClosure: FailureClosure?
        //Progress download and upload
        public var progressClosure: ProgressClosure?
        
        
        init (task: NSURLSessionTask) {
            self.task = task
            self.progress = NSProgress(totalUnitCount: 0)
        }
        
        // MARK: -URLSessionTaskDelegate
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
            self.task = task
            self.error = error
            if let
                failureClosure = failureClosure,
                error = error {
                    failureClosure(task, error)
            } else if let
                successClosure = successClosure,
                data = data
            {
                successClosure(task, data)
            }
        }
    }
    
    //MARK: -DataDelegate
    public class DataTaskDelegate: TaskDelegate {
        
        private var totalDataReceived: Int64 = 0
        private var mutableData: NSMutableData = NSMutableData()
        override public var data: NSData {
            return mutableData
        }
        
        func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            completionHandler(.Allow)
        }
        
        func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
            
            let expectedTotalDataLengeth = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            mutableData.appendData(data)
            totalDataReceived += data.length
            progress.totalUnitCount = expectedTotalDataLengeth
            progress.completedUnitCount = totalDataReceived
            if let progressClosure = progressClosure {
                progressClosure(progress)
            }
        }
        
        func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
            if let successClosure = successClosure {
                successClosure(dataTask, proposedResponse.data)
            }
        }
    }
    
}


extension Request {
    
    
}