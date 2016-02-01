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
    
    private func download(downloadDataType: DownloadDataType, destination: Request.DownloadFileDestination) -> Request {
        
        var downloadTask: NSURLSessionDownloadTask!
        switch downloadDataType {
        case .Request(let URLRequest):
            dispatch_sync(queue) { downloadTask = self.session.downloadTaskWithRequest(URLRequest) }
        case .ResumeData(let resumeData):
            dispatch_sync(queue) { downloadTask = self.session.downloadTaskWithResumeData(resumeData) }
        }
        
        let request = Request(session: session, task: downloadTask)
        if let downloadDelegate = request.delegate as? Request.DownloadTaskDelegate {
            downloadDelegate.downloadDestinationToURL = { (session, task, URL) in
                return destination(URL, task.response as! NSHTTPURLResponse)
            }
        }
        delegate[downloadTask] = request.delegate
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
        destination: Request.DownloadFileDestination,
        progress: Request.ProgressClosure? = nil,
        success: Request.SuccessClosure? = nil,
        failure: Request.FailureClosure? = nil) -> Request {
            let mutableRequest = NSMutableURLRequest(URL: NSURL.init(string: URLString)!)
            mutableRequest.HTTPMethod = method.rawValue
            let requestInstance = request(encoding.encoding(mutableRequest, parametes: parameters).0, destination: destination)
            requestInstance.delegate.progressClosure = progress
            requestInstance.delegate.successClosure = success
            requestInstance.delegate.failureClosure = failure
            return requestInstance
    }
    
    func request(URLRequst: NSMutableURLRequest, destination: Request.DownloadFileDestination) -> Request {
        return download(.Request(URLRequst), destination: destination)
    }
    
    public func download(
        resumeData: NSData, destination: Request.DownloadFileDestination,
        progress: Request.ProgressClosure? = nil,
        success: Request.SuccessClosure? = nil,
        failure: Request.FailureClosure? = nil) -> Request {
            let requestInstance = download(.ResumeData(resumeData), destination: destination)
            requestInstance.delegate.progressClosure = progress
            requestInstance.delegate.successClosure = success
            requestInstance.delegate.failureClosure = failure
            return requestInstance
    }
    
}

extension Request {
    
    public typealias DownloadFileDestination = (NSURL, NSHTTPURLResponse) -> NSURL
    
    public static func suggestDownloadFileDesination(
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
    
    public static func suggestDownloadImageDestination(fileURL: NSURL) -> DownloadFileDestination {
        return {_,_ in
            return fileURL
        }
    }
    
    
    /// DownloadDelegate
    class DownloadTaskDelegate: TaskDelegate, NSURLSessionDownloadDelegate {
        
        var downloadTask: NSURLSessionDownloadTask? { return task as? NSURLSessionDownloadTask }
        var resumeData: NSData?
        let downloadProgress: NSProgress = NSProgress()
        
        override var data: NSData? { return resumeData }
        
        var downloadDestinationToURL: ((NSURLSession, NSURLSessionDownloadTask, NSURL) -> NSURL)?
        var downloadTaskDidWrited: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
        var downloadResumeTaskFileOffset: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64) -> Void)?
        var downloadDataCompleted: ((NSURLSession, NSURLSessionDownloadTask, NSURL, NSData?) -> Void)?
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
            
            if let successClosure = successClosure, data = NSData.init(contentsOfURL: location) {
                successClosure(downloadTask, data)
            }
            
//            if let downloadDestinationToURL = downloadDestinationToURL {
//                let destinationToURL = downloadDestinationToURL(session, downloadTask, location)
//                do {
//                    try NSFileManager.defaultManager().moveItemAtURL(location, toURL: destinationToURL)
//                    print("download destination: \(destinationToURL)")
//                } catch {
//                    self.error = error as NSError
//                    print("download write to file error: \(error)")
//                }
//                if let downloadDataCompleted = downloadDataCompleted {
//                    let data = NSData.init(contentsOfURL: destinationToURL)
//                    downloadDataCompleted(session, downloadTask, destinationToURL, data)
//                }
//            }
        }
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            downloadProgress.totalUnitCount = totalBytesExpectedToWrite
            downloadProgress.completedUnitCount = totalBytesWritten
//            print("download progress: \(self.downloadProgress.localizedDescription), \(downloadProgress)")
            if let downloadTaskDidWrited = downloadTaskDidWrited {
                downloadTaskDidWrited(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
            }
            
            if let progressClosure = progressClosure {
                progressClosure(self.downloadProgress)
            }
        }
        
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            downloadProgress.totalUnitCount = expectedTotalBytes
            downloadProgress.completedUnitCount = fileOffset
            if let downloadResumeTaskFileOffset = downloadResumeTaskFileOffset {
                downloadResumeTaskFileOffset(session, downloadTask, fileOffset, expectedTotalBytes)
            }
            if let progressClosure = progressClosure {
                progressClosure(self.downloadProgress)
            }
        }
        
    }
    
    
}

