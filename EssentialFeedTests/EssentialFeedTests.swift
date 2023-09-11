//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
import EssentialFeed

import EssentialFeed

final class RemoteFeedTests: XCTestCase {
    
    func test_init_doesNotRequestWithURL() {
        
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestWithURL() {
        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_load_requestWithURLTwice() {
        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url,url])
    }
    
    func makeSUT(url: URL = URL(string:  "https://a-URL.com.br")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
    // RequestURL é apenas para fim de testes (produção)
        var requestURLs = [URL]()
        
        func getURL(url: URL) {
            requestURLs.append(url)
        }
    }
}
