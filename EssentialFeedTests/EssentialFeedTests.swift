//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
import EssentialFeed

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error {
        case connectivity
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void = {_ in}) {
        client.get(url: url) { error in
            completion(.connectivity)
        }
    }
}


final class RemoteFeedTests: XCTestCase {
    
//    func test_init_doesNotRequestWithURL() {
//
//        let (_,client) = makeSUT()
//        XCTAssertTrue(client.requestURLs.isEmpty)
//    }
//
//    func test_load_requestWithURL() {
//        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
//        let (sut, client) = makeSUT(url: url)
//        sut.load()
//
//        XCTAssertEqual(client.requestURLs, [url])
//    }
//
//    func test_load_requestWithURLTwice() {
//        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
//        let (sut, client) = makeSUT(url: url)
//
//        sut.load()
//        sut.load()
//
//        XCTAssertEqual(client.requestURLs, [url,url])
//    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
    
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "test", code: 0)
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
        
    }
    
    func makeSUT(url: URL = URL(string:  "https://a-URL.com.br")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completions: (Error) -> Void)]()
        
        var requestURLs: [URL] {
            return messages.map({ $0.url })
        }
        
        func get(url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error) {
            messages[0].completions(error)
        }
    }
}
