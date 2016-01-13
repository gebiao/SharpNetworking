//
//  Upload.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

extension Manager {
    private enum Uploadable {
        case File(NSURLRequest, NSURL)
        case Data(NSURLRequest, NSData)
        case Stream(NSURLRequest)
    }
    
    private func upload(uploadable: Uploadable) -> Request {
        var uploadTask: NSURLSessionUploadTask!
        switch uploadable {
        case .File(let request, let fileURL):
            dispatch_sync(queue) { uploadTask = self.session.uploadTaskWithRequest(request, fromFile: fileURL) }
        case .Data(let request, let data):
            dispatch_sync(queue) { uploadTask = self.session.uploadTaskWithRequest(request, fromData: data) }
        case .Stream(let request):
            dispatch_sync(queue) { uploadTask = self.session.uploadTaskWithStreamedRequest(request) }
        }
        
        let request = Request(session: session, task: uploadTask)
        delegate[request.delegate.task] = request.delegate
        if startRequestImmediate {
            request.resume()
        }
        
        return request
    }
    
    public func upload(
        method: Method,
        URLString: String,
        parametes: [String : String]? = nil,
        encoding: ParameteEncoding = .URL,
        heards: [String : String]? = nil,
        progress: Request.ProgressClosure? = nil,
        success: Request.SuccessClosure? = nil,
        failure: Request.FailureClosure? = nil) -> Request {
            let mutableRequest = URLRequest(method, URLString: URLString, heard: heards)
            let request = upload(.Stream(mutableRequest))
            request.delegate.progressClosure = progress
            request.delegate.successClosure = success
            request.delegate.failureClosure = failure
            
            return request
    }
    
    public func upload(
        method: Method,
        URLString: String,
        encoding: ParameteEncoding = .URL,
        data: NSData,
        heards: [String : String]? = nil,
        progress: Request.ProgressClosure? = nil,
        success: Request.SuccessClosure? = nil,
        failure: Request.FailureClosure? = nil) -> Request {
            let mutableRequest = URLRequest(method, URLString: URLString, heard: heards)
            let request = upload(.Data(mutableRequest, data))
            request.delegate.progressClosure = progress
            request.delegate.successClosure = success
            request.delegate.failureClosure = failure
            
            return request
    }
    
    public func upload(
        method: Method,
        URLString: String,
        encoding: ParameteEncoding = .URL,
        fileURL: NSURL,
        heards: [String : String]? = nil,
        progress: Request.ProgressClosure? = nil,
        success: Request.SuccessClosure? = nil,
        failure: Request.FailureClosure? = nil) -> Request {
            let mutableRequest = URLRequest(method, URLString: URLString, heard: heards)
            let request = upload(.File(mutableRequest, fileURL))
            request.delegate.progressClosure = progress
            request.delegate.successClosure = success
            request.delegate.failureClosure = failure
            
            return request
    }
}



extension Request {
    
    class UploadTaskDelegate: TaskDelegate {
        
        var uploadProgress: NSProgress = NSProgress(totalUnitCount: 0)
        
        func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            uploadProgress.totalUnitCount = totalBytesExpectedToSend
            uploadProgress.completedUnitCount = totalBytesSent
            
            if let progressClosure = progressClosure {
                progressClosure(uploadProgress)
            }
        }
    }
}
