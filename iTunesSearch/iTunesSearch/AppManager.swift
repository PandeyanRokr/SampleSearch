//
//  AppManager.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit
import Network

class AppManager: NSObject {
    
    static let shared = AppManager()
    let monitor = NWPathMonitor()
    let imageCache = NSCache<NSString, UIImage>()
    
    private override init() {
        
    }
    
    //MARK:- Start Network Monitor
    func startMonitoring() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Yay! We have internet!")
                NotificationCenter.default.post(name: .networkStatus, object: nil, userInfo: [KEY_NETWORK_DISCONNECTED:false])
                
            }else {
                print("No internet!")
                NotificationCenter.default.post(name: .networkStatus, object: nil, userInfo: [KEY_NETWORK_DISCONNECTED:true])
                
            }
        }
    }
    
    //MARK:- Download Image From URL
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            APP_MANAGER.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    APP_MANAGER.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                }
            }
        }
    }
    
    //MARK:- Download Data From URL
    fileprivate func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.timeoutIntervalForRequest = 60.0
        URLSession(configuration: sessionConfig).dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

}
