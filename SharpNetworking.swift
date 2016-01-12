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
    var progress: Request.ProgressClosure?,
    var succee: Request.SucceeClosure?,
    var failure: Request.FailureClosure?) -> Request {
        let request = Manager.sharedInstance.download(method, URLString: URLString, heard: heard, destination: destination)
        progress = request.progressClosure
        succee = request.succeeClosure
        failure = request.failureClosure
        
        return request
        
}

public func download(
    resumeData: NSData,
    destination: Request.DownloadFileDestination,
    var progress: Request.ProgressClosure?,
    var succee: Request.SucceeClosure?,
    var failure: Request.FailureClosure?) -> Request {
        let request = Manager.sharedInstance.download(resumeData, destination: destination)
        progress = request.progressClosure
        succee = request.succeeClosure
        failure = request.failureClosure
        return request
}