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
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.request(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard, progress: progress, success: success, failure: failure)
}

public func download(
    method: Method,
    URLString: String,
    parameters: [String : AnyObject]? = nil,
    encoding: ParameteEncoding = .URL,
    heard: [String : String]? = nil,
    destination: Request.DownloadFileDestination,
    progress: Request.ProgressClosure?,
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.download(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard, destination: destination, progress: progress, success: success, failure: failure)
}

public func download(
    resumeData: NSData,
    destination: Request.DownloadFileDestination,
    progress: Request.ProgressClosure?,
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        return Manager.sharedInstance.download(resumeData, destination: destination, progress: progress, success: success, failure: failure)
}

public func upload(
    method: Method,
    URLString: String,
    parametes: [String : String]? = nil,
    encoding: ParameteEncoding = .URL,
    heards: [String : String]? = nil,
    progress: Request.ProgressClosure?,
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        return Manager.sharedInstance.upload(method, URLString: URLString, parametes: parametes, encoding: encoding, heards: heards, progress: progress, success: success, failure: failure)
}

public func upload(
    method: Method,
    URLString: String,
    encoding: ParameteEncoding = .URL,
    data: NSData,
    heards: [String : String]? = nil,
    progress: Request.ProgressClosure?,
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        
        return Manager.sharedInstance.upload(method, URLString: URLString, encoding: encoding, data: data, heards: heards, progress: progress, success: success, failure: failure)
}

public func upload(
    method: Method,
    URLString: String,
    encoding: ParameteEncoding = .URL,
    fileURL: NSURL,
    heards: [String : String]? = nil,
    progress: Request.ProgressClosure?,
    success: Request.SuccessClosure?,
    failure: Request.FailureClosure?) -> Request {
        return Manager.sharedInstance.upload(method, URLString: URLString, encoding: encoding, fileURL: fileURL, heards: heards, progress: progress, success: success, failure: failure)
}