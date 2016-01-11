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
        
        var downloadTask: NSURLSessionDownloadTask!
        switch downloadDataType {
        case .Request(let URLRequest):
            dispatch_sync(queue) { downloadTask = self.session.downloadTaskWithRequest(URLRequest) }
        case .ResumeData(let resumeData):
            dispatch_sync(queue) { downloadTask = self.session.downloadTaskWithResumeData(resumeData) }
        }
        
        let request = Requset(session: session, task: downloadTask)
        if let downloadDelegate = request.dataOperator as? Requset.DownloadTaskDelegate {
            downloadDelegate.downloadDestinationToURL = { (session, task, URL) in
                return destination(URL, task.response as! NSHTTPURLResponse)
            }
        }
        delegate[downloadTask] = request.dataOperator
        if startRequestImmediate {
            request.resume()
        }
        
        return request
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
    
    public class func suggestDownloadFileDesination(
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
    
    
    /// DownloadDelegate
    class DownloadTaskDelegate: DataOperator, NSURLSessionDownloadDelegate {
        
        var downloadTask: NSURLSessionDownloadTask? { return task as? NSURLSessionDownloadTask }
        var resumeData: NSData?
        
        override var data: NSData? { return resumeData }
        
        var downloadDestinationToURL: ((NSURLSession, NSURLSessionDownloadTask, NSURL) -> NSURL)?
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
            if let downloadDestinationToURL = downloadDestinationToURL {
                let destinationToURL = downloadDestinationToURL(session, downloadTask, location)
                do {
                    try NSFileManager.defaultManager().moveItemAtURL(location, toURL: destinationToURL)
                } catch {
                    self.error = error as NSError
                }
            }
        }
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            
            self.progress.totalUnitCount = totalBytesExpectedToWrite
            self.progress.completedUnitCount = bytesWritten
        }
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            self.progress.totalUnitCount = expectedTotalBytes
            self.progress.completedUnitCount = fileOffset
        }
        
    }
    
    
}

