//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 15/09/23.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { result in
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data: data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    /* Se voltarmos 1 ou 2 commits, vamos ver que aqui tinha um método map, e até poderiamos usa-lo dizendo que
     
     client.get(url: url) { [weak self] result in
        guard let self = self else { return }
     
     e assim chamariamos o self.map no completion de .success
     
     Porém iriamos ser refém da RemoteFeedLoader nunca estar dealocada, diferente do método com static que se encontra na FeedItemMapper. Por ela ser static por mais que RemoteFeedLoader esteja dealocada mesmo assim o método ira funcionar pois o método static não depende de algo instanciado.
     
     Isso é possivel com método static porque FeedItemMapper não conhece a implementação do client.
     */
}


