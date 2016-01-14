//
//  Stream.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/14/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

extension Manager {
    
    enum Streamable {
        case HostName(String, Int)
        case NetSeverice(NSNetService)
    }
    
    func stream(streamable: Streamable) -> Request {
        
        var streamTask: NSURLSessionStreamTask!
        switch streamable {
        case .HostName(let hostName, let port):
            dispatch_sync(queue) { streamTask = self.session.streamTaskWithHostName(hostName, port: port) }
        case .NetSeverice(let service):
            dispatch_sync(queue) { streamTask = self.session.streamTaskWithNetService(service) }
        }
        
        let request = Request(session: session, task: streamTask)
        delegate[request.delegate.task] = request.delegate
        
        if startRequestImmediate {
            request.resume()
        }
        
        return request
    }
    
}

extension Request {
    
    class StreamTaskDelegate: TaskDelegate, NSURLSessionStreamDelegate {
        
        func URLSession(session: NSURLSession, readClosedForStreamTask streamTask: NSURLSessionStreamTask) {
            
        }
        
        func URLSession(session: NSURLSession, writeClosedForStreamTask streamTask: NSURLSessionStreamTask) {
            
        }
        
        func URLSession(session: NSURLSession, betterRouteDiscoveredForStreamTask streamTask: NSURLSessionStreamTask) {
            
        }
        
        func URLSession(session: NSURLSession, streamTask: NSURLSessionStreamTask, didBecomeInputStream inputStream: NSInputStream, outputStream: NSOutputStream) {
            
        }
    }
}