//
//  APIService.swift
//  StockEye
//
//  Created by Ankit Saxena on 07/07/21.
//

import Foundation
import Combine

struct APIService {
    
    private var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    private let keys = ["H5ERMC5EJWXNPHU9", "2HV1CG0V9883Q93X", "2VSFR0K5TEFGKKB8"]
    
    func fetchSymbolPublisher(keyword: String) -> AnyPublisher<SearchResults, Error>{
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(API_KEY)"
        
        return URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
