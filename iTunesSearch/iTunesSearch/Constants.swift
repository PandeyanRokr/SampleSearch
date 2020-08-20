//
//  Constants.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import Foundation
import UIKit

let APP_MANAGER = AppManager.shared
let KEY_NETWORK_DISCONNECTED = "network_disconnected"


enum REQUEST_TYPE:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

extension Notification.Name {
    static let networkStatus = Notification.Name("network_status")
    static let cartDelete = Notification.Name("cart_delete")
}

enum SORTBY {
    case Artist
    case Collection
    case Track
    case Price
}

extension NSError {
    static func generalParsingError(domain: String) -> Error {
        return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
    }
}

