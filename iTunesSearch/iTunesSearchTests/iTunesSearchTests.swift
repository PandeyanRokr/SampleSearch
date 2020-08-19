//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class iTunesSearchTests: XCTestCase {
    
    var albumViewModel = AlbumViewModel()

    func testFetchAlbum() {
        let expectation = self.expectation(description: "fetch_album")
        
        albumViewModel.fetchAlbum { (arrAlbum) in
            XCTAssertNotNil(arrAlbum)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            if error != nil {XCTFail("fetch album failed due to timeout.")}
        }
    }
    
    func testSortAlbumByArtist() {
        self.albumViewModel.sortAlbum(.Artist) {
            XCTAssertNotNil(self.albumViewModel.arrAlbum)
        }
        
    }
    
    func testSortAlbumByCollection() {
        albumViewModel.sortAlbum(.Collection) {
            XCTAssertNotNil(self.albumViewModel.arrAlbum)
        }
        
    }
    
    func testSortAlbumByTrack() {
        albumViewModel.sortAlbum(.Track) {
            XCTAssertNotNil(self.albumViewModel.arrAlbum)
        }
        
    }
    
    func testSortAlbumByPrice() {
        albumViewModel.sortAlbum(.Price) {
            XCTAssertNotNil(self.albumViewModel.arrAlbum)
        }
        
    }
    

}
