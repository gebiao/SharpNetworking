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
    public var task: NSURLSessionTask { return dataOperator.task }
    
    /// The request is sent to server
    public var request: NSURLRequest? { return task.originalRequest }
    
    /// The dataOperator is data, error, task and progress operating
    public var dataOperator: DataOperator
    
    /// The progress is requst progress
    public var progress: NSProgress? { return dataOperator.progress }
    
    //MARK: // LifeCycle
    init (session: NSURLSession, task: NSURLSessionTask) {
        self.dataOperator = DataOperator(task: task)
        self.session = session
    }
    
    
    public class DataOperator {
        /// session task
        var task: NSURLSessionTask
        
        var response: NSHTTPURLResponse? { return task.response as? NSHTTPURLResponse}
        
        /// request progress
        let progress: NSProgress
        
        /// requst return data
        var data: NSData?
        
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

}


extension Requset {
    
    
}