//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestURL = "https://a-URL.com.br"
    }
}           // Precisa ter alguma URL em algum momento

class HTTPClient {
    static let shared = HTTPClient()
    var requestURL: String?
    
    private init(){}
    
}

final class RemoteFeedTests: XCTestCase {

    func tests_init_withoutURLRequest() {
        //let sut = RemoteFeedLoader() --------> Mas não faz sentido eu possui-lo porque eu não o uso
        let client = HTTPClient.shared
        
        XCTAssertNil(client.requestURL)
    }
    
    func tests_init_withRequestURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClient.shared
        
        sut.load()
        
        XCTAssertNotNil(client.requestURL)
    }

}
