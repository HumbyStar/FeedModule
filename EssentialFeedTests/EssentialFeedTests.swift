//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
import EssentialFeed

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(url: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}


final class RemoteFeedTests: XCTestCase {
    
    func test_init_doesNotRequestWithURL() {

        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestURLs.isEmpty)
    }

    func test_load_requestWithURL() {
        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in}

        XCTAssertEqual(client.requestURLs, [url])
    }

    func test_load_requestWithURLTwice() {
        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        let (sut, client) = makeSUT(url: url)

        sut.load {_ in}
        sut.load {_ in}

        XCTAssertEqual(client.requestURLs, [url,url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
    
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "test", code: 0)
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        
         sut.load { capturedErrors.append($0) }
        
        [199, 201, 300, 400, 500].forEach { code in
            
            client.complete(withErrorStatus: code)
            print(capturedErrors.count)
            XCTAssertEqual(capturedErrors, [.invalidData])
            
            capturedErrors = []
        }
    }
    
    func makeSUT(url: URL = URL(string:  "https://a-URL.com.br")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completions: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestURLs: [URL] {
            return messages.map({ $0.url })
        }
        
        func get(url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completions(error, nil)
        }
        
        func complete(withErrorStatus status: Int, at index: Int = 0) {
           let response = HTTPURLResponse(url: requestURLs[index],
                                          statusCode: status,
                                          httpVersion: nil,
                                          headerFields: nil)
            messages[index].completions(nil, response)
        }
    }
}
