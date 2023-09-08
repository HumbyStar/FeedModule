//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 06/09/23.
//

import Foundation

class FeedItem {
    let id: UUID
    let description: String?
    let location: String?
    let image: String
    
    init(id: UUID, description: String?, location: String?, image: String) {
        self.id = id
        self.description = description
        self.location = location
        self.image = image
    }
}
