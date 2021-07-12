//
//  String+Extensions.swift
//  StockEye
//
//  Created by Ankit Saxena on 12/07/21.
//

import Foundation

extension String {
    
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
}
