//
//  File.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 08/09/23.
//

import Foundation

public protocol HTTPClient {
    func getURL(url: URL)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.getURL(url: url)
        
        //Responsabilidade do RemoteFeedLoader chamar o método getURL da HTTPClient
        //Responsabilidade do RemoteFeedLoader localizar o HTTPClient na memória, isso os torna acoplados.
    }
}           // Precisa ter alguma URL em algum momento
