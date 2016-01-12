//
//  File.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation


public func request(
    method: Method,
    URLString: String,
    parameters: [String : AnyObject]? = nil,
    encoding: ParameteEncoding = .URL,
    heard: [String : String]? = nil
    ) -> Request {
        
        return Manager.sharedInstance.request(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard)
}

public func download(
    method: Method,
    URLString: String,
    parameters: [String : AnyObject]? = nil,
    encoding: ParameteEncoding = .URL,
    heard: [String : String]? = nil,
    destination: Request.DownloadFileDestination,
    progress: Request.TaskDelegate.ProgressClosure?,
    succee: Request.TaskDelegate.SucceeClosure?,
    failure: Request.TaskDelegate.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.download(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard, destination: destination, progress: progress, succee: succee, failure: failure)
}

public func download(
    resumeData: NSData,
    destination: Request.DownloadFileDestination,
    progress: Request.TaskDelegate.ProgressClosure?,
    succee: Request.TaskDelegate.SucceeClosure?,
    failure: Request.TaskDelegate.FailureClosure?) -> Request {
        return Manager.sharedInstance.download(resumeData, destination: destination, progress: progress, succee: succee, failure: failure)
}