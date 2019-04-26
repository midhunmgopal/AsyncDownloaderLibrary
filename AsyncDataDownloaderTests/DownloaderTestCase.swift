//
//  DownloaderTestCase.swift
//  AsyncDataDownloaderTests
//
//  Created by Midhun on 27/04/19.
//  Copyright © 2019 Midhun. All rights reserved.
//

import XCTest
@testable import AsyncDataDownloader

class DownloaderTestCase: XCTestCase {

    var downloader: Downloader?
    let url = "https://i.etsystatic.com/15364217/r/il/0401af/1565696411/il_794xN.1565696411_n9jf.jpg"
    
    override func setUp() {
        downloader = Downloader()
    }

    override func tearDown() {
        downloader = nil
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testValidateURL() {
        guard URL(string: url) != nil else {
            fatalError("URL cannot be nil")
        }
    }
    
    func testDownloadWithURL() {
        downloader?.downloadWith(urlString: url, completion: { (data, error) in
            XCTAssert(error == nil, "Error occured: \(error?.localizedDescription ?? "")")
            
            guard data != nil else {
                fatalError("Response is empty")
            }
        })
    }
}
