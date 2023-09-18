//
//  HTTP.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 18/09/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
