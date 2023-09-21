//
//  RemoteFeedLoader.swift
//  EssentialFeed

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedItems
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { [weak self] result in
            guard self != nil  else {return}
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}


