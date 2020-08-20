//
//  CartViewModel.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-20.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class CartViewModel: NSObject {
    
    var arrAlbum:[Album] = [Album]()
    var count = 0
    var totalPrice: Float = 0.0
    var currency = ""
    
    override init() {
        
    }
    
    func removeItemFromCart(index: Int, completion: @escaping(Int,Float)->Void) {
        arrAlbum.remove(at: index)
        self.getPriceAndCount { (itemsCount, priceValue) in
            completion(itemsCount, priceValue)
        }
    }
    
    func getPriceAndCount(completion: @escaping(Int,Float)->Void) {
        count = self.arrAlbum.count
        if count > 1 {
            totalPrice = self.arrAlbum.map { $0.collectionPrice }.reduce(0, +)
        }else if (count == 1) {
            totalPrice = self.arrAlbum.first!.collectionPrice
        }else {
            totalPrice = 0.0
        }
        
        completion(count,totalPrice)
    }

}
