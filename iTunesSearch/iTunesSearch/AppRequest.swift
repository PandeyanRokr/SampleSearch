//
//  AppRequest.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class AppRequest: NSObject {
    
    var urlSession:URLSession!
    
    override init() {
        
    }
    
    func formRequest(api:String,requestType:REQUEST_TYPE, param: Dictionary<String,Any>?, header: Dictionary<String,String>?)->URLRequest {
        let url = URL(string: api)!
        var urlRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        urlRequest.httpMethod = requestType.rawValue
        if header != nil {
            for (_,key) in header!.keys.enumerated() {
                urlRequest.setValue(header![key], forHTTPHeaderField: key)
            }
        }
        if param != nil {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: param!, options:.prettyPrinted) else {
                return urlRequest
            }
            urlRequest.httpBody = httpBody
        }
        
        return urlRequest
    }
    
    func apiRequest(urlRequest: URLRequest, handler: @escaping (Dictionary<String,Any>?,URLResponse?,Error?)-> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.timeoutIntervalForRequest = 60.0
        urlSession = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let recievedData = data {
                do {
                    
                    if let responseObj = try JSONSerialization.jsonObject(with: recievedData, options : []) as? Dictionary<String, Any>
                    {
                        handler(responseObj,response,error)
                    } else {
                        handler(nil,response,error)
                    }
                } catch let error as NSError {
                    handler(nil,response,error)
                }
            }else {
                handler(nil,response,error)
                
            }
        }.resume()
    }
    
    
}
