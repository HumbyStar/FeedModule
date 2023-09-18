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
                do {
                    let root = try FeedItemsMapper.map(data, response)
                    completion(.success(root))
                } catch {
                    completion(.failure(.invalidData))
                }
//                completion(self.map(data: data, response: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    public func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let root = try FeedItemsMapper.map(data, response)
            return .success(root)
        } catch {
            return .failure(.invalidData)
        }
    }
}


