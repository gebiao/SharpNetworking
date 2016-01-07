//
//  Manager.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation
import UIKit

public class Manager {
    
    public static let sharedInstance: Manager = {
        let defaultConfiguation = NSURLSessionConfiguration.defaultSessionConfiguration()
        defaultConfiguation.HTTPAdditionalHeaders = Manager.defaultHttpHeardField
        
        return Manager(sessionConfiguration: defaultConfiguation)
    }()
    
    /// http heard field
    public static let defaultHttpHeardField: [String : String] = {
        
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        let acceptLanguages: String = NSLocale.preferredLanguages().enumerate().map { index, languageCode in
            let quality = 1.0 - Double(index)/10
            return "\(languageCode);q=\(quality)"
            }.joinWithSeparator(", ")
        
        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let bundleVersion = info[kCFBundleVersionKey as String] ?? "Unknow"
                let executeable = info[kCFBundleExecutableKey as String] ?? "Unkonw"
                let identifier = info[kCFBundleIdentifierKey as String] ?? "Unknow"
                let systemVersion = UIDevice.currentDevice().systemVersion
                
                return "\(executeable)/\(identifier) (\(bundleVersion); iOS \(systemVersion))"
            }
            return "SharpNetworking"
        }()
        
        
        return ["Accept-Encoding" : acceptEncoding,
            "Accept-Language" : acceptLanguages,
            "User-Agent" : userAgent
        ]
    }()
    
    /// The undering session
    public let session: NSURLSession
    
    public let delegate: SessionDelegate
    
    /// wheather start requst immediate
    public var startRequestImmediate: Bool = true
    
    private init(
        sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration(),
        delegate: SessionDelegate = SessionDelegate()) {
            self.delegate = delegate
            self.session = NSURLSession(configuration: sessionConfiguration, delegate: delegate, delegateQueue: nil)
    }
}


public class SessionDelegate : NSObject, NSURLSessionDelegate {
    
    //MARK: - sessionDelegate
    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        
    }
    
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
    }
    
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
    }
}








