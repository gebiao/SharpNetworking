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
    case URLEncodedInURL
    case JSON
    case PropertyList(plist: AnyObject, format: NSPropertyListFormat)
    case Custom
    
    func encoding(URLrequst: NSMutableURLRequest, parametes: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        
        guard let parametes = parametes else { return (URLrequst, nil)}
        var encodError: NSError? = nil
        
        switch self {
        case .URL, .URLEncodedInURL:
            
            func query(parametes: [String : AnyObject]) {
                for (key, value) in parametes {
                    
                }
                
            }
            
            func parametesEncodingInURL(method: Method) -> Bool {
                switch self {
                case .URLEncodedInURL:
                    return true
                default:
                    break
                }
                
                switch method {
                case .GET, .DELETE, .HEAD:
                    return true
                default:
                    return false
                }
            }
            
            if let method = Method(rawValue: URLrequst.HTTPMethod) where parametesEncodingInURL(method) {
                
            } else {
                
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
