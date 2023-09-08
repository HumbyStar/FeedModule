//
//  File.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 08/09/23.
//

import Foundation

protocol HTTPClient {
    func getURL(url: URL)
}

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.getURL(url: url)
        
        //Responsabilidade do RemoteFeedLoader chamar o método getURL da HTTPClient
        //Responsabilidade do RemoteFeedLoader localizar o HTTPClient na memória, isso os torna acoplados.
    }
}           // Precisa ter alguma URL em algum momento
