//
//  APIService.swift
//  StockEye
//
//  Created by Ankit Saxena on 07/07/21.
//

import Foundation
import Combine

struct APIService {
    
    private enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    private var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    private let keys = ["H5ERMC5EJWXNPHU9", "2HV1CG0V9883Q93X", "2VSFR0K5TEFGKKB8"]
    
    func fetchSymbolPublisher(keyword: String) -> AnyPublisher<SearchResults, Error>{
        guard let keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(API_KEY)"
        guard let requestUrl = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTimeSeriesMonthlyAdjustedPublisher(keyword: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        guard let keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(keyword)&apikey=\(API_KEY)"
        guard let requestUrl = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .map({$0.data})
            .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
