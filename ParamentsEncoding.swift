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
    
    func encoding(URLRequst: NSMutableURLRequest, parametes: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        
        guard let parametes = parametes else { return (URLRequst, nil)}
        var encodError: NSError? = nil
        
        switch self {
        case .URL, .URLEncodedInURL:
            
            func query(parametes: [String : AnyObject]) -> String {
                var allParametes: [(String, String)] = []
                
                for key in parametes.keys.sort(<) {
                    allParametes += queryComponment(key, value: parametes[key]!)
                }
                return (allParametes.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
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
            
            if let method = Method(rawValue: URLRequst.HTTPMethod) where parametesEncodingInURL(method) {
                if let urlComponent = NSURLComponents(URL: URLRequst.URL!, resolvingAgainstBaseURL: false) {
                    urlComponent.percentEncodedQuery = urlComponent.percentEncodedQuery.map { "\($0)" + "&"} ?? "" + query(parametes)
                    URLRequst.URL = urlComponent.URL
                }
            } else {
                URLRequst.setValue("charset=utf-8", forHTTPHeaderField: "Content-Type")
                let data = query(parametes).dataUsingEncoding(NSUTF8StringEncoding)
                URLRequst.HTTPBody = data
            }
        case .JSON:
            do {
                let writeOption = NSJSONWritingOptions()
                let data = try NSJSONSerialization.dataWithJSONObject(parametes, options: writeOption)
                URLRequst.HTTPBody = data
                URLRequst.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                encodError = error as NSError
            }
        case .PropertyList(let obj, let format):
            do {
                let writeOption = NSPropertyListWriteOptions()
                let data = try NSPropertyListSerialization.dataWithPropertyList(obj, format: format, options: writeOption)
                URLRequst.HTTPBody = data
                URLRequst.setValue("Plist/x", forHTTPHeaderField: "Content-Type")
            } catch {
                encodError = error as NSError
            }
        case .Custom:
            print("custom")
        }
        
        return (URLRequst, encodError)
    }
    
    public func queryComponment(key: String, value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dic = value as? [String : AnyObject] {
            for (nestedKey, value) in dic {
                components += queryComponment("\(nestedKey)[\(key)]", value: value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponment("\(key)[]", value: value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }
    
    public func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        let batchSize = 50
        var index = string.startIndex
        
        while index != string.endIndex {
            let startIndex = index
            let endIndex = index.advancedBy(batchSize, limit: string.endIndex)
            let range = Range(start: startIndex, end: endIndex)
            
            let substring = string.substringWithRange(range)
            
            escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring
            
            index = endIndex
        }
        
        return escaped
    }
}
