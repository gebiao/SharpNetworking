//
//  File.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation


public func getDataRequest(
    method: Method,
    URLString: String,
    parameters: [String : AnyObject]? = nil,
    encoding: ParameteEncoding = .URL,
    heard: [String : String]? = nil,
    progress: Request.ProgressClosure?,
    succee: Request.SucceeClosure?,
    failure: Request.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.request(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard, progress: progress, succee: succee, failure: failure)
}

public func download(
    method: Method,
    URLString: String,
    parameters: [String : AnyObject]? = nil,
    encoding: ParameteEncoding = .URL,
    heard: [String : String]? = nil,
    destination: Request.DownloadFileDestination,
    progress: Request.ProgressClosure?,
    succee: Request.SucceeClosure?,
    failure: Request.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.download(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard, destination: destination, progress: progress, succee: succee, failure: failure)
}

public func download(
    resumeData: NSData,
    destination: Request.DownloadFileDestination,
    progress: Request.ProgressClosure?,
    succee: Request.SucceeClosure?,
    failure: Request.FailureClosure?) -> Request {
        return Manager.sharedInstance.download(resumeData, destination: destination, progress: progress, succee: succee, failure: failure)
}