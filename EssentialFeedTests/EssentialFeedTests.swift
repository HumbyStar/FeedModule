//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL = (URL(string:  "https://a-URL.com.br")!)) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.getURL(url: url)
        
        //Responsabilidade do RemoteFeedLoader chamar o método getURL da HTTPClient
        //Responsabilidade do RemoteFeedLoader localizar o HTTPClient na memória, isso os torna acoplados.
    }
}           // Precisa ter alguma URL em algum momento

protocol HTTPClient {
    func getURL(url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestURL: URL?                    // RequestURL é apenas para fim de testes (produção)
    
    func getURL(url: URL) {
        requestURL = url
    }
}

final class RemoteFeedTests: XCTestCase {

    func tests_init_withoutURLRequest() {
        //let sut = RemoteFeedLoader() --------> Mas não faz sentido eu possui-lo porque eu não o uso
        
        let client = HTTPClientSpy()
        XCTAssertNil(client.requestURL)
    }
    
    func tests_init_withRequestURL() {
        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        
//        let url = URL(string: "https://possibilidadesDeOutroLink.com.br")!
        
        sut.load()
        
        XCTAssertEqual(client.requestURL, url)
    }

}
