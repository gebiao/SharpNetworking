//
//  Download.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

extension Manager {
    
    public enum DownloadDataType {
        case Request(NSURLRequest)
        case ResumeData(NSData)
    }
    
    private func download(downloadDataType: DownloadDataType, destination: Requset.DownloadFileDestination) -> Requset {
        
    }
    
    public func download(
        method: Method,
        URLString: String,
        parameters: [String : AnyObject]? = nil,
        encoding: ParameteEncoding = .URL,
        heard: [String : String]?,
        destination: Requset.DownloadFileDestination) -> Requset {
            let mutableRequest = NSMutableURLRequest(URL: NSURL.init(string: URLString)!)
            return request(encoding.encoding(mutableRequest, parametes: parameters).0, destination: destination)
    }
    
    func request(URLRequst: NSMutableURLRequest, destination: Requset.DownloadFileDestination) -> Requset {
        return download(.Request(URLRequst), destination: destination)
    }
    
    public func download(resumeData: NSData, destination: Requset.DownloadFileDestination) -> Requset {
        return download(.ResumeData(resumeData), destination: destination)
    }
    
}

extension Requset {
    
    public typealias DownloadFileDestination = (NSURL, NSHTTPURLResponse) -> NSURL
    
    public func suggestDownloadFileDesination(
        directory: NSSearchPathDirectory = .DocumentDirectory,
        domains: NSSearchPathDomainMask = .UserDomainMask) -> DownloadFileDestination {
            return { temporaryURLs, response -> NSURL in
                let directoryURLs = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domains)
                if !directoryURLs.isEmpty {
                    return directoryURLs.first!.URLByAppendingPathComponent(response.suggestedFilename!)
                }
                return temporaryURLs
            }
    }
    
    
}

