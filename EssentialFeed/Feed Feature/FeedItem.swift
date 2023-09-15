//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import Foundation

public class FeedItem: Equatable {
    public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return false
    }
    
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: String
    
    public init(id: UUID, description: String?, location: String?, image: String) {
        self.id = id
        self.description = description
        self.location = location
        self.image = image
    }
}
