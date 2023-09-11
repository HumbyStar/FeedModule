//
//  File.swift
//  EssentialFeed
//
//  Created by Humberto Rodrigues on 08/09/23.
//

import Foundation

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (Error) -> Void)
    
    // Não queremos passar RemoteFeedLoader.Error, porque esse erro está no escopo da classe HTTPClient é um erro que vem da próprio requisição
    
    // O que a RemoteFeedLoader faz é mapear o erro que sai daqui para seu próprio domain error (.connectivity)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(url: url) { error in
            completion(.connectivity)
        }
        
        //Responsabilidade do RemoteFeedLoader chamar o método getURL da HTTPClient
        //Responsabilidade do RemoteFeedLoader localizar o HTTPClient na memória, isso os torna acoplados.
    }
}           // Precisa ter alguma URL em algum momento
