//
//  ParamentsEncoding.swift
//  SharpNetworking
//
//  Created by SharpSnake on 1/7/16.
//  Copyright © 2016 GB Softwore Foundation. All rights reserved.
//

import Foundation

public enum Method: String {
    case GET, POST, PUT, PATCH, HEAD, DELETE
}

public enum ParameteEncoding {
    case URL
    case URLEncoding
    case JSON
    case PropertyList(plist: AnyObject, format: NSPropertyListFormat)
    case Custom
    
    func encoding(URLrequst: NSMutableURLRequest, parametes: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        
        guard let parametes = parametes else { return (URLrequst, nil)}
        var encodError: NSError? = nil
        
        switch self {
        case .URL, .URLEncoding:
            
            if let method = Method(rawValue: URLrequst.HTTPMethod) {
                
            }
        case .JSON:
            do {
                let writeOption = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parametes, options: writeOption)
                URLrequst.HTTPBody = data
                URLrequst.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                encodError = error as NSError
            }
        case .PropertyList(let obj, let format):
            do {
                let writeOption = NSPropertyListWriteOptions()
                let data = try NSPropertyListSerialization.dataWithPropertyList(obj, format: format, options: writeOption)
                URLrequst.HTTPBody = data
                URLrequst.setValue("Plist/x", forHTTPHeaderField: "Content-Type")
            } catch {
                encodError = error as NSError
            }
        case .Custom:
            print("custom")
        default:
            print("no-op")
        }
        
        return (URLrequst, encodError)
    }
}
