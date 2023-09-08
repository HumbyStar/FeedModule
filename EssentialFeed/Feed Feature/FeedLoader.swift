//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import Foundation

enum LoadFeedItems {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: (LoadFeedItems) -> Void)
}
