//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import Foundation

public class FeedItem: Equatable, Decodable {
    public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        let isEqual = lhs.id == rhs.id &&
                      lhs.description == rhs.description &&
                      lhs.location == rhs.location &&
                      lhs.imageURL == rhs.imageURL
        
        return isEqual
    }
    
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}

