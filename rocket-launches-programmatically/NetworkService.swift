//
//  NetworkService.swift
//  rocket-launches-programmatically
//
//  Created by Кирилл Васильев on 25.06.2023.
//

import Apollo
import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private(set) var apollo = ApolloClient(url: URL(string: "https://spacex-production.up.railway.app/)")!)
                                            
    private init() { }
}
