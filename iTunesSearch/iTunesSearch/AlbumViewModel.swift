//
//  AlbumViewModel.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class AlbumViewModel: NSObject {
    
    var resultModel:ResultModel?
    var arrAlbum:[Album] = [Album]()
    var arrMainAlbum = [Album]()
    var lastSorted:SORTBY?
    
    func fetchAlbum(_ handler: @escaping ([Album]?)-> Void) {
        let appRequest = AppRequest()
        let headerParam = ["Content-Type":"application/json"]
        let strAPI = "https://itunes.apple.com/search?term=all"
        let request = appRequest.formRequest(api: strAPI, requestType: .GET, param: nil, header: headerParam)
        appRequest.apiRequest(urlRequest: request) { (json, urlResponse, error) in
            if error != nil {
                handler(nil)
            }else {
                if let jsonDict = json {
                    self.parseJsonData(response: jsonDict) { (arrayAlbum) in
                        handler(arrayAlbum)
                    }
                }else {
                    handler(nil)
                }
            }
        }
    }
    
    func parseJsonData(response: Dictionary<String,Any>, handler: @escaping ([Album]?)-> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options:.prettyPrinted) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            self.resultModel = try decoder.decode(ResultModel.self, from: jsonData)
            if let model = self.resultModel {
                var albumSet = Set<Album>()
                albumSet = Set(model.results)
                self.arrMainAlbum = Array(albumSet)
                self.arrAlbum = self.arrMainAlbum
                print(arrMainAlbum.count)
            }
            if let result = self.resultModel {
                handler(result.results)
            }
        } catch let error as NSError {
            print(error.debugDescription)
            handler(nil)
        }
    }
    
    func sortAlbum(_ sort: SORTBY, handler: @escaping()->Void) {
        var arrSorted = [Album]()
        switch sort {
        case .Artist:
            lastSorted = .Artist
            arrSorted = arrAlbum.sorted(by: {$0.artistName < $1.artistName})
        case .Collection:
            lastSorted = .Collection
            arrSorted = arrAlbum.sorted(by: {$0.collectionName ?? "" < $1.collectionName ?? ""})
        case .Track:
            lastSorted = .Track
            arrSorted = arrAlbum.sorted(by: {$0.trackName < $1.trackName})
        case .Price:
            lastSorted = .Price
            arrSorted = arrAlbum.sorted(by: {$0.collectionPrice > $1.collectionPrice})
        }
        self.arrAlbum = arrSorted
        handler()
    }
    
    func resetAlbum(handler: @escaping ()-> Void) {
        arrAlbum = arrMainAlbum
        handler()
    }
    
    func searchAlbum(_ txt: String, handler: @escaping ()-> Void) {
        if txt == "" {
            if self.lastSorted != nil {
                self.arrAlbum = self.arrMainAlbum
                self.sortAlbum(self.lastSorted!) {
                    handler()
                }
            }else {
                self.resetAlbum {
                    handler()
                }
            }
            
        }else {
            let arr = self.arrMainAlbum.filter({$0.artistName.lowercased().contains(txt) || $0.trackName.lowercased().contains(txt)})
            self.arrAlbum = arr
            handler()
        }
        
    }
    
}
