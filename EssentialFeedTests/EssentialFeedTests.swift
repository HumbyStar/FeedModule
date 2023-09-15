//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
import EssentialFeed

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

        expect(sut, result: .failure(.connectivity), when: {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, result: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPInvalidData() {
        let (sut, client) = makeSUT()
        
        expect(sut, result: .failure(.invalidData), when: {
            let invalidJson = Data(_ : "Invalid Json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }
    
    func test_load_delivers200HTTPEmptyData() {
        let (sut, client) = makeSUT()

        expect(sut, result: .success([])) {
            let emptyJson = Data(_ : "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyJson)
        }
    }
    
    func test_load_delivers200HTTPSuccessJson() {
        let (sut, client) = makeSUT()
        
        let item1 = FeedItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageURL: URL(string: "https//test-url.com.br")!)
        
        let item1Json: [String: Any] = [
            "id": item1.id.uuidString,
            "image": item1.imageURL.absoluteString
        ]
        
        let item2 = FeedItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "https://testing-another-url.com.br")!)
        
        let item2Json: [String: Any] = [
            "id": item2.id.uuidString,
            "description": item2.description ?? "",
            "location": item2.location ?? "",
            "image": item2.imageURL.absoluteString
        ]
        
        let jsonItems = [
            "items": [
                item1Json,
                item2Json
            ]
        ]
        
        expect(sut, result: .success([item1, item2])) {
            let json = try! JSONSerialization.data(withJSONObject: jsonItems)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    //Helpers
    
    func makeSUT(url: URL = URL(string:  "https://example-URL.com.br")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    func expect(_ sut: RemoteFeedLoader, result: RemoteFeedLoader.Result, when: () -> Void,  file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        when()
        XCTAssertEqual(capturedResults, [(result)], file: file, line: line)
    }
    
    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completions: (HTTPClientResult) -> Void)]()
        
        var requestURLs: [URL] {
            return messages.map({ $0.url })
        }
        
        func get(url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completions(.failure(error))
        }
        
        func complete(withStatusCode status: Int, data: Data = Data(), at index: Int = 0) {
           let response = HTTPURLResponse(url: requestURLs[index],
                                          statusCode: status,
                                          httpVersion: nil,
                                          headerFields: nil)!
            messages[index].completions(.success(data, response))
        }
    }
}
