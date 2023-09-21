//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 18/09/23.
//

import Foundation

internal struct FeedItemsMapper {
    private static let ok_url = 200
    
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map({ $0.item })
        }
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        internal var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }

    internal static func map(data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }

        return .success(root.feed)
    }
}

