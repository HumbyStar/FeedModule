//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import Foundation

public enum LoadFeedItems<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedItems: Equatable where Error: Equatable {}

protocol FeedLoader {
    func load(completion: (LoadFeedItems<Error>) -> Void)
}
 
