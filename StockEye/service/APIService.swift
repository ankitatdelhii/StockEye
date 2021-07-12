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

        var keywords = String()
        switch parseQuery(text: keyword) {
        case .success(let result):
            keywords = result
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        switch parseUrl(stringUrl: urlString) {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    
    func fetchTimeSeriesMonthlyAdjustedPublisher(keyword: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {

        var symbol = String()
        switch parseQuery(text: keyword) {
        case .success(let result):
            symbol = result
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        
        switch parseUrl(stringUrl: urlString) {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func parseQuery(text: String) -> Result<String, Error> {
        guard let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return .failure(APIServiceError.encoding)
        }
        return .success(query)
    }
    
    private func parseUrl(stringUrl: String) -> Result<URL, Error> {
        guard let requestUrl = URL(string: stringUrl) else {
            return .failure(APIServiceError.badRequest)
        }
        return .success(requestUrl)
    }
    
}
