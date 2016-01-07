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
    ) -> Requset {
        
        return Manager.sharedInstance.request(method, URLString: URLString, parameters: parameters, encoding: encoding, heard: heard)
}