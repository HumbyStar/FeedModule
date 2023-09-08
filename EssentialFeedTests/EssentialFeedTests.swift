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
        HTTPClient.shared.getURL(url: URL(string: "https://a-URL.com.br")!)
    }
}           // Precisa ter alguma URL em algum momento

class HTTPClient {
    static var shared = HTTPClient()
    func getURL(url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestURL: URL?                    // RequestURL é apenas para fim de testes (produção)
    
    override func getURL(url: URL) {
        requestURL = url
    }
}

final class RemoteFeedTests: XCTestCase {

    func tests_init_withoutURLRequest() {
        //let sut = RemoteFeedLoader() --------> Mas não faz sentido eu possui-lo porque eu não o uso
        let client = HTTPClientSpy()
        
        HTTPClient.shared = client
        
        XCTAssertNil(client.requestURL)
    }
    
    func tests_init_withRequestURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClientSpy()
        
        HTTPClient.shared = client
        
        sut.load()
        
        XCTAssertNotNil(client.requestURL)
    }

}
